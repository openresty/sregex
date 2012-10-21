
/*
 * Copyright 2012 Yichun "agentzh" Zhang
 * Copyright 2007-2009 Russ Cox.  All Rights Reserved.
 * Use of this source code is governed by a BSD-style
 * license that can be found in the LICENSE file.
 */


#ifndef DDEBUG
#define DDEBUG 0
#endif
#include <ddebug.h>


#include <sre_vm_pike.h>
#include <sre_capture.h>


typedef struct {
    sre_instruction_t    *pc;
    sre_capture_t        *capture;
} sre_vm_pike_thread_t;


typedef struct {
    unsigned                  count;
    sre_vm_pike_thread_t     *threads;
} sre_vm_pike_thread_list_t;


typedef struct {
    unsigned             tag;
    sre_pool_t          *pool;
    sre_program_t       *program;
    sre_capture_t       *free_capture;
} sre_vm_pike_ctx_t;


static sre_vm_pike_thread_list_t *sre_vm_pike_thread_list_create(
    sre_pool_t *pool, int size);
static int sre_vm_pike_add_thread(sre_vm_pike_ctx_t *ctx,
    sre_vm_pike_thread_list_t *l, sre_instruction_t *pc, sre_capture_t *capture,
    int pos);


int
sre_vm_pike_exec(sre_pool_t *pool, sre_program_t *prog, u_char *input,
    int *ovector, unsigned ovecsize)
{
    unsigned                   i, len;
    sre_vm_pike_thread_list_t *clist, *nlist, *tmp;
    sre_instruction_t         *pc;
    u_char                    *sp;
    sre_capture_t             *cap, *matched;
    sre_vm_pike_ctx_t          ctx;

    matched = NULL;

    cap = sre_capture_create(pool, ovecsize, 1);
    if (cap == NULL) {
        return SRE_ERROR;
    }

    len = prog->len;

    clist = sre_vm_pike_thread_list_create(pool, len);
    if (clist == NULL) {
        return SRE_ERROR;
    }

    nlist = sre_vm_pike_thread_list_create(pool, len);
    if (nlist == NULL) {
        return SRE_ERROR;
    }

    ctx.tag = 1;
    ctx.program = prog;
    ctx.pool = pool;
    ctx.free_capture = NULL;

    if (sre_vm_pike_add_thread(&ctx, clist, prog->start, cap, 0) != SRE_OK) {
        return SRE_ERROR;
    }

    for (sp = input; /* void */; sp++) {
        if (clist->count == 0) {
            dd("clist empty. abort.");
            break;
        }

        dd("=== pos %d (char %d).\n", (int)(sp - input), *sp & 0xFF);

        ctx.tag++;

        for (i = 0; i < clist->count; i++) {
            pc = clist->threads[i].pc;
            cap = clist->threads[i].capture;

            dd("--- #%d: pc %d: opcode %d\n", i, (int)(pc - prog->start),
               pc->opcode);

            switch (pc->opcode) {
            case SRE_OPCODE_CHAR:

                dd("matching char %d against %d", *sp, pc->v.ch);

                if (*sp != pc->v.ch) {
                    sre_capture_decr_ref(&ctx, cap);
                    break;
                }

            case SRE_OPCODE_ANY:

                if (*sp == '\0') {
                    sre_capture_decr_ref(&ctx, cap);
                    break;
                }

                if (sre_vm_pike_add_thread(&ctx, nlist, pc + 1, cap,
                                           (int) (sp - input + 1))
                    != SRE_OK)
                {
                    return SRE_ERROR;
                }

                break;

            case SRE_OPCODE_MATCH:

                if (matched) {

                    dd("discarding match: ");
#if (DDEBUG)
                    sre_capture_dump(matched);
#endif

                    sre_capture_decr_ref(&ctx, matched);
                }

                matched = cap;

                for (i++; i < clist->count; i++) {
                    sre_capture_decr_ref(&ctx, clist->threads[i].capture);
                }

                goto matched;

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
        } /* for */

matched:
        tmp = clist;
        clist = nlist;
        nlist = tmp;

        nlist->count = 0;

        if (*sp == '\0') {
            break;
        }
    } /* for */

    if (matched) {
        dd("matched: %p", matched);
        memcpy(ovector, matched->vector, ovecsize);
        /* sre_capture_decr_ref(matched, freecap); */
        return SRE_OK;
    }

    return SRE_DECLINED;
}


static sre_vm_pike_thread_list_t *
sre_vm_pike_thread_list_create(sre_pool_t *pool, int size)
{
    u_char                          *p;
    sre_vm_pike_thread_list_t       *l;

    p = sre_pnalloc(pool, sizeof(sre_vm_pike_thread_list_t)
                    + size * sizeof(sre_vm_pike_thread_t));
    if (p == NULL) {
        return NULL;
    }

    l = (sre_vm_pike_thread_list_t *) p;

    p += sizeof(sre_vm_pike_thread_list_t);
    l->threads = (sre_vm_pike_thread_t *) p;

    l->count = 0;

    return l;
}


static int
sre_vm_pike_add_thread(sre_vm_pike_ctx_t *ctx, sre_vm_pike_thread_list_t *l,
    sre_instruction_t *pc, sre_capture_t *capture, int pos)
{
    sre_vm_pike_thread_t        *t;
    sre_capture_t               *cap;

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
        dd("pc %d: cap %p: save %d as group %d",
           (int) (pc - ctx->program->start), capture, pos,
           pc->v.group);

        cap = sre_capture_update(ctx->pool, capture, pc->v.group, pos,
                                 &ctx->free_capture);
        if (cap == NULL) {
            return SRE_ERROR;
        }

        dd("new cap: %p", cap);

        return sre_vm_pike_add_thread(ctx, l, pc + 1, cap, pos);

    default:
        t = &l->threads[l->count];

        t->pc = pc;
        t->capture = capture;

        l->count++;
        break;
    }

    return SRE_OK;
}

