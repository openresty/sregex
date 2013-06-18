
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


#include <sregex/sre_capture.h>
#include <sregex/sre_vm_bytecode.h>


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
    sre_uint_t                count;
    sre_vm_pike_thread_t     *head;
    sre_vm_pike_thread_t    **next;
} sre_vm_pike_thread_list_t;


struct sre_vm_pike_ctx_s {
    unsigned                 tag;
    sre_int_t                processed_bytes;
    sre_char                *buffer;
    sre_pool_t              *pool;
    sre_program_t           *program;
    sre_capture_t           *matched;
    sre_capture_t           *free_capture;
    sre_vm_pike_thread_t    *free_threads;

    sre_int_t               *pending_ovector;
    sre_int_t               *ovector;
    size_t                   ovecsize;

    sre_vm_pike_thread_list_t       *current_threads;
    sre_vm_pike_thread_list_t       *next_threads;

    sre_int_t                last_matched_pos; /* the pos for the last
                                                  (partial) match */

    sre_instruction_t      **initial_states;
    sre_uint_t               initial_states_count;

    unsigned                 first_buf:1;
    unsigned                 seen_start_state:1;
    unsigned                 eof:1;
    unsigned                 empty_capture:1;
    unsigned                 seen_newline:1;
    unsigned                 seen_word:1;
} ;


static sre_vm_pike_thread_list_t *
    sre_vm_pike_thread_list_create(sre_pool_t *pool);
static sre_int_t sre_vm_pike_add_thread(sre_vm_pike_ctx_t *ctx,
    sre_vm_pike_thread_list_t *l, sre_instruction_t *pc, sre_capture_t *capture,
    sre_int_t pos, sre_capture_t **pcap);
static void sre_vm_pike_prepare_temp_captures(sre_program_t *prog,
    sre_vm_pike_ctx_t *ctx);
static sre_int_t sre_vm_pike_prepare_matched_captures(sre_vm_pike_ctx_t *ctx,
    sre_capture_t *matched, sre_int_t *ovector, sre_int_t complete);
static sre_char *sre_vm_pike_find_first_byte(sre_char *pos, sre_char *last,
    int leading_byte, sre_chain_t *leading_bytes);
static void sre_vm_pike_clear_thread_list(sre_vm_pike_ctx_t *ctx,
    sre_vm_pike_thread_list_t *list);


SRE_API sre_vm_pike_ctx_t *
sre_vm_pike_create_ctx(sre_pool_t *pool, sre_program_t *prog,
    sre_int_t *ovector, size_t ovecsize)
{
    sre_vm_pike_ctx_t               *ctx;
    sre_vm_pike_thread_list_t       *clist, *nlist;

    ctx = sre_palloc(pool, sizeof(sre_vm_pike_ctx_t));
    if (ctx == NULL) {
        return NULL;
    }

    ctx->pool = pool;
    ctx->program = prog;
    ctx->processed_bytes = 0;
    ctx->pending_ovector = NULL;

    clist = sre_vm_pike_thread_list_create(pool);
    if (clist == NULL) {
        return NULL;
    }

    ctx->current_threads = clist;

    nlist = sre_vm_pike_thread_list_create(pool);
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

    dd("resetting seen start state");
    ctx->seen_start_state = 0;
    ctx->initial_states_count = 0;
    ctx->initial_states = NULL;
    ctx->first_buf = 1;
    ctx->eof = 0;
    ctx->empty_capture = 0;
    ctx->seen_newline = 0;
    ctx->seen_word = 0;

    return ctx;
}


