
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


#include <sregex/sre_vm_thompson.h>


typedef struct {
    sre_instruction_t       *pc;
    unsigned                 seen_word; /* :1 */
} sre_vm_thompson_thread_t;


typedef struct {
    unsigned                    count;
    sre_vm_thompson_thread_t   *threads;
} sre_vm_thompson_thread_list_t;


struct sre_vm_thompson_ctx_s {
    sre_pool_t          *pool;
    sre_program_t       *program;
    unsigned             tag;
    u_char              *buffer;

    sre_vm_thompson_thread_list_t       *current_threads;
    sre_vm_thompson_thread_list_t       *next_threads;

    unsigned             first_buf;     /* :1 */
};


static void sre_vm_thompson_add_thread(sre_vm_thompson_ctx_t *ctx,
    sre_vm_thompson_thread_list_t *l, sre_instruction_t *pc, u_char *sp);
static sre_vm_thompson_thread_list_t *sre_vm_thompson_thread_list_create(
    sre_pool_t *pool, int size);



sre_vm_thompson_ctx_t *
sre_vm_thompson_create_ctx(sre_pool_t *pool, sre_program_t *prog)
{
    unsigned                         len;
    sre_vm_thompson_ctx_t           *ctx;
    sre_vm_thompson_thread_list_t   *clist, *nlist;

    ctx = sre_palloc(pool, sizeof(sre_vm_thompson_ctx_t));
    if (ctx == NULL) {
        return NULL;
    }

    ctx->pool = pool;
    ctx->program = prog;

    len = prog->len;

    clist = sre_vm_thompson_thread_list_create(pool, len);
    if (clist == NULL) {
        return NULL;
    }

    ctx->current_threads = clist;

    nlist = sre_vm_thompson_thread_list_create(pool, len);
    if (nlist == NULL) {
        return NULL;
    }

    ctx->next_threads = nlist;

    ctx->tag = prog->tag + 1;
    ctx->first_buf = 1;

    return ctx;
}


int
sre_vm_thompson_exec(sre_vm_thompson_ctx_t *ctx, u_char *input, size_t size,
    unsigned eof)
{
    u_char                          *sp, *last;
    unsigned                         i, j;
    unsigned                         in;
    sre_program_t                   *prog;
    sre_vm_range_t                  *range;
    sre_instruction_t               *pc;
    sre_vm_thompson_thread_t        *t;
    sre_vm_thompson_thread_list_t   *clist, *nlist, *tmp;

    prog = ctx->program;
    clist = ctx->current_threads;
    nlist = ctx->next_threads;
    ctx->buffer = input;

    if (ctx->first_buf) {
        ctx->first_buf = 0;
        sre_vm_thompson_add_thread(ctx, clist, prog->start, input);
    }

    last = input + size;

    for (sp = input; sp < last || (eof && sp == last); sp++) {
        dd("=== pos %d (char %d).\n", (int)(sp - input),
           (sp < last) ? (*sp & 0xFF) : 0);

        if (clist->count == 0) {
            break;
        }

        /* printf("%d(%02x).", (int)(sp - input), *sp & 0xFF); */

        ctx->tag++;

        for (i = 0; i < clist->count; i++) {
            t = &clist->threads[i];
            pc = t->pc;

            dd("--- #%u: pc %d: opcode %d\n", ctx->tag, (int)(pc - prog->start),
               pc->opcode);

            switch (pc->opcode) {
            case SRE_OPCODE_IN:
                if (sp == last) {
                    break;
                }

                in = 0;
                for (j = 0; j < pc->v.ranges->count; j++) {
                    range = &pc->v.ranges->head[j];

                    dd("testing %d for [%d, %d] (%u)", *sp, range->from,
                       range->to, j);

                    if (*sp >= range->from && *sp <= range->to) {
                        in = 1;
                        break;
                    }
                }

                if (!in) {
                    break;
                }

                sre_vm_thompson_add_thread(ctx, nlist, pc + 1, sp + 1);
                break;

            case SRE_OPCODE_NOTIN:
                if (sp == last) {
                    break;
                }

                in = 0;
                for (j = 0; j < pc->v.ranges->count; j++) {
                    range = &pc->v.ranges->head[j];

                    dd("testing %d for [%d, %d] (%u)", *sp, range->from,
                       range->to, j);

                    if (*sp >= range->from && *sp <= range->to) {
                        in = 1;
                        break;
                    }
                }

                if (in) {
                    break;
                }

                sre_vm_thompson_add_thread(ctx, nlist, pc + 1, sp + 1);
                break;

            case SRE_OPCODE_CHAR:
                if (sp == last || *sp != pc->v.ch) {
                    break;
                }

                sre_vm_thompson_add_thread(ctx, nlist, pc + 1, sp + 1);
                break;

            case SRE_OPCODE_ANY:
                if (sp == last) {
                    break;
                }

                sre_vm_thompson_add_thread(ctx, nlist, pc + 1, sp + 1);
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
                        dd("\\B assertion failed: %u %c", t->seen_word, *sp);
                        break;
                    }

                    dd("\\B assertion passed: %u %c", t->seen_word, *sp);

                    goto assertion_hold;


                case SRE_REGEX_ASSERTION_SMALL_B:
                    if ((t->seen_word ^ (sp != last && sre_isword(*sp))) == 0) {
                        dd("\\b assertion failed: %u %c", t->seen_word, *sp);
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
                sre_vm_thompson_add_thread(ctx, clist, pc + 1, sp);
                ctx->tag++;
                break;

            case SRE_OPCODE_MATCH:
                prog->tag = ctx->tag;
                return SRE_OK;

            default:
                /*
                 * Jmp, Split, Save handled in addthread, so that
                 * machine execution matches what a backtracker would do.
                 * This is discussed (but not shown as code) in
                 * Regular Expression Matching: the Virtual Machine Approach.
                 */
                break;
            } /* switch */
        } /* for */

        /* printf("\n"); */

        tmp = clist;
        clist = nlist;
        nlist = tmp;

        nlist->count = 0;
        if (sp == last) {
            break;
        }
    } /* for */

    prog->tag = ctx->tag;

    ctx->current_threads = clist;
    ctx->next_threads = nlist;

    if (eof) {
        return SRE_DECLINED;
    }

    return SRE_AGAIN;
}


