
/*
 * Copyright 2012-2013 Yichun Zhang (agentzh)
 * Copyright 2007-2009 Russ Cox.  All Rights Reserved.
 * Use of this source code is governed by a BSD-style
 * license that can be found in the LICENSE file.
 */


#ifndef DDEBUG
#define DDEBUG 0
#endif
#include <sregex/ddebug.h>


#include <sregex/sre_vm_bytecode.h>


static sre_int_t sre_program_get_leading_bytes(sre_pool_t *pool,
    sre_program_t *prog, sre_chain_t **res);
static sre_int_t sre_program_get_leading_bytes_helper(sre_pool_t *pool,
    sre_instruction_t *pc, sre_program_t *prog, sre_chain_t **res,
    unsigned tag);
static sre_uint_t sre_program_len(sre_regex_t *r);
static sre_instruction_t *sre_regex_emit_bytecode(sre_pool_t *pool,
    sre_instruction_t *pc, sre_regex_t *re);
static sre_int_t sre_regex_compiler_add_char_class(sre_pool_t *pool,
    sre_instruction_t *pc, sre_regex_range_t *range);


sre_program_t *
sre_regex_compile(sre_pool_t *pool, sre_regex_t *re)
{
    sre_uint_t           i, n, multi_ncaps_size;
    sre_char            *p;
    sre_program_t       *prog;
    sre_instruction_t   *pc;

    n = sre_program_len(re);

    multi_ncaps_size = (re->nregexes - 1) * sizeof(sre_uint_t);

    p = sre_pnalloc(pool,
                    sizeof(sre_program_t) + multi_ncaps_size
                    + n * sizeof(sre_instruction_t));

    if (p == NULL) {
        return NULL;
    }

    prog = (sre_program_t *) p;

    prog->nregexes = re->nregexes;

    memcpy(prog->multi_ncaps, re->data.multi_ncaps,
           re->nregexes * sizeof(sre_uint_t));

    prog->start = (sre_instruction_t *) (p + sizeof(sre_program_t)
                                         + multi_ncaps_size);

    sre_memzero(prog->start, n * sizeof(sre_instruction_t));

    pc = sre_regex_emit_bytecode(pool, prog->start, re);
    if (pc == NULL) {
        return NULL;
    }

    if (pc - prog->start != n) {
        dd("buffer error: %d != %d", (int) (pc - prog->start), (int) n);
        return NULL;
    }

    prog->len = pc - prog->start;
    prog->tag = 0;
    prog->lookahead_asserts = 0;
    prog->dup_threads = 0;
    prog->uniq_threads = 0;
    prog->nullable = 0;
    prog->leading_bytes = NULL;
    prog->leading_byte = -1;

    prog->ovecsize = 0;
    for (i = 0; i < prog->nregexes; i++) {
        prog->ovecsize += prog->multi_ncaps[i] + 1;
    }
    prog->ovecsize *= 2 * sizeof(sre_uint_t);

    if (sre_program_get_leading_bytes(pool, prog, &prog->leading_bytes)
        == SRE_ERROR)
    {
        return NULL;
    }

    if (prog->leading_bytes && prog->leading_bytes->next == NULL) {
        pc = prog->leading_bytes->data;
        if (pc->opcode == SRE_OPCODE_CHAR) {
            prog->leading_byte = pc->v.ch;
        }
    }

    dd("nullable: %u", prog->nullable);

#if (DDEBUG)
    {
        sre_chain_t         *cl;

        for (cl = prog->leading_bytes; cl; cl = cl->next) {
            pc = cl->data;
            fprintf(stderr, "[");
            sre_dump_instruction(stderr, pc, prog->start);
            fprintf(stderr, "]");
        }
        if (prog->leading_bytes) {
            fprintf(stderr, "\n");
        }
    }
#endif

    return prog;
}


static sre_int_t
sre_program_get_leading_bytes(sre_pool_t *pool, sre_program_t *prog,
    sre_chain_t **res)
{
    unsigned             tag;
    sre_int_t            rc;

    tag = prog->tag + 1;

    rc = sre_program_get_leading_bytes_helper(pool, prog->start, prog, res,
                                              tag);
    prog->tag = tag;

    if (rc == SRE_ERROR) {
        return SRE_ERROR;
    }

    if (rc == SRE_DECLINED || prog->nullable) {
        *res = NULL;
        return SRE_DECLINED;
    }

    return rc;
}


