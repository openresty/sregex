
/*
 * Copyright 2012 Yichun "agentzh" Zhang
 * Copyright 2007-2009 Russ Cox.  All Rights Reserved.
 * Use of this source code is governed by a BSD-style
 * license that can be found in the LICENSE file.
 */


#ifndef DDEBUG
#define DDEBUG 0
#endif
#include <sregex/ddebug.h>


#include <sregex/sre_vm_pike.h>
#include <sregex/sre_capture.h>


#define sre_vm_pike_free_thread(ctx, t)                                     \
    (t)->next = (ctx)->free_threads;                                        \
    (ctx)->free_threads = t;


enum {
    SRE_VM_PIKE_SEEN_WORD = 1
};


typedef struct sre_vm_pike_thread_s  sre_vm_pike_thread_t;

struct sre_vm_pike_thread_s {
    sre_instruction_t       *pc;
    sre_capture_t           *capture;
    sre_vm_pike_thread_t    *next;
    unsigned                 seen_word; /* :1 */
};


typedef struct {
    sre_vm_pike_thread_t     *head;
    sre_vm_pike_thread_t    **next;
} sre_vm_pike_thread_list_t;


struct sre_vm_pike_ctx_s {
    unsigned                 tag;
    unsigned                 processed_bytes;
    u_char                  *buffer;
    sre_pool_t              *pool;
    sre_program_t           *program;
    sre_capture_t           *matched;
    sre_capture_t           *free_capture;
    sre_vm_pike_thread_t    *free_threads;

    int                     *ovector;
    unsigned                 ovecsize;

    sre_vm_pike_thread_list_t       *current_threads;
    sre_vm_pike_thread_list_t       *next_threads;

    unsigned                 first_buf; /* :1 */
} ;


static sre_vm_pike_thread_list_t *sre_vm_pike_thread_list_create(
    sre_pool_t *pool, int size);
static int sre_vm_pike_add_thread(sre_vm_pike_ctx_t *ctx,
    sre_vm_pike_thread_list_t *l, sre_instruction_t *pc, sre_capture_t *capture,
    int pos);
static void sre_vm_pike_prepare_temp_captures(sre_vm_pike_ctx_t *ctx);


sre_vm_pike_ctx_t *
sre_vm_pike_create_ctx(sre_pool_t *pool, sre_program_t *prog, int *ovector,
    unsigned ovecsize, int offset)
{
    unsigned                         len;
    sre_vm_pike_ctx_t               *ctx;
    sre_vm_pike_thread_list_t       *clist, *nlist;

    ctx = sre_palloc(pool, sizeof(sre_vm_pike_ctx_t));
    if (ctx == NULL) {
        return NULL;
    }

    ctx->pool = pool;
    ctx->program = prog;
    ctx->processed_bytes = offset;

    len = prog->len;

    clist = sre_vm_pike_thread_list_create(pool, len);
    if (clist == NULL) {
        return NULL;
    }

    ctx->current_threads = clist;

    nlist = sre_vm_pike_thread_list_create(pool, len);
    if (nlist == NULL) {
        return NULL;
    }

    ctx->next_threads = nlist;

    ctx->program = prog;
    ctx->pool = pool;
    ctx->free_capture = NULL;
    ctx->free_threads = NULL;
    ctx->matched = NULL;

    ctx->ovecsize = ovecsize;
    ctx->ovector = ovector;

    ctx->first_buf = 1;

    return ctx;
}


