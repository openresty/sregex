
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


#include <sregex/sre_vm_bytecode.h>


static sre_uint_t sre_program_len(sre_regex_t *r);
static sre_instruction_t *sre_regex_emit_bytecode(sre_pool_t *pool,
    sre_instruction_t *pc, sre_regex_t *re);
static sre_int_t sre_regex_compiler_add_char_class(sre_pool_t *pool,
    sre_instruction_t *pc, sre_regex_range_t *range);


sre_program_t *
sre_regex_compile(sre_pool_t *pool, sre_regex_t *re)
{
    sre_uint_t           n;
    sre_char            *p;
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

    pc = sre_regex_emit_bytecode(pool, prog->start, re);
    if (pc == NULL) {
        return NULL;
    }

    pc->opcode = SRE_OPCODE_MATCH;
    pc++;

    if (pc - prog->start != n) {
        return NULL;
    }

    prog->len = pc - prog->start;
    prog->tag = 0;
    prog->lookahead_asserts = 0;
    prog->dup_threads = 0;
    prog->uniq_threads = 0;

    return prog;
}


static sre_uint_t
sre_program_len(sre_regex_t *r)
{
    switch(r->type) {
    case SRE_REGEX_TYPE_ALT:
        return 2 + sre_program_len(r->left) + sre_program_len(r->right);

    case SRE_REGEX_TYPE_CAT:
        return sre_program_len(r->left) + sre_program_len(r->right);

    case SRE_REGEX_TYPE_LIT:
    case SRE_REGEX_TYPE_DOT:
    case SRE_REGEX_TYPE_CLASS:
    case SRE_REGEX_TYPE_NCLASS:
        return 1;

    case SRE_REGEX_TYPE_PAREN:
        return 2 + sre_program_len(r->left);

    case SRE_REGEX_TYPE_QUEST:
        return 1 + sre_program_len(r->left);

    case SRE_REGEX_TYPE_STAR:
        return 2 + sre_program_len(r->left);

    case SRE_REGEX_TYPE_PLUS:
        return 1 +  sre_program_len(r->left);

    case SRE_REGEX_TYPE_ASSERT:
        return 1;

    case SRE_REGEX_TYPE_NIL:
    default:
        /* impossible to reach here */
        return 0;
    }
}


static sre_instruction_t *
sre_regex_emit_bytecode(sre_pool_t *pool, sre_instruction_t *pc, sre_regex_t *r)
{
    sre_instruction_t    *p1, *p2, *t;

    switch(r->type) {
    case SRE_REGEX_TYPE_ALT:
        pc->opcode = SRE_OPCODE_SPLIT;
        p1 = pc++;
        p1->x = pc;

        pc = sre_regex_emit_bytecode(pool, pc, r->left);
        if (pc == NULL) {
            return NULL;
        }

        pc->opcode = SRE_OPCODE_JMP;
        p2 = pc++;
        p1->y = pc;

        pc = sre_regex_emit_bytecode(pool, pc, r->right);
        if (pc == NULL) {
            return NULL;
        }

        p2->x = pc;

        break;

    case SRE_REGEX_TYPE_CAT:
        pc = sre_regex_emit_bytecode(pool, pc, r->left);
        if (pc == NULL) {
            return NULL;
        }

        pc = sre_regex_emit_bytecode(pool, pc, r->right);
        if (pc == NULL) {
            return NULL;
        }

        break;

    case SRE_REGEX_TYPE_LIT:
        pc->opcode = SRE_OPCODE_CHAR;
        pc->v.ch = r->ch;
        pc++;
        break;

    case SRE_REGEX_TYPE_CLASS:
        pc->opcode = SRE_OPCODE_IN;

        if (sre_regex_compiler_add_char_class(pool, pc, r->data.range) != SRE_OK) {
            return NULL;
        }

        pc++;
        break;

    case SRE_REGEX_TYPE_NCLASS:
        pc->opcode = SRE_OPCODE_NOTIN;

        if (sre_regex_compiler_add_char_class(pool, pc, r->data.range) != SRE_OK) {
            return NULL;
        }

        pc++;
        break;

    case SRE_REGEX_TYPE_DOT:
        pc->opcode = SRE_OPCODE_ANY;
        pc++;
        break;

    case SRE_REGEX_TYPE_PAREN:
        pc->opcode = SRE_OPCODE_SAVE;
        pc->v.group = 2 * r->data.group;
        pc++;

        pc = sre_regex_emit_bytecode(pool, pc, r->left);
        if (pc == NULL) {
            return NULL;
        }

        pc->opcode = SRE_OPCODE_SAVE;

        pc->v.group = 2 * r->data.group + 1;
        pc++;

        break;

    case SRE_REGEX_TYPE_QUEST:
        pc->opcode = SRE_OPCODE_SPLIT;
        p1 = pc++;
        p1->x = pc;

        pc = sre_regex_emit_bytecode(pool, pc, r->left);
        if (pc == NULL) {
            return NULL;
        }

        p1->y = pc;

        if (!r->data.greedy) { /* non-greedy */
            t = p1->x;
            p1->x = p1->y;
            p1->y = t;
        }

        break;

    case SRE_REGEX_TYPE_STAR:
        pc->opcode = SRE_OPCODE_SPLIT;
        p1 = pc++;
        p1->x = pc;

        pc = sre_regex_emit_bytecode(pool, pc, r->left);
        if (pc == NULL) {
            return NULL;
        }

        pc->opcode = SRE_OPCODE_JMP;
        pc->x = p1;
        pc++;

        p1->y = pc;

        if (!r->data.greedy) { /* non-greedy */
            t = p1->x;
            p1->x = p1->y;
            p1->y = t;
        }

        break;

    case SRE_REGEX_TYPE_PLUS:
        p1 = pc;
        pc = sre_regex_emit_bytecode(pool, pc, r->left);
        if (pc == NULL) {
            return NULL;
        }

        pc->opcode = SRE_OPCODE_SPLIT;
        pc->x = p1;
        p2 = pc;

        pc++;
        p2->y = pc;

        if (!r->data.greedy) { /* non-greedy */
            t = p2->x;
            p2->x = p2->y;
            p2->y = t;
        }

        break;

    case SRE_REGEX_TYPE_ASSERT:
        pc->opcode = SRE_OPCODE_ASSERT;
        pc->v.assertion = r->data.assertion;
        pc++;

        break;

    case SRE_REGEX_TYPE_NIL:
        /* do nothing */

    default:
        /* impossible to reach here */
        break;
    }

    return pc;
}


static sre_int_t
sre_regex_compiler_add_char_class(sre_pool_t *pool, sre_instruction_t *pc,
    sre_regex_range_t *range)
{
    sre_char             *p;
    sre_uint_t            i, n;
    sre_regex_range_t    *r;

    n = 0;
    for (r = range; r; r = r->next) {
        n++;
    }

    p = sre_pnalloc(pool,
                    sizeof(sre_vm_ranges_t) + n * sizeof(sre_vm_range_t));
    if (p == NULL) {
        return SRE_ERROR;
    }

    pc->v.ranges = (sre_vm_ranges_t *) p;

    p += sizeof(sre_vm_ranges_t);
    pc->v.ranges->head = (sre_vm_range_t *) p;

    pc->v.ranges->count = n;

    for (i = 0, r = range; r; i++, r = r->next) {
        pc->v.ranges->head[i].from = r->from;
        pc->v.ranges->head[i].to = r->to;
    }

    return SRE_OK;
}
