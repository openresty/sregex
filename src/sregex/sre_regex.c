
/*
 * Copyright 2012 Yichun "agentzh" Zhang
 * Copyright 2007-2009 Russ Cox.  All Rights Reserved.
 * Use of this source code is governed by a BSD-style
 * license that can be found in the LICENSE file.
 */


#include <sregex/sre_regex.h>
#include <stdio.h>


SRE_NOAPI sre_regex_t *
sre_regex_create(sre_pool_t *pool, sre_regex_type_t type, sre_regex_t *left,
    sre_regex_t *right)
{
    sre_regex_t   *r;

    r = sre_pcalloc(pool, sizeof(sre_regex_t));
    if (r == NULL) {
        return NULL;
    }

    r->type = type;
    r->left = left;
    r->right = right;

    return r;
}


SRE_API void
sre_regex_dump(sre_regex_t *r)
{
    sre_regex_range_t       *range;

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
        printf("Lit(%d)", (int) r->data.ch);
        break;

    case SRE_REGEX_TYPE_DOT:
        printf("Dot");
        break;

    case SRE_REGEX_TYPE_PAREN:
        printf("Paren(%lu, ", (unsigned long) r->data.group);
        sre_regex_dump(r->left);
        printf(")");
        break;

    case SRE_REGEX_TYPE_STAR:
        if (!r->data.greedy) {
            printf("Ng");
        }

        printf("Star(");
        sre_regex_dump(r->left);
        printf(")");
        break;

    case SRE_REGEX_TYPE_PLUS:
        if (!r->data.greedy) {
            printf("Ng");
        }

        printf("Plus(");
        sre_regex_dump(r->left);
        printf(")");
        break;

    case SRE_REGEX_TYPE_QUEST:
        if (!r->data.greedy) {
            printf("Ng");
        }

        printf("Quest(");
        sre_regex_dump(r->left);
        printf(")");
        break;

    case SRE_REGEX_TYPE_NIL:
        printf("Nil");
        break;

    case SRE_REGEX_TYPE_CLASS:
        printf("CLASS(");

        for (range = r->data.range; range; range = range->next) {
            printf("[%d, %d]", range->from, range->to);
        }

        printf(")");
        break;

    case SRE_REGEX_TYPE_NCLASS:
        printf("NCLASS(");

        for (range = r->data.range; range; range = range->next) {
            printf("[%d, %d]", range->from, range->to);
        }

        printf(")");
        break;

    case SRE_REGEX_TYPE_ASSERT:
        printf("ASSERT(");
        switch (r->data.assertion) {
            case SRE_REGEX_ASSERT_BIG_A:
                printf("\\A");
                break;

            case SRE_REGEX_ASSERT_CARET:
                printf("^");
                break;

            case SRE_REGEX_ASSERT_DOLLAR:
                printf("$");
                break;

            case SRE_REGEX_ASSERT_SMALL_Z:
                printf("\\z");
                break;

            case SRE_REGEX_ASSERT_BIG_B:
                printf("\\B");
                break;

            case SRE_REGEX_ASSERT_SMALL_B:
                printf("\\b");
                break;

            default:
                printf("???");
                break;
        }
        printf(")");
        break;

    case SRE_REGEX_TYPE_TOPLEVEL:
        printf("TOPLEVEL(%lu, ", (unsigned long) r->data.regex_id);
        sre_regex_dump(r->left);
        printf(")");
        break;

    default:
        printf("???");
        break;
    }
}


SRE_NOAPI sre_regex_range_t *
sre_regex_turn_char_class_caseless(sre_pool_t *pool, sre_regex_range_t *range)
{
    sre_char              from, to;
    sre_regex_range_t    *r, *nr;

    for (r = range; r; r = r->next) {
        from = r->from;
        to   = r->to;

        if (to >= 'A' && from <= 'Z') {
            /* overlap with A-Z */

            nr = sre_palloc(pool, sizeof(sre_regex_range_t));
            if (nr == NULL) {
                return NULL;
            }

            nr->from = sre_max(from, 'A') + 32;
            nr->to = sre_min(to, 'Z') + 32;
            nr->next = r->next;

            r->next = nr;
            r = nr;
        }

        if (to >= 'a' && from <= 'z') {
            /* overlap with a-z */

            nr = sre_palloc(pool, sizeof(sre_regex_range_t));
            if (nr == NULL) {
                return NULL;
            }

            nr->from = sre_max(from, 'a') - 32;
            nr->to = sre_min(to, 'z') - 32;
            nr->next = r->next;

            r->next = nr;
            r = nr;
        }
    }

    return range;
}