int
sre_vm_pike_exec(sre_vm_pike_ctx_t *ctx, u_char *input, size_t size,
    unsigned eof)
{
    u_char                    *sp, *last;
    unsigned                   i;
    unsigned                   in;
    sre_pool_t                *pool;
    sre_program_t             *prog;
    sre_capture_t             *cap, *matched;
    sre_vm_range_t            *range;
    sre_instruction_t         *pc;
    sre_vm_pike_thread_t      *t;
    sre_vm_pike_thread_list_t *clist, *nlist, *tmp;
    sre_vm_pike_thread_list_t  list;

    pool = ctx->pool;
    prog = ctx->program;
    clist = ctx->current_threads;
    nlist = ctx->next_threads;
    matched = ctx->matched;

    ctx->buffer = input;

    if (ctx->first_buf) {
        ctx->first_buf = 0;

        cap = sre_capture_create(pool, ctx->ovecsize, 1);
        if (cap == NULL) {
            return SRE_ERROR;
        }

        ctx->tag = prog->tag + 1;
        if (sre_vm_pike_add_thread(ctx, clist, prog->start, cap, 0) != SRE_OK) {
            prog->tag = ctx->tag;
            return SRE_ERROR;
        }

    } else {
        ctx->tag = prog->tag;
    }

    last = input + size;

    for (sp = input; sp < last || (eof && sp == last); sp++) {
        dd("=== pos %d (char '%c' (%d)).\n", (int)(sp - input),
           sp < last ? *sp : '?', sp < last ? *sp : 0);

        if (clist->head == NULL) {
            dd("clist empty. abort.");
            break;
        }

#if (DDEBUG)
        fprintf(stderr, "cur list:");
        for (t = clist->head; t; t = t->next) {
            fprintf(stderr, " %d", (int) (t->pc - prog->start));
        }
        fprintf(stderr, "\n");
#endif

        ctx->tag++;

        while (clist->head) {
            t = clist->head;
            clist->head = t->next;

            pc = t->pc;
            cap = t->capture;

            dd("--- #%u: pc %d: opcode %d\n", ctx->tag, (int)(pc - prog->start),
               pc->opcode);

            switch (pc->opcode) {
            case SRE_OPCODE_IN:
                if (sp == last) {
                    sre_capture_decr_ref(ctx, cap);
                    break;
                }

                in = 0;
                for (i = 0; i < pc->v.ranges->count; i++) {
                    range = &pc->v.ranges->head[i];

                    dd("testing %d for [%d, %d] (%u)", *sp, range->from,
                       range->to, i);

                    if (*sp >= range->from && *sp <= range->to) {
                        in = 1;
                        break;
                    }
                }

                if (!in) {
                    sre_capture_decr_ref(ctx, cap);
                    break;
                }

                if (sre_vm_pike_add_thread(ctx, nlist, pc + 1, cap,
                                           (int) (sp - input + 1))
                    != SRE_OK)
                {
                    prog->tag = ctx->tag;
                    return SRE_ERROR;
                }

                break;

            case SRE_OPCODE_NOTIN:
                if (sp == last) {
                    sre_capture_decr_ref(ctx, cap);
                    break;
                }

                in = 0;
                for (i = 0; i < pc->v.ranges->count; i++) {
                    range = &pc->v.ranges->head[i];

                    dd("testing %d for [%d, %d] (%u)", *sp, range->from,
                       range->to, i);

                    if (*sp >= range->from && *sp <= range->to) {
                        in = 1;
                        break;
                    }
                }

                if (in) {
                    sre_capture_decr_ref(ctx, cap);
                    break;
                }

                if (sre_vm_pike_add_thread(ctx, nlist, pc + 1, cap,
                                           (int) (sp - input + 1))
                    != SRE_OK)
                {
                    prog->tag = ctx->tag;
                    return SRE_ERROR;
                }

                break;

            case SRE_OPCODE_CHAR:

                dd("matching char '%c' (%d) against %d",
                   sp != last ? *sp : '?', sp != last ? *sp : 0, pc->v.ch);

                if (sp == last || *sp != pc->v.ch) {
                    sre_capture_decr_ref(ctx, cap);
                    break;
                }

                if (sre_vm_pike_add_thread(ctx, nlist, pc + 1, cap,
                                           (int) (sp - input + 1))
                    != SRE_OK)
                {
                    prog->tag = ctx->tag;
                    return SRE_ERROR;
                }

                break;

            case SRE_OPCODE_ANY:

                if (sp == last) {
                    sre_capture_decr_ref(ctx, cap);
                    break;
                }

                if (sre_vm_pike_add_thread(ctx, nlist, pc + 1, cap,
                                           (int) (sp - input + 1))
                    != SRE_OK)
                {
                    prog->tag = ctx->tag;
                    return SRE_ERROR;
                }

                break;

            case SRE_OPCODE_ASSERT:
                switch (pc->v.assertion_type) {
                case SRE_REGEX_ASSERTION_SMALL_Z:
                    if (sp != last) {
                        break;
                    }

                    goto assertion_hold;

                case SRE_REGEX_ASSERTION_DOLLAR:

                    if (sp != last && *sp != '\n') {
                        break;
                    }

                    goto assertion_hold;

                case SRE_REGEX_ASSERTION_BIG_B:

                    if (t->seen_word ^ (sp != last && sre_isword(*sp))) {
                        break;
                    }

                    dd("\\B assertion passed: %u %c", t->seen_word, *sp);

                    goto assertion_hold;

                case SRE_REGEX_ASSERTION_SMALL_B:

                    if ((t->seen_word ^ (sp != last && sre_isword(*sp))) == 0) {
                        break;
                    }

                    dd("\\b assertion passed: %u %c", t->seen_word, *sp);

                    goto assertion_hold;

                default:
                    /* impossible to reach here */
                    break;
                }

                break;

assertion_hold:
                ctx->tag--;

                list.head = NULL;
                if (sre_vm_pike_add_thread(ctx, &list, pc + 1, cap,
                                           (int)(sp - input))
                    != SRE_OK)
                {
                    prog->tag = ctx->tag + 1;
                    return SRE_ERROR;
                }

                if (list.head) {
                    *list.next = clist->head;
                    clist->head = list.head;
                }

                ctx->tag++;
                break;

            case SRE_OPCODE_MATCH:

                if (matched) {

                    dd("discarding match: ");
#if (DDEBUG)
                    sre_capture_dump(matched);
#endif

                    sre_capture_decr_ref(ctx, matched);
                }

                matched = cap;

                sre_vm_pike_free_thread(ctx, t);

                while (clist->head) {
                    t = clist->head;
                    clist->head = t->next;

                    sre_capture_decr_ref(ctx, t->capture);
                    sre_vm_pike_free_thread(ctx, t);
                }

                goto step_done;

                /*
                 * Jmp, Split, Save handled in addthread, so that
                 * machine execution matches what a backtracker would do.
                 * This is discussed (but not shown as code) in
                 * Regular Expression Matching: the Virtual Machine Approach.
                 */
            default:
                /* impossible to reach here */
                break;
            }

            sre_vm_pike_free_thread(ctx, t);
        } /* while */

step_done:
        tmp = clist;
        clist = nlist;
        nlist = tmp;

        if (nlist->head) {
            *nlist->next = ctx->free_threads;
            ctx->free_threads = nlist->head;
            nlist->head = NULL;
        }

        if (sp == last) {
            break;
        }
    } /* for */

    ctx->matched = matched;

    dd("matched: %p, clist: %p", matched, clist->head);

    if (matched && (clist->head == NULL || eof)) {
        memcpy(ctx->ovector, matched->vector, ctx->ovecsize);
        /* sre_capture_decr_ref(matched, freecap); */
        prog->tag = ctx->tag;
        ctx->processed_bytes += sp - input;
        return SRE_OK;
    }

    prog->tag = ctx->tag;

    ctx->processed_bytes += sp - input;
    ctx->current_threads = clist;
    ctx->next_threads = nlist;

    if (eof) {
        return SRE_DECLINED;
    }

    dd("processed bytes: %u", ctx->processed_bytes);

    sre_vm_pike_prepare_temp_captures(ctx);

    return SRE_AGAIN;
}