static sre_int_t
sre_program_get_leading_bytes_helper(sre_pool_t *pool, sre_instruction_t *pc,
    sre_program_t *prog, sre_chain_t **res, unsigned tag)
{
    sre_int_t            rc;
    sre_chain_t         *cl, *ncl;
    sre_instruction_t   *bc;

    if (pc->tag == tag) {
        return SRE_OK;
    }

    if (pc == prog->start + 1) {
        /* skip the dot (.) in the initial boilerplate ".*?" */
        return SRE_OK;
    }

    pc->tag = tag;

    switch (pc->opcode) {
    case SRE_OPCODE_SPLIT:
        rc = sre_program_get_leading_bytes_helper(pool, pc->x, prog, res,
                                                  tag);
        if (rc != SRE_OK) {
            return rc;
        }

        return sre_program_get_leading_bytes_helper(pool, pc->y, prog, res,
                                                    tag);

    case SRE_OPCODE_JMP:
        return sre_program_get_leading_bytes_helper(pool, pc->x, prog, res,
                                                    tag);

    case SRE_OPCODE_SAVE:
        if (++pc == prog->start + prog->len) {
            return SRE_OK;
        }

        return sre_program_get_leading_bytes_helper(pool, pc, prog, res,
                                                    tag);

    case SRE_OPCODE_MATCH:
        prog->nullable = 1;
        return SRE_DONE;

    case SRE_OPCODE_ASSERT:
        if (++pc == prog->start + prog->len) {
            return SRE_OK;
        }

        return sre_program_get_leading_bytes_helper(pool, pc, prog, res, tag);

    case SRE_OPCODE_ANY:
        return SRE_DECLINED;

    default:
        /* CHAR, ANY, IN, NOTIN */

        ncl = sre_palloc(pool, sizeof(sre_chain_t));
        if (ncl == NULL) {
            return SRE_ERROR;
        }

        ncl->data = pc;
        ncl->next = NULL;

        if (*res) {
            for (cl = *res; /* void */; cl = cl->next) {
                bc = cl->data;
                if (bc->opcode == pc->opcode) {
                    if (bc->opcode == SRE_OPCODE_CHAR) {
                        if (bc->v.ch == pc->v.ch) {
                            return SRE_OK;
                        }
                    }
                }

                if (cl->next == NULL) {
                    cl->next = ncl;
                    return SRE_OK;
                }
            }

        } else {
            *res = ncl;
        }

        return SRE_OK;
    }

    /* impossible to reach here */
}


static sre_uint_t
sre_program_len(sre_regex_t *r)
{
    dd("program len on node: %d", (int) r->type);

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

    case SRE_REGEX_TYPE_TOPLEVEL:
        return 1 + sre_program_len(r->left);

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

    dd("program emit bytecode on node: %d", (int) r->type);

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
        pc->v.ch = r->data.ch;
        pc++;
        break;

    case SRE_REGEX_TYPE_CLASS:
        pc->opcode = SRE_OPCODE_IN;

        if (sre_regex_compiler_add_char_class(pool, pc, r->data.range)
            != SRE_OK)
        {
            return NULL;
        }

        pc++;
        break;

    case SRE_REGEX_TYPE_NCLASS:
        pc->opcode = SRE_OPCODE_NOTIN;

        if (sre_regex_compiler_add_char_class(pool, pc, r->data.range)
            != SRE_OK)
        {
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

    case SRE_REGEX_TYPE_TOPLEVEL:
        pc = sre_regex_emit_bytecode(pool, pc, r->left);
        if (pc == NULL) {
            return NULL;
        }

        pc->opcode = SRE_OPCODE_MATCH;

        dd("setting regex id %ld", (long) r->data.regex_id);

        pc->v.regex_id = r->data.regex_id;
        pc++;

        break;

    case SRE_REGEX_TYPE_NIL:
        /* do nothing */
        break;

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