static void
sre_vm_thompson_add_thread(sre_vm_thompson_ctx_t *ctx,
    sre_vm_thompson_thread_list_t *l, sre_instruction_t *pc, u_char *sp)
{
    sre_vm_thompson_thread_t        *t;
    unsigned                         seen_word = 0;

    if (pc->tag == ctx->tag) {  /* already on list */
        return;
    }

    pc->tag = ctx->tag;

    switch (pc->opcode) {
    case SRE_OPCODE_JMP:
        sre_vm_thompson_add_thread(ctx, l, pc->x, sp);
        return;

    case SRE_OPCODE_SPLIT:
        sre_vm_thompson_add_thread(ctx, l, pc->x, sp);
        sre_vm_thompson_add_thread(ctx, l, pc->y, sp);
        return;

    case SRE_OPCODE_SAVE:
        sre_vm_thompson_add_thread(ctx, l, pc + 1, sp);
        return;

    case SRE_OPCODE_ASSERT:
        switch (pc->v.assertion_type) {
        case SRE_REGEX_ASSERTION_BIG_A:
            if (sp != ctx->buffer) {
                dd("\\A assertion failed: %d", (int) (sp - ctx->buffer));
                return;
            }

            sre_vm_thompson_add_thread(ctx, l, pc + 1, sp);
            return;

        case SRE_REGEX_ASSERTION_CARET:
            if (sp != ctx->buffer && sp[-1] != '\n') {
                return;
            }

            sre_vm_thompson_add_thread(ctx, l, pc + 1, sp);
            return;

        case SRE_REGEX_ASSERTION_SMALL_B:
        case SRE_REGEX_ASSERTION_BIG_B:
            seen_word = (sp != ctx->buffer && sre_isword(sp[-1]));
            dd("seen word: %u %c", seen_word, *sp);
            break;

        default:
            /* postpone look-ahead assertions */

            break;
        }

        break;

    default:
        break;
    }

    t = &l->threads[l->count];
    t->pc = pc;
    t->seen_word = seen_word;

    l->count++;
}


static sre_vm_thompson_thread_list_t *
sre_vm_thompson_thread_list_create(sre_pool_t *pool, int size)
{
    u_char                              *p;
    sre_vm_thompson_thread_list_t       *l;

    p = sre_pnalloc(pool, sizeof(sre_vm_thompson_thread_list_t)
                    + size * sizeof(sre_vm_thompson_thread_t));
    if (p == NULL) {
        return NULL;
    }

    l = (sre_vm_thompson_thread_list_t *) p;

    p += sizeof(sre_vm_thompson_thread_list_t);
    l->threads = (sre_vm_thompson_thread_t *) p;

    l->count = 0;

    return l;
}