static void
sre_vm_pike_prepare_temp_captures(sre_vm_pike_ctx_t *ctx)
{
    int                      i, a, b;
    int                      ngroups;
    sre_capture_t           *cap;
    sre_vm_pike_thread_t    *t;

    t = ctx->current_threads->head;
    if (t) {

        ngroups = ctx->ovecsize / sizeof(int);

        dd("ngroups: %d", ngroups);

        memcpy(ctx->ovector, t->capture->vector, ctx->ovecsize);

        for (t = t->next; t; t = t->next) {
            cap = t->capture;

            for (i = 0; i < ngroups; i += 2) {
                a = ctx->ovector[i];
                b = cap->vector[i];

                if (b != -1 && (a == -1 || b < a)) {
                    dd("setting group %d to %d", i, cap->vector[i]);
                    ctx->ovector[i] = b;
                }

                a = ctx->ovector[i + 1];
                b = cap->vector[i + 1];

                if (b != -1 && (a == -1 || b > a)) {
                    dd("setting group %d to %d", i + 1, cap->vector[i + 1]);
                    ctx->ovector[i + 1] = b;
                }
            }
        }
    }
}


static sre_vm_pike_thread_list_t *
sre_vm_pike_thread_list_create(sre_pool_t *pool, int size)
{
    sre_vm_pike_thread_list_t       *l;

    l = sre_palloc(pool, sizeof(sre_vm_pike_thread_list_t));
    if (l == NULL) {
        return NULL;
    }

    l->head = NULL;
    l->next = &l->head;

    return l;
}


