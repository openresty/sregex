
/*
 * Copyright 2012 Yichun "agentzh" Zhang
 * Copyright 2007-2009 Russ Cox.  All Rights Reserved.
 * Use of this source code is governed by a BSD-style
 * license that can be found in the LICENSE file.
 */


#ifndef _SRE_REGEX_H_INCLUDED_
#define _SRE_REGEX_H_INCLUDED_


#include <sre_core.h>
#include <sre_palloc.h>


typedef struct sre_regex_s  sre_regex_t;


typedef enum {
    SRE_REGEX_TYPE_ALT      = 1,
    SRE_REGEX_TYPE_CAT      = 2,
    SRE_REGEX_TYPE_LIT      = 3,
    SRE_REGEX_TYPE_DOT      = 4,
    SRE_REGEX_TYPE_PAREN    = 5,
    SRE_REGEX_TYPE_QUEST    = 6,
    SRE_REGEX_TYPE_STAR     = 7,
    SRE_REGEX_TYPE_PLUS     = 8
} sre_regex_type_t;


struct sre_regex_s {
    sre_regex_type_t     type;
    sre_regex_t         *left;
    sre_regex_t         *right;
    u_char               ch;
    unsigned             group;
    unsigned             greedy; /* :1 */
};


sre_regex_t *sre_regex_create(sre_pool_t *pool, sre_regex_type_t type,
    sre_regex_t *left, sre_regex_t *right);
void sre_regex_dump(sre_regex_t *re);
void sre_regex_error(char *fmt, ...);


#endif /* _SRE_REGEX_H_INCLUDED_ */