SRE_API sre_int_t
sre_vm_pike_exec(sre_vm_pike_ctx_t *ctx, sre_char *input, size_t size,
    unsigned eof, sre_int_t **pending_matched)
{
    sre_char                  *sp, *last, *p;
    sre_int_t                  rc;
    sre_uint_t                 i;
    unsigned                   seen_word, in;
    sre_pool_t                *pool;
    sre_program_t             *prog;
    sre_capture_t             *cap, *matched;
    sre_vm_range_t            *range;
    sre_instruction_t         *pc;
    sre_vm_pike_thread_t      *t;
    sre_vm_pike_thread_list_t *clist, *nlist, *tmp;
    sre_vm_pike_thread_list_t  list;

    if (ctx->eof) {
        dd("eof found");
        return SRE_ERROR;
    }

    pool = ctx->pool;
    prog = ctx->program;
    clist = ctx->current_threads;
    nlist = ctx->next_threads;
    matched = ctx->matched;

    ctx->buffer = input;
    ctx->last_matched_pos = -1;

    if (ctx->empty_capture) {
        dd("found empty capture");
        ctx->empty_capture = 0;

        if (size == 0) {
            if (eof) {
                ctx->eof = 1;
                return SRE_DECLINED;
            }

            return SRE_AGAIN;
        }

        sp = input + 1;

    } else {
        sp = input;
    }

    last = input + size;

    dd("processing buffer size %d", (int) size);

    if (ctx->first_buf) {
        ctx->first_buf = 0;

        cap = sre_capture_create(pool, prog->ovecsize, 1, &ctx->free_capture);
        if (cap == NULL) {
            return SRE_ERROR;
        }

        ctx->tag = prog->tag + 1;
        rc = sre_vm_pike_add_thread(ctx, clist, prog->start, cap,
                                   (sre_int_t) (sp - input), NULL);
        if (rc != SRE_OK) {
            prog->tag = ctx->tag;
            return SRE_ERROR;
        }

        ctx->initial_states_count = clist->count;
        ctx->initial_states = sre_palloc(pool,
                                         sizeof(sre_instruction_t *)
                                         * clist->count);
        if (ctx->initial_states == NULL) {
            return SRE_ERROR;
        }

        /* we skip the last thread because it must always be .*? */
        for (i = 0, t = clist->head; t && t->next; i++, t = t->next) {
            ctx->initial_states[i] = t->pc;
        }

    } else {
        ctx->tag = prog->tag;
    }

    for (; sp < last || (eof && sp == last); sp++) {
        dd("=== pos %d, offset %d (char '%c' (%d)).\n",
           (int)(sp - input + ctx->processed_bytes),
           (int)(sp - input),
           sp < last ? *sp : '?', sp < last ? *sp : 0);

        if (clist->head == NULL) {
            dd("clist empty. abort.");
            break;
        }

#if (DDEBUG)
        fprintf(stderr, "sregex: cur list:");
        for (t = clist->head; t; t = t->next) {
            fprintf(stderr, " %d", (int) (t->pc - prog->start));
        }
        fprintf(stderr, "\n");
#endif

        dd("seen start state: %d", (int) ctx->seen_start_state);

        if (prog->leading_bytes && ctx->seen_start_state) {
            dd("resetting seen start state");
            ctx->seen_start_state = 0;

            if (sp == last || clist->count != ctx->initial_states_count) {
                dd("skip because sp == last or "
                   "clist->count != initial states count!");
                goto run_cur_threads;
            }

            for (i = 0, t = clist->head; t && t->next; i++, t = t->next) {
                if (t->pc != ctx->initial_states[i]) {
                    dd("skip because pc %d unmatched: %d != %d", (int) i,
                       (int) (t->pc - prog->start),
                       (int) (ctx->initial_states[i] - prog->start));
                    goto run_cur_threads;
                }
            }

#if 1
            dd("XXX found initial state to do first byte search!");
            p = sre_vm_pike_find_first_byte(sp, last, prog->leading_byte,
                                            prog->leading_bytes);

            if (p > sp) {
                dd("XXX moved sp by %d bytes", (int) (p - sp));
#if 0
                fprintf(stderr, "XXX moved sp by %d bytes\n", (int) (p - sp));
#endif

                sp = p;

                sre_vm_pike_clear_thread_list(ctx, clist);

                cap = sre_capture_create(pool, prog->ovecsize, 1,
                                         &ctx->free_capture);
                if (cap == NULL) {
                    return SRE_ERROR;
                }

                ctx->tag++;
                rc = sre_vm_pike_add_thread(ctx, clist, prog->start, cap,
                                           (sre_int_t) (sp - input), NULL);
                if (rc != SRE_OK) {
                    prog->tag = ctx->tag;
                    return SRE_ERROR;
                }

                if (sp == last) {
                    break;
                }
            }
#endif
        }

run_cur_threads:
        ctx->tag++;

        while (clist->head) {
            t = clist->head;
            clist->head = t->next;
            clist->count--;

            pc = t->pc;
            cap = t->capture;

#if DDEBUG
            fprintf(stderr, "--- #%u", ctx->tag);
            sre_dump_instruction(stderr, pc, prog->start);
            fprintf(stderr, "\n");
#endif

            switch (pc->opcode) {
            case SRE_OPCODE_IN:
                if (sp == last) {
                    sre_capture_decr_ref(ctx, cap);
                    break;
                }

                in = 0;
                for (i = 0; i < pc->v.ranges->count; i++) {
                    range = &pc->v.ranges->head[i];

                    dd("testing %d for [%d, %d] (%u)", *sp,
                       (int) range->from, (int) range->to, (unsigned) i);

                    if (*sp >= range->from && *sp <= range->to) {
                        in = 1;
                        break;
                    }
                }

                if (!in) {
                    sre_capture_decr_ref(ctx, cap);
                    break;
                }

                rc = sre_vm_pike_add_thread(ctx, nlist, pc + 1, cap,
                                           (sre_int_t) (sp - input + 1), &cap);

                if (rc == SRE_DONE) {
                    goto matched;
                }

                if (rc != SRE_OK) {
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

                    dd("testing %d for [%d, %d] (%u)", *sp, (int) range->from,
                       (int) range->to, (unsigned) i);

                    if (*sp >= range->from && *sp <= range->to) {
                        in = 1;
                        break;
                    }
                }

                if (in) {
                    sre_capture_decr_ref(ctx, cap);
                    break;
                }

                rc = sre_vm_pike_add_thread(ctx, nlist, pc + 1, cap,
                                           (sre_int_t) (sp - input + 1), &cap);

                if (rc == SRE_DONE) {
                    goto matched;
                }

                if (rc != SRE_OK) {
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

                rc = sre_vm_pike_add_thread(ctx, nlist, pc + 1, cap,
                                            (sre_int_t) (sp - input + 1), &cap);

                if (rc == SRE_DONE) {
                    goto matched;
                }

                if (rc != SRE_OK) {
                    prog->tag = ctx->tag;
                    return SRE_ERROR;
                }

                break;

            case SRE_OPCODE_ANY:

                if (sp == last) {
                    sre_capture_decr_ref(ctx, cap);
                    break;
                }

                rc = sre_vm_pike_add_thread(ctx, nlist, pc + 1, cap,
                                           (sre_int_t) (sp - input + 1), &cap);

                if (rc == SRE_DONE) {
                    goto matched;
                }

                if (rc != SRE_OK) {
                    prog->tag = ctx->tag;
                    return SRE_ERROR;
                }

                break;

            case SRE_OPCODE_ASSERT:
                switch (pc->v.assertion) {
                case SRE_REGEX_ASSERT_SMALL_Z:
                    if (sp != last) {
                        break;
                    }

                    goto assertion_hold;

                case SRE_REGEX_ASSERT_DOLLAR:

                    if (sp != last && *sp != '\n') {
                        break;
                    }

                    dd("dollar $ assertion hold: pos=%d",
                       (int)(sp - input + ctx->processed_bytes));

                    goto assertion_hold;

                case SRE_REGEX_ASSERT_BIG_B:

                    seen_word = (t->seen_word
                                 || (sp == input && ctx->seen_word));
                    if (seen_word ^ (sp != last && sre_isword(*sp))) {
                        break;
                    }

                    dd("\\B assertion passed: %u %c", t->seen_word, *sp);

                    goto assertion_hold;

                case SRE_REGEX_ASSERT_SMALL_B:

                    seen_word = (t->seen_word
                                 || (sp == input && ctx->seen_word));
                    if ((seen_word ^ (sp != last && sre_isword(*sp))) == 0) {
                        break;
                    }

#if (DDEBUG)
                    if (sp) {
                        dd("\\b assertion passed: t:%u, ctx:%u, %c",
                           t->seen_word, ctx->seen_word, *sp);
                    }
#endif

                    goto assertion_hold;

                default:
                    /* impossible to reach here */
                    break;
                }

                break;

assertion_hold:
                ctx->tag--;

                list.head = NULL;
                list.count = 0;
                rc = sre_vm_pike_add_thread(ctx, &list, pc + 1, cap,
                                           (sre_int_t) (sp - input), NULL);

                if (rc != SRE_OK) {
                    prog->tag = ctx->tag + 1;
                    return SRE_ERROR;
                }

                if (list.head) {
                    *list.next = clist->head;
                    clist->head = list.head;
                    clist->count += list.count;
                }

                ctx->tag++;

                dd("sp + 1 == last: %d, eof: %u", sp + 1 == last, eof);
                break;

            case SRE_OPCODE_MATCH:

                ctx->last_matched_pos = cap->vector[1];
                cap->regex_id = pc->v.regex_id;

matched:
                if (matched) {

                    dd("discarding match: ");
#if (DDEBUG)
                    sre_capture_dump(matched);
#endif
                    sre_capture_decr_ref(ctx, matched);
                }

                dd("set matched, regex id: %d", (int) pc->v.regex_id);

                matched = cap;

                sre_vm_pike_free_thread(ctx, t);

                sre_vm_pike_clear_thread_list(ctx, clist);

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
            sre_vm_pike_clear_thread_list(ctx, nlist);
        }

        if (sp == last) {
            break;
        }
    } /* for */

    dd("matched: %p, clist: %p, pos: %d", matched, clist->head,
       (int) (ctx->processed_bytes + (sp - input)));

    if (ctx->last_matched_pos >= 0) {
        p = input + ctx->last_matched_pos - ctx->processed_bytes;
        if (p > input) {
            dd("diff: %d",
               (int) (ctx->last_matched_pos - ctx->processed_bytes));
            dd("p=%p, input=%p", p, ctx->buffer);

            ctx->seen_newline = (p[-1] == '\n');
            ctx->seen_word = sre_isword(p[-1]);

            dd("set seen newline: %u", ctx->seen_newline);
            dd("set seen word: %u", ctx->seen_word);
        }

        ctx->last_matched_pos = -1;
    }

    prog->tag = ctx->tag;
    ctx->current_threads = clist;
    ctx->next_threads = nlist;

    if (matched) {
        if (eof || clist->head == NULL) {
            if (sre_vm_pike_prepare_matched_captures(ctx, matched,
                                                     ctx->ovector, 1)
                != SRE_OK)
            {
                return SRE_ERROR;
            }

            if (clist->head) {
                *clist->next = ctx->free_threads;
                ctx->free_threads = clist->head;
                clist->head = NULL;
                clist->count = 0;
                ctx->eof = 1;
            }

            ctx->processed_bytes = ctx->ovector[1];
            ctx->empty_capture = (ctx->ovector[0] == ctx->ovector[1]);

            ctx->matched = NULL;
            ctx->first_buf = 1;

            rc = matched->regex_id;
            sre_capture_decr_ref(ctx, matched);

            dd("set empty capture: %u", ctx->empty_capture);

            return rc;
        }

        dd("clist head cap == matched: %d", clist->head->capture == matched);

        if (pending_matched) {
#if 1
            if (ctx->pending_ovector == NULL) {
                ctx->pending_ovector = sre_palloc(pool, 2 * sizeof(sre_int_t));
                if (ctx->pending_ovector == NULL) {
                    return SRE_ERROR;
                }
            }

            *pending_matched = ctx->pending_ovector;

            if (sre_vm_pike_prepare_matched_captures(ctx, matched,
                                                     *pending_matched, 0)
                != SRE_OK)
            {
                return SRE_ERROR;
            }
#endif
        }

    } else {
        if (eof) {
            ctx->eof = 1;
            ctx->matched = NULL;

            return SRE_DECLINED;
        }

        if (pending_matched) {
            *pending_matched = NULL;
        }
    }

    ctx->processed_bytes += (sre_int_t) (sp - input);

    dd("processed bytes: %u", (unsigned) ctx->processed_bytes);

    ctx->matched = matched;

    sre_vm_pike_prepare_temp_captures(prog, ctx);

#if 0
    if (sp > input) {
        ctx->seen_newline = (sp[-1] == '\n');
        ctx->seen_word = sre_isword(sp[-1]);
    }
#endif

    return SRE_AGAIN;
}


static void
sre_vm_pike_prepare_temp_captures(sre_program_t *prog, sre_vm_pike_ctx_t *ctx)
{
    sre_int_t                a, b;
    sre_uint_t               i, j, ofs;
    sre_capture_t           *cap;
    sre_vm_pike_thread_t    *t;

    ctx->ovector[0] = -1;
    ctx->ovector[1] = -1;

    for (t = ctx->current_threads->head; t; t = t->next) {
        cap = t->capture;

        ofs = 0;
        for (i = 0; i < prog->nregexes; i++) {

            for (j = 0; j < 2; j += 2) {
                a = ctx->ovector[j];
                b = cap->vector[ofs + j];

                dd("%d: %d -> %d", (int) j, (int) b, (int) a);

                if (b != -1 && (a == -1 || b < a)) {
                    dd("setting group %d to %d", (int) j, (int) cap->vector[j]);
                    ctx->ovector[j] = b;
                }

                a = ctx->ovector[j + 1];
                b = cap->vector[j + 1];

                dd("%d: %d -> %d", (int) (j + 1), (int) b, (int) a);

                if (b != -1 && (a == -1 || b > a)) {
                    dd("setting group %d to %d", (int) (j + 1),
                       (int) cap->vector[j + 1]);
                    ctx->ovector[j + 1] = b;
                }
            }

            ofs += 2 * (prog->multi_ncaps[i] + 1);
        }
    }
}


static sre_vm_pike_thread_list_t *
sre_vm_pike_thread_list_create(sre_pool_t *pool)
{
    sre_vm_pike_thread_list_t       *l;

    l = sre_palloc(pool, sizeof(sre_vm_pike_thread_list_t));
    if (l == NULL) {
        return NULL;
    }

    l->head = NULL;
    l->next = &l->head;
    l->count = 0;

    return l;
}


static sre_int_t
sre_vm_pike_add_thread(sre_vm_pike_ctx_t *ctx, sre_vm_pike_thread_list_t *l,
    sre_instruction_t *pc, sre_capture_t *capture, sre_int_t pos,
    sre_capture_t **pcap)
{
    sre_int_t                    rc;
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
                if (pc == ctx->program->start) {
                    dd("setting seen start state");
                    ctx->seen_start_state = 1;
                }

                return sre_vm_pike_add_thread(ctx, l, pc->y, capture, pos,
                                              pcap);
            }
        }

        return SRE_OK;
    }

    dd("adding thread: pc %d, bytecode %d", (int) (pc - ctx->program->start),
       pc->opcode);

    pc->tag = ctx->tag;

    switch (pc->opcode) {
    case SRE_OPCODE_JMP:
        return sre_vm_pike_add_thread(ctx, l, pc->x, capture, pos, pcap);

    case SRE_OPCODE_SPLIT:
        if (pc == ctx->program->start) {
            dd("setting seen start state");
            ctx->seen_start_state = 1;
        }

        capture->ref++;

        rc = sre_vm_pike_add_thread(ctx, l, pc->x, capture, pos, pcap);
        if (rc != SRE_OK) {
            capture->ref--;
            return rc;
        }

        return sre_vm_pike_add_thread(ctx, l, pc->y, capture, pos, pcap);

    case SRE_OPCODE_SAVE:

#if 0
        dd("pc %d: cap %p: save %d as group %d",
           (int) (pc - ctx->program->start), capture, pos,
           pc->v.group);
#endif

        dd("save %u: processed bytes: %u, pos: %u",
           (unsigned) pc->v.group,
           (unsigned) ctx->processed_bytes, (unsigned) pos);

        cap = sre_capture_update(ctx->pool, capture, pc->v.group,
                                 ctx->processed_bytes + pos,
                                 &ctx->free_capture);
        if (cap == NULL) {
            return SRE_ERROR;
        }

#if 0
        dd("new cap: %p", cap);
#endif

        return sre_vm_pike_add_thread(ctx, l, pc + 1, cap, pos, pcap);

    case SRE_OPCODE_ASSERT:
        switch (pc->v.assertion) {
        case SRE_REGEX_ASSERT_BIG_A:
            if (pos || ctx->processed_bytes) {
                break;
            }

            return sre_vm_pike_add_thread(ctx, l, pc + 1, capture, pos, pcap);

        case SRE_REGEX_ASSERT_CARET:
            dd("seen newline: %u", ctx->seen_newline);

            if (pos == 0) {
                if (ctx->processed_bytes && !ctx->seen_newline) {
                    break;
                }

            } else {
                if (ctx->buffer[pos - 1] != '\n') {
                    break;
                }
            }

            dd("newline assertion hold");

            return sre_vm_pike_add_thread(ctx, l, pc + 1, capture, pos, pcap);

        case SRE_REGEX_ASSERT_SMALL_B:
        case SRE_REGEX_ASSERT_BIG_B:
            {
                sre_char c;

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

    case SRE_OPCODE_MATCH:

        ctx->last_matched_pos = capture->vector[1];
        capture->regex_id = pc->v.regex_id;

#if 1
        if (pcap) {
            *pcap = capture;
            return SRE_DONE;
        }
#endif

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

        l->count++;
        l->next = &t->next;

        dd("added thread: pc %d, bytecode %d", (int) (pc - ctx->program->start),
           pc->opcode);

        break;
    }

    return SRE_OK;
}


static sre_int_t
sre_vm_pike_prepare_matched_captures(sre_vm_pike_ctx_t *ctx,
    sre_capture_t *matched, sre_int_t *ovector, sre_int_t complete)
{
    sre_program_t      *prog = ctx->program;
    sre_uint_t          i, ofs = 0;
    size_t              len;

    if (matched->regex_id >= prog->nregexes) {
        dd("bad regex id: %ld >= %ld", (long) matched->regex_id,
           (long) prog->nregexes);

        return SRE_ERROR;
    }

    for (i = 0; i < matched->regex_id; i++) {
        ofs += prog->multi_ncaps[i] + 1;
    }

    ofs *= 2;

    if (complete) {
        len = 2 * (prog->multi_ncaps[i] + 1) * sizeof(sre_int_t);

    } else {
        len = 2 * sizeof(sre_int_t);
    }

    dd("ncaps for regex %d: %d", (int) i, (int) prog->multi_ncaps[i]);

    dd("matched captures: ofs: %d, len: %d", (int) ofs,
       (int) (len / sizeof(sre_int_t)));

    memcpy(ovector, &matched->vector[ofs], len);

    if (!complete) {
        return SRE_OK;
    }

    if (ctx->ovecsize > len) {
        memset((char *) ovector + len, -1, ctx->ovecsize - len);
    }

    return SRE_OK;
}


static sre_char *
sre_vm_pike_find_first_byte(sre_char *pos, sre_char *last,
    int leading_byte, sre_chain_t *leading_bytes)
{
#if 1
    int                  in;
    sre_uint_t           i;
    sre_chain_t         *cl;
    sre_instruction_t   *pc;
    sre_vm_range_t      *range;

    /* optimize for single CHAR bc */
    if (leading_byte != -1) {
        pos = memchr(pos, leading_byte, last - pos);
        if (pos == NULL) {
            return last;
        }

        return pos;
    }

    for ( ; pos != last; pos++) {
        for (cl = leading_bytes; cl; cl = cl->next) {
            pc = cl->data;
            switch (pc->opcode) {
            case SRE_OPCODE_CHAR:
                if (*pos == pc->v.ch) {
                    return pos;
                }

                break;

            case SRE_OPCODE_IN:
                for (i = 0; i < pc->v.ranges->count; i++) {
                    range = &pc->v.ranges->head[i];

                    if (*pos >= range->from && *pos <= range->to) {
                        return pos;
                    }
                }

                break;

            case SRE_OPCODE_NOTIN:
                in = 0;
                for (i = 0; i < pc->v.ranges->count; i++) {
                    range = &pc->v.ranges->head[i];

                    if (*pos >= range->from && *pos <= range->to) {
                        in = 1;
                        break;
                    }
                }

                if (in == 0) {
                    return pos;
                }

                break;

            default:
                sre_assert(pc->opcode);
                break;
            }
        }
    }
#endif

    return pos;
}


static void
sre_vm_pike_clear_thread_list(sre_vm_pike_ctx_t *ctx,
    sre_vm_pike_thread_list_t *list)
{
    sre_vm_pike_thread_t      *t;

    while (list->head) {
        t = list->head;
        list->head = t->next;
        list->count--;

        sre_capture_decr_ref(ctx, t->capture);
        sre_vm_pike_free_thread(ctx, t);
    }

    sre_assert(list->count == 0);
}
