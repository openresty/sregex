
/*
 * Copyright 2012 Yichun "agentzh" Zhang
 * Copyright 2007-2009 Russ Cox.  All Rights Reserved.
 * Use of this source code is governed by a BSD-style
 * license that can be found in the LICENSE file.
 */


#ifndef _SRE_BYTECODE_H_INCLUDED_
#define _SRE_BYTECODE_H_INCLUDED_


#include <sregex/sre_regex.h>
#include <stdio.h>


typedef enum {
    SRE_OPCODE_CHAR     = 1,
    SRE_OPCODE_MATCH    = 2,
    SRE_OPCODE_JMP      = 3,
    SRE_OPCODE_SPLIT    = 4,
    SRE_OPCODE_ANY      = 5,
    SRE_OPCODE_SAVE     = 6,
    SRE_OPCODE_IN       = 7,
    SRE_OPCODE_NOTIN    = 8,
    SRE_OPCODE_ASSERT   = 9
} sre_opcode_t;


typedef struct {
    sre_char      from;
    sre_char      to;
} sre_vm_range_t;


typedef struct {
    sre_uint_t          count;
    sre_vm_range_t     *head;
} sre_vm_ranges_t;


typedef struct sre_instruction_s  sre_instruction_t;

struct sre_instruction_s {
    sre_opcode_t             opcode;

    sre_instruction_t       *x;
    sre_instruction_t       *y;

    unsigned                 tag;

    union {
        sre_char                ch;
        sre_vm_ranges_t        *ranges;
        sre_uint_t              group; /* capture group */
        sre_uint_t              greedy;
        sre_uint_t              assertion;
        sre_int_t               regex_id;
    } v;
};


typedef struct sre_chain_s  sre_chain_t;

struct sre_chain_s {
    void            *data;
    sre_chain_t     *next;
};


struct sre_program_s {
    sre_instruction_t   *start;
    sre_uint_t           len;

    unsigned             tag;
    unsigned             uniq_threads; /* unique thread count */
    unsigned             dup_threads;  /* duplicatable thread count */
    unsigned             lookahead_asserts;
    unsigned             nullable;
    sre_chain_t         *leading_bytes;
    int                  leading_byte;

    sre_uint_t           ovecsize;
    sre_uint_t           nregexes;
    sre_uint_t           multi_ncaps[1];
};


void sre_dump_instruction(FILE *f, sre_instruction_t *pc,
    sre_instruction_t *start);


#endif /* _SRE_BYTECODE_H_INCLUDED_ */