static int
sre_vm_pike_add_thread(sre_vm_pike_ctx_t *ctx, sre_vm_pike_thread_list_t *l,
    sre_instruction_t *pc, sre_capture_t *capture, int pos)
{
    sre_vm_pike_thread_t        *t;
    sre_capture_t               *cap;
    unsigned                     seen_word = 0;

#if 0
    dd("pc tag: %u, ctx tag: %u", pc->tag, ctx->tag);
#endif

    if (pc->tag == ctx->tag) {
        dd("pc %d: already on list: %d", (int) (pc - ctx->program->start),
           pc->tag);

        if (pc->opcode == SRE_OPCODE_SPLIT) {
            if (pc->y->tag != ctx->tag) {
                return sre_vm_pike_add_thread(ctx, l, pc->y, capture, pos);
            }
        }

        return SRE_OK;
    }

    dd("adding thread: pc %d, bytecode %d", (int) (pc - ctx->program->start),
       pc->opcode);

    pc->tag = ctx->tag;

    switch (pc->opcode) {
    case SRE_OPCODE_JMP:
        return sre_vm_pike_add_thread(ctx, l, pc->x, capture, pos);

    case SRE_OPCODE_SPLIT:
        capture->ref++;

        if (sre_vm_pike_add_thread(ctx, l, pc->x, capture, pos)
            != SRE_OK)
        {
            return SRE_ERROR;
        }

        return sre_vm_pike_add_thread(ctx, l, pc->y, capture, pos);

    case SRE_OPCODE_SAVE:

#if 0
        dd("pc %d: cap %p: save %d as group %d",
           (int) (pc - ctx->program->start), capture, pos,
           pc->v.group);
#endif

        dd("processed bytes: %u, pos: %u", ctx->processed_bytes, pos);

        cap = sre_capture_update(ctx->pool, capture, pc->v.group,
                                 ctx->processed_bytes + pos,
                                 &ctx->free_capture);
        if (cap == NULL) {
            return SRE_ERROR;
        }

#if 0
        dd("new cap: %p", cap);
#endif

        return sre_vm_pike_add_thread(ctx, l, pc + 1, cap, pos);


    case SRE_OPCODE_ASSERT:
        switch (pc->v.assertion_type) {
        case SRE_REGEX_ASSERTION_BIG_A:
            if (pos != 0) {
                break;
            }

            return sre_vm_pike_add_thread(ctx, l, pc + 1, capture, pos);

        case SRE_REGEX_ASSERTION_CARET:
            if (pos != 0 && ctx->buffer[pos - 1] != '\n') {
                break;
            }

            return sre_vm_pike_add_thread(ctx, l, pc + 1, capture, pos);

        case SRE_REGEX_ASSERTION_SMALL_B:
        case SRE_REGEX_ASSERTION_BIG_B:
            {
                u_char c;

                if (pos == 0) {
                    seen_word = 0;

                } else {
                    c = ctx->buffer[pos - 1];
                    seen_word = sre_isword(c);
                }

                goto add;
            }

        default:
            /* postpone look-ahead assertions */
            goto add;
        }

        break;

    default:

add:
        if (ctx->free_threads) {
            /* fprintf(stderr, "reusing free thread\n"); */

            t = ctx->free_threads;
            ctx->free_threads = t->next;
            t->next = NULL;

        } else {
            /* fprintf(stderr, "creating new thread\n"); */

            t = sre_palloc(ctx->pool, sizeof(sre_vm_pike_thread_t));
            if (t == NULL) {
                return SRE_ERROR;
            }
        }

        t->pc = pc;
        t->capture = capture;
        t->next = NULL;
        t->seen_word = seen_word;

        if (l->head == NULL) {
            l->head = t;

        } else {
            *l->next = t;
        }

        l->next = &t->next;

        dd("added thread: pc %d, bytecode %d", (int) (pc - ctx->program->start),
           pc->opcode);

        break;
    }

    return SRE_OK;
}

