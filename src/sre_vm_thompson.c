
/*
 * Copyright 2012 Yichun "agentzh" Zhang
 * Copyright 2007-2009 Russ Cox.  All Rights Reserved.
 * Use of this source code is governed by a BSD-style
 * license that can be found in the LICENSE file.
 */


#include <sre_vm_thompson.h>


typedef struct {
    unsigned                    count;
    sre_instruction_t         **threads;
} sre_vm_thompson_thread_list_t;


static void sre_vm_thompson_add_thread(sre_vm_thompson_thread_list_t *l,
    sre_instruction_t *pc);
static sre_vm_thompson_thread_list_t *sre_vm_thompson_thread_list_create(
    sre_pool_t *pool, int size);


static unsigned sre_vm_thompson_tag = 0;


int
sre_vm_thompson_exec(sre_pool_t *pool, sre_program_t *prog, u_char *input)
{
    u_char                          *sp;
    unsigned                         i, len;
    sre_instruction_t               *pc;
    sre_vm_thompson_thread_list_t   *clist, *nlist, *tmp;

    len = prog->len;

    clist = sre_vm_thompson_thread_list_create(pool, len);
    if (clist == NULL) {
        return SRE_ERROR;
    }

    nlist = sre_vm_thompson_thread_list_create(pool, len);
    if (nlist == NULL) {
        return SRE_ERROR;
    }

    sre_vm_thompson_tag++;

    sre_vm_thompson_add_thread(clist, prog->start);

    for (sp = input; /* void */; sp++) {

        if (clist->count == 0) {
            break;
        }

        /* printf("%d(%02x).", (int)(sp - input), *sp & 0xFF); */

        sre_vm_thompson_tag++;

        for (i = 0; i < clist->count; i++) {
            pc = clist->threads[i];

            /* printf(" %d", (int)(pc - prog->start)); */

            switch (pc->opcode) {
            case SRE_OPCODE_CHAR:
                if (*sp != pc->v.ch) {
                    break;
                }

            case SRE_OPCODE_ANY:
                if (*sp == '\0') {
                    break;
                }

                sre_vm_thompson_add_thread(nlist, pc + 1);
                break;

            case SRE_OPCODE_MATCH:
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
        if (*sp == '\0') {
            break;
        }
    } /* for */

    return SRE_DECLINED;
}


static void
sre_vm_thompson_add_thread(sre_vm_thompson_thread_list_t *l,
    sre_instruction_t *pc)
{
    if (pc->tag == sre_vm_thompson_tag) {  /* already on list */
        return;
    }

    pc->tag = sre_vm_thompson_tag;
    l->threads[l->count] = pc;
    l->count++;

    switch (pc->opcode) {
    case SRE_OPCODE_JMP:
        sre_vm_thompson_add_thread(l, pc->x);
        break;

    case SRE_OPCODE_SPLIT:
        sre_vm_thompson_add_thread(l, pc->x);
        sre_vm_thompson_add_thread(l, pc->y);
        break;

    case SRE_OPCODE_SAVE:
        sre_vm_thompson_add_thread(l, pc + 1);
        break;

    default:
        break;
    }
}


static sre_vm_thompson_thread_list_t *
sre_vm_thompson_thread_list_create(sre_pool_t *pool, int size)
{
    u_char                              *p;
    sre_vm_thompson_thread_list_t       *l;

    p = sre_pnalloc(pool, sizeof(sre_vm_thompson_thread_list_t)
                    + size * sizeof(sre_instruction_t *));
    if (p == NULL) {
        return NULL;
    }

    l = (sre_vm_thompson_thread_list_t *) p;

    p += sizeof(sre_vm_thompson_thread_list_t);
    l->threads = (sre_instruction_t **) p;

    l->count = 0;

    return l;
}

