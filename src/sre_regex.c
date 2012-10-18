
/*
 * Copyright 2012 Yichun "agentzh" Zhang
 * Copyright 2007-2009 Russ Cox.  All Rights Reserved.
 * Use of this source code is governed by a BSD-style
 * license that can be found in the LICENSE file.
 */


#include <sre_regex.h>


sre_regex_t *
sre_regex_create(sre_pool_t *pool, sre_regex_type_t type, sre_regex_t *left,
    sre_regex_t *right)
{
    sre_regex_t   *r;

    r = sre_palloc(pool, sizeof(sre_regex_t));
    if (r == NULL) {
        return NULL;
    }

    r->type = type;
    r->left = left;
    r->right = right;
    r->greedy = 1;
    r->nparens = 0;

    return r;
}


void
sre_regex_dump(sre_regex_t *r)
{
    switch (r->type) {
    case SRE_REGEX_TYPE_ALT:
        printf("Alt(");
        sre_regex_dump(r->left);
        printf(", ");
        sre_regex_dump(r->right);
        printf(")");
        break;

    case SRE_REGEX_TYPE_CAT:
        printf("Cat(");
        sre_regex_dump(r->left);
        printf(", ");
        sre_regex_dump(r->right);
        printf(")");
        break;

    case SRE_REGEX_TYPE_LIT:
        printf("Lit(%c)", r->ch);
        break;

    case SRE_REGEX_TYPE_DOT:
        printf("Dot");
        break;

    case SRE_REGEX_TYPE_PAREN:
        printf("Paren(%d, ", r->nparens);
        sre_regex_dump(r->left);
        printf(")");
        break;

    case SRE_REGEX_TYPE_STAR:
        if (!r->greedy) {
            printf("Ng");
        }

        printf("Star(");
        sre_regex_dump(r->left);
        printf(")");
        break;

    case SRE_REGEX_TYPE_PLUS:
        if (!r->greedy) {
            printf("Ng");
        }

        printf("Plus(");
        sre_regex_dump(r->left);
        printf(")");
        break;

    case SRE_REGEX_TYPE_QUEST:
        if (!r->greedy) {
            printf("Ng");
        }

        printf("Quest(");
        sre_regex_dump(r->left);
        printf(")");
        break;

    default:
        printf("???");
        break;
    }
}


void
sre_regex_error(char *fmt, ...)
{
    va_list     arg;

    va_start(arg, fmt);

    fprintf(stderr, "[error] ");
    vfprintf(stderr, fmt, arg);
    fprintf(stderr, "\n");

    va_end(arg);
}

