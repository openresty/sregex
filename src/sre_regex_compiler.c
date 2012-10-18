
/*
 * Copyright 2012 Yichun "agentzh" Zhang
 * Copyright 2007-2009 Russ Cox.  All Rights Reserved.
 * Use of this source code is governed by a BSD-style
 * license that can be found in the LICENSE file.
 */


#include <sre_regex_compiler.h>


static unsigned sre_program_len(sre_regex_t *r);
static sre_instruction_t *sre_regex_emit_bytecode(sre_instruction_t *pc,
    sre_regex_t *re);


sre_program_t *
sre_regex_compile(sre_pool_t *pool, sre_regex_t *re)
{
    unsigned             n;
    u_char              *p;
    sre_program_t       *prog;
    sre_instruction_t   *pc;

    n = sre_program_len(re) + 1;

    p = sre_pnalloc(pool,
                    sizeof(sre_program_t) + n * sizeof(sre_instruction_t));

    if (p == NULL) {
        return NULL;
    }

    prog = (sre_program_t *) p;
    prog->start = (sre_instruction_t *) (p + sizeof(sre_program_t));

    sre_memzero(prog->start, n * sizeof(sre_instruction_t));

    pc = sre_regex_emit_bytecode(prog->start, re);
    pc->opcode = SRE_OPCODE_MATCH;
    pc++;

    prog->len = pc - prog->start;

    return prog;
}


static unsigned
sre_program_len(sre_regex_t *r)
{
    switch(r->type) {
    case SRE_REGEX_TYPE_ALT:
        return 2 + sre_program_len(r->left) + sre_program_len(r->right);

    case SRE_REGEX_TYPE_CAT:
        return 2 + sre_program_len(r->left) + sre_program_len(r->right);

    case SRE_REGEX_TYPE_LIT:
    case SRE_REGEX_TYPE_DOT:
        return 1;

    case SRE_REGEX_TYPE_PAREN:
        return 2 + sre_program_len(r->left);

    case SRE_REGEX_TYPE_QUEST:
        return 1 + sre_program_len(r->left);

    case SRE_REGEX_TYPE_STAR:
        return 2 + sre_program_len(r->left);

    case SRE_REGEX_TYPE_PLUS:
        return 1 +  sre_program_len(r->left);

    default:
        /* impossible to reach here */
        return 0;
    }
}


static sre_instruction_t *
sre_regex_emit_bytecode(sre_instruction_t *pc, sre_regex_t *r)
{
    sre_instruction_t    *p1, *p2, *t;

    switch(r->type) {
    case SRE_REGEX_TYPE_ALT:
        pc->opcode = SRE_OPCODE_SPLIT;
        p1 = pc++;
        p1->x = pc;

        pc = sre_regex_emit_bytecode(pc, r->left);

        pc->opcode = SRE_OPCODE_JMP;
        p2 = pc++;
        p1->y = pc;

        pc = sre_regex_emit_bytecode(pc, r->right);
        p2->x = pc;

        break;

    case SRE_REGEX_TYPE_CAT:
        pc = sre_regex_emit_bytecode(pc, r->left);
        pc = sre_regex_emit_bytecode(pc, r->right);
        break;

    case SRE_REGEX_TYPE_LIT:
        pc->opcode = SRE_OPCODE_CHAR;
        pc->v.ch = r->ch;
        pc++;
        break;

    case SRE_REGEX_TYPE_DOT:
        pc->opcode = SRE_OPCODE_ANY;
        pc++;
        break;

    case SRE_REGEX_TYPE_PAREN:
        pc->opcode = SRE_OPCODE_SAVE;
        pc->v.group = 2 * r->nparens;
        pc++;

        pc = sre_regex_emit_bytecode(pc, r->left);
        pc->opcode = SRE_OPCODE_SAVE;

        pc->v.group = 2 * r->nparens + 1;
        pc++;

        break;

    case SRE_REGEX_TYPE_QUEST:
        pc->opcode = SRE_OPCODE_SPLIT;
        p1 = pc++;
        p1->x = pc;

        pc = sre_regex_emit_bytecode(pc, r->left);
        p1->y = pc;

        if (!r->greedy) { /* non-greedy */
            t = p1->x;
            p1->x = p1->y;
            p1->y = t;
        }

        break;

    case SRE_REGEX_TYPE_STAR:
        pc->opcode = SRE_OPCODE_SPLIT;
        p1 = pc++;
        p1->x = pc;

        pc = sre_regex_emit_bytecode(pc, r->left);

        pc->opcode = SRE_OPCODE_JMP;
        pc->x = p1;
        pc++;

        p1->y = pc;

        if (!r->greedy) { /* non-greedy */
            t = p1->x;
            p1->x = p1->y;
            p1->y = t;
        }

        break;

    case SRE_REGEX_TYPE_PLUS:
        p1 = pc;
        pc = sre_regex_emit_bytecode(pc, r->left);

        pc->opcode = SRE_OPCODE_SPLIT;
        pc->x = p1;
        p2 = pc;

        pc++;
        p2->y = pc;

        if (!r->greedy) { /* non-greedy */
            t = p2->x;
            p2->x = p2->y;
            p2->y = t;
        }

        break;

    default:
        /* impossible to reach here */
        break;
    }

    return pc;
}

