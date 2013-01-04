
/*
 * Copyright 2012 Yichun "agentzh" Zhang
 * Copyright 2007-2009 Russ Cox.  All Rights Reserved.
 * Use of this source code is governed by a BSD-style
 * license that can be found in the LICENSE file.
 */


#ifndef _SRE_REGEX_H_INCLUDED_
#define _SRE_REGEX_H_INCLUDED_


#include <sregex/sre_core.h>
#include <sregex/sre_palloc.h>


typedef enum {
    SRE_REGEX_TYPE_NIL      = 0,
    SRE_REGEX_TYPE_ALT      = 1,
    SRE_REGEX_TYPE_CAT      = 2,
    SRE_REGEX_TYPE_LIT      = 3,
    SRE_REGEX_TYPE_DOT      = 4,
    SRE_REGEX_TYPE_PAREN    = 5,
    SRE_REGEX_TYPE_QUEST    = 6,
    SRE_REGEX_TYPE_STAR     = 7,
    SRE_REGEX_TYPE_PLUS     = 8,
    SRE_REGEX_TYPE_CLASS    = 9,
    SRE_REGEX_TYPE_NCLASS   = 10,
    SRE_REGEX_TYPE_ASSERT   = 11,
} sre_regex_type_t;


typedef enum {
    SRE_REGEX_ASSERTION_SMALL_B    = 0,
    SRE_REGEX_ASSERTION_BIG_B      = 1,
    SRE_REGEX_ASSERTION_BIG_A      = 2,
    SRE_REGEX_ASSERTION_SMALL_Z    = 3,
    SRE_REGEX_ASSERTION_CARET      = 4,
    SRE_REGEX_ASSERTION_DOLLAR     = 5
} sre_regex_assertion_type_t;


typedef struct sre_regex_range_s  sre_regex_range_t;

struct sre_regex_range_s {
    sre_char             from;
    sre_char             to;
    sre_regex_range_t   *next;
};


/* counted quantifier */

typedef struct {
    int     from;
    int     to;
} sre_regex_cquant_t;


struct sre_regex_s {
    sre_regex_type_t     type;
    sre_regex_t         *left;
    sre_regex_t         *right;
    sre_char             ch;
    sre_regex_range_t   *range;
    unsigned             group;
    unsigned             greedy; /* :1 */

    sre_regex_assertion_type_t   assertion_type:8;
};


SRE_NOAPI sre_regex_t *sre_regex_create(sre_pool_t *pool, sre_regex_type_t type,
    sre_regex_t *left, sre_regex_t *right);

SRE_NOAPI sre_regex_range_t *
    sre_regex_turn_char_class_caseless(sre_pool_t *pool,
                                       sre_regex_range_t *range);


#endif /* _SRE_REGEX_H_INCLUDED_ */
