
/*
 * Copyright 2012 Yichun "agentzh" Zhang.
 * Copyright 2007-2009 Russ Cox.  All Rights Reserved.
 * Use of this source code is governed by a BSD-style
 * license that can be found in the LICENSE file.
 */


%{

#ifndef DDEBUG
#define DDEBUG 0
#endif
#include <sregex/ddebug.h>


#include <sregex/sre_regex_parser.h>
#include <sregex/sre_palloc.h>


#define YYLTYPE YYLTYPE
typedef struct YYLTYPE {
    u_char  *pos;
    u_char  *last;
} YYLTYPE;


#define YYLLOC_DEFAULT(Cur, Rhs, N)                                          \
    do {                                                                     \
        if (N) {                                                             \
            (Cur).pos = YYRHSLOC(Rhs, 1).pos;                                \
            (Cur).last = YYRHSLOC(Rhs, N).last;                              \
        } else {                                                             \
            (Cur).pos = YYRHSLOC(Rhs, 0).last;                               \
            (Cur).last = (Cur).pos;                                          \
        }                                                                    \
    } while (0)


#include <sregex/sre_yyparser.h>
#include <ctype.h>


#define sre_read_char(sp)  *(*(sp))++


static int yylex(YYSTYPE *lvalp, YYLTYPE *locp, sre_pool_t *pool, u_char **src);
static void yyerror(YYLTYPE *locp, sre_pool_t *pool, u_char **src, sre_uint_t *ncaps, int flags,
    sre_regex_t **parsed, u_char **err_pos, char *s);
static sre_regex_t *sre_regex_desugar_counted_repetition(sre_pool_t *pool,
    sre_regex_t *subj, sre_regex_cquant_t *cquant, unsigned greedy);

%}


%output  "src/sregex/sre_yyparser.c"
%defines "src/sregex/sre_yyparser.h"


%define api.pure


%lex-param {sre_pool_t *pool}
%lex-param {u_char *src}


%parse-param {sre_pool_t *pool}
%parse-param {u_char **src}
%parse-param {sre_uint_t *ncaps}
%parse-param {int flags}
%parse-param {sre_regex_t **parsed}
%parse-param {u_char **err_pos}

%locations

%expect             32

%union {
    sre_regex_t         *re;
    u_char               ch;
    sre_uint_t           group;
    sre_regex_cquant_t   cquant;
}


%token <ch>         SRE_REGEX_TOKEN_CHAR SRE_REGEX_TOKEN_EOF SRE_REGEX_TOKEN_BAD

%token <cquant>     SRE_REGEX_TOKEN_CQUANT

%token <re>         SRE_REGEX_TOKEN_CHAR_CLASS SRE_REGEX_TOKEN_ASSERTION
%type  <re>         alt concat repeat atom regex

%type  <group>      count

%start              regex

%%

regex: alt SRE_REGEX_TOKEN_EOF
      {
        *parsed = $1;
        return SRE_OK;
      }
    ;


alt: concat
   | alt '|' concat
     {
        $$ = sre_regex_create(pool, SRE_REGEX_TYPE_ALT, $1, $3);
        if ($$ == NULL) {
            YYABORT;
        }
     }
   ;


concat: repeat
      | concat repeat
        {
            $$ = sre_regex_create(pool, SRE_REGEX_TYPE_CAT, $1, $2);
            if ($$ == NULL) {
                YYABORT;
            }
        }
    |
      {
        $$ = sre_regex_create(pool, SRE_REGEX_TYPE_NIL, NULL, NULL);
        if ($$ == NULL) {
            YYABORT;
        }
      }
    ;


repeat: atom
      | atom '*'
        {
            $$ = sre_regex_create(pool, SRE_REGEX_TYPE_STAR, $1,
                                  NULL);
            if ($$ == NULL) {
                YYABORT;
            }

            $$->greedy = 1;
        }

      | atom '*' '?'
        {
            $$ = sre_regex_create(pool, SRE_REGEX_TYPE_STAR, $1,
                                  NULL);
            if ($$ == NULL) {
                YYABORT;
            }
        }

      | atom '+'
        {
            $$ = sre_regex_create(pool, SRE_REGEX_TYPE_PLUS, $1,
                                  NULL);
            if ($$ == NULL) {
                YYABORT;
            }

            $$->greedy = 1;
        }

      | atom '+' '?'
        {
            $$ = sre_regex_create(pool, SRE_REGEX_TYPE_PLUS, $1,
                                  NULL);
            if ($$ == NULL) {
                YYABORT;
            }
        }

      | atom '?'
        {
            $$ = sre_regex_create(pool, SRE_REGEX_TYPE_QUEST, $1,
                                  NULL);
            if ($$ == NULL) {
                YYABORT;
            }

            $$->greedy = 1;
        }

      | atom '?' '?'
        {
            $$ = sre_regex_create(pool, SRE_REGEX_TYPE_QUEST, $1,
                                  NULL);
            if ($$ == NULL) {
                YYABORT;
            }
        }

      | atom SRE_REGEX_TOKEN_CQUANT
        {
            $$ = sre_regex_desugar_counted_repetition(pool, $1, &$2, 1 /* greedy */);
            if ($$ == NULL) {
                YYABORT;
            }
        }

      | atom SRE_REGEX_TOKEN_CQUANT '?'
        {
            $$ = sre_regex_desugar_counted_repetition(pool, $1, &$2, 0 /* greedy */);
            if ($$ == NULL) {
                YYABORT;
            }
        }
      ;


count: { $$ = ++(*ncaps); }
     ;


atom: '(' count alt ')'
      {
        $$ = sre_regex_create(pool, SRE_REGEX_TYPE_PAREN, $3, NULL);
        if ($$ == NULL) {
            YYABORT;
        }

        $$->group = $2;
      }

    | '(' '?' ':' alt ')'
      {
        $$ = $4;
      }

    | SRE_REGEX_TOKEN_CHAR
      {
        if ((flags & SRE_REGEX_CASELESS)
            && (($1 >= 'A' && $1 <= 'Z')
                || ($1 >= 'a' && $1 <= 'z')))
        {
            $$ = sre_regex_create(pool, SRE_REGEX_TYPE_CLASS, NULL,
                                 NULL);
            if ($$ == NULL) {
                YYABORT;
            }

            $$->range = sre_palloc(pool, sizeof(sre_regex_range_t));
            if ($$->range == NULL) {
                YYABORT;
            }

            $$->range->from = $1;
            $$->range->to = $1;

            $$->range->next = sre_palloc(pool, sizeof(sre_regex_range_t));
            if ($$->range->next == NULL) {
                YYABORT;
            }

            if ($1 <= 'Z') {
                /* upper case */
                $$->range->next->from = $1 + 32;
                $$->range->next->to = $1 + 32;

            } else {
                /* lower case */

                $$->range->next->from = $1 - 32;
                $$->range->next->to = $1 - 32;
            }

            $$->range->next->next = NULL;

        } else {
            $$ = sre_regex_create(pool, SRE_REGEX_TYPE_LIT, NULL, NULL);
            if ($$ == NULL) {
                YYABORT;
            }

            $$->ch = $1;
        }
      }

    | '.'
      {
        $$ = sre_regex_create(pool, SRE_REGEX_TYPE_DOT, NULL, NULL);
        if ($$ == NULL) {
            YYABORT;
        }
      }

    | '^'
      {
        $$ = sre_regex_create(pool, SRE_REGEX_TYPE_ASSERT, NULL, NULL);
        if ($$ == NULL) {
            YYABORT;
        }

        $$->assertion_type = SRE_REGEX_ASSERTION_CARET;
      }

    | '$'
      {
        $$ = sre_regex_create(pool, SRE_REGEX_TYPE_ASSERT, NULL, NULL);
        if ($$ == NULL) {
            YYABORT;
        }

        $$->assertion_type = SRE_REGEX_ASSERTION_DOLLAR;
      }

    | SRE_REGEX_TOKEN_ASSERTION
    | SRE_REGEX_TOKEN_CHAR_CLASS
      {
        if (flags & SRE_REGEX_CASELESS) {
            $$->range = sre_regex_turn_char_class_caseless(pool, $1->range);
            if ($$ == NULL) {
                YYABORT;
            }
        }
      }

    | ':'
      {
        $$ = sre_regex_create(pool, SRE_REGEX_TYPE_LIT, NULL, NULL);
        if ($$ == NULL) {
            YYABORT;
        }

        $$->ch = ':';
      }
    ;

%%


static int
yylex(YYSTYPE *lvalp, YYLTYPE *locp, sre_pool_t *pool, u_char **src)
{
    u_char               c;
    int                  from, to;
    sre_uint_t           i, n, num;
    unsigned             seen_dash, no_dash, seen_curly_bracket;
    sre_regex_t         *r;
    sre_regex_range_t   *range, *last = NULL;
    sre_regex_type_t     type;

    static u_char        esc_D_ranges[] = { 0, 47, 58, 255 };

    static u_char        esc_w_ranges[] = { 'A', 'Z', 'a', 'z', '0', '9',
                                            '_', '_' };

    static u_char        esc_W_ranges[] = { 0, 47, 58, 64, 91, 94, 96, 96,
                                            123, 255 };

    static u_char        esc_s_ranges[] = { ' ', ' ', '\f', '\f', '\n', '\n',
                                            '\r', '\r', '\t', '\t' };

    static u_char        esc_S_ranges[] = { 0, 8, 11, 11, 14, 31, 33, 255 };

    static u_char        esc_h_ranges[] = { 0x09, 0x09, 0x20, 0x20, 0xa0, 0xa0 };

    static u_char        esc_H_ranges[] = { 0x00, 0x08, 0x0a, 0x1f, 0x21, 0x9f,
                                            0xa1, 0xff };

    static u_char        esc_v_ranges[] = { 0x0a, 0x0a, 0x0b, 0x0b, 0x0c, 0x0c,
                                            0x0d, 0x0d, 0x85, 0x85 };

    static u_char        esc_V_ranges[] = { 0x00, 0x09, 0x0e, 0x84, 0x86, 0xff };

    locp->pos = *src;

    if (*src == NULL || **src == '\0') {
        locp->last = *src;
        return SRE_REGEX_TOKEN_EOF;
    }

    c = sre_read_char(src);
    if (strchr("|*+?():.^$", (int) c)) {
        locp->last = *src;
        return c;
    }

    if (c == '\\') {
        c = sre_read_char(src);

        if (c == '\0') {
            locp->last = *src;
            return SRE_REGEX_TOKEN_BAD;
        }

        if (!isprint(c)) {
            lvalp->ch = c;
            locp->last = *src;
            return SRE_REGEX_TOKEN_CHAR;
        }

        if (strchr("'\" iM%@!,_-|*+?():.^$\\/[]{}", (int) c)) {
            lvalp->ch = c;
            locp->last = *src;
            return SRE_REGEX_TOKEN_CHAR;
        }

        if (c >= '0' && c <= '7') {

            num = c - '0';
            i = 1;

            for (;;) {
                c = **src;

                if (c < '0' || c > '7') {
                    lvalp->ch = (u_char) num;
                    locp->last = *src;
                    return SRE_REGEX_TOKEN_CHAR;
                }

                num = (c - '0') + (num << 3);

                (*src)++;

                if (++i == 3) {
                    lvalp->ch = (u_char) num;
                    locp->last = *src;
                    return SRE_REGEX_TOKEN_CHAR;
                }
            }
        }

        switch (c) {
        case 'c':
            c = sre_read_char(src);
            if (c == '\0') {
                locp->last = *src;
                locp->last = *src;
                return SRE_REGEX_TOKEN_BAD;
            }

            if (c >= 'a' && c <= 'z') {
                c -= 32;
            }

            lvalp->ch = (u_char) (c ^ 64);

            dd("\\cK: %d", lvalp->ch);

            locp->last = *src;
            return SRE_REGEX_TOKEN_CHAR;

        case 'o':
            c = sre_read_char(src);
            if (c != '{') {
                locp->last = *src;
                return SRE_REGEX_TOKEN_BAD;
            }

            c = sre_read_char(src);

            num = 0;
            i = 0;

            for (;;) {
                dd("%d: hex digit: %c (%d)", (int) i, (int) c, c);

                if (c >= '0' && c <= '7') {
                    num = (c - '0') + (num << 3);

                } else if (c == '}') {
                    lvalp->ch = (u_char) num;
                    locp->last = *src;
                    return SRE_REGEX_TOKEN_CHAR;

                } else if (c == '\0') {
                    locp->last = *src;
                    return SRE_REGEX_TOKEN_BAD;

                } else {
                    (*src)--;
                    break;
                }

                if (++i == 3) {
                    dd("cur: '%c' (%d)", **src, **src);

                    if (sre_read_char(src) != '}') {
                        locp->last = *src;
                        return SRE_REGEX_TOKEN_BAD;
                    }

                    break;
                }

                c = sre_read_char(src);
            }

            dd("\\o{...}: %u, next: %c", num, **src);

            lvalp->ch = (u_char) num;
            locp->last = *src;
            return SRE_REGEX_TOKEN_CHAR;

        case 'x':
            c = sre_read_char(src);
            if (c == '{') {
                c = sre_read_char(src);
                seen_curly_bracket = 1;

            } else {
                seen_curly_bracket = 0;
            }

            num = 0;
            i = 0;

            for (;;) {
                dd("%d: hex digit: %c (%d)", (int) i, (int) c, c);

                if (c >= '0' && c <= '9') {
                    num = (c - '0') + (num << 4);

                } else if (c >= 'A' && c <= 'F') {
                    num = (c - 'A' + 10) + (num << 4);

                } else if (c >= 'a' && c <= 'f') {
                    num = (c - 'a' + 10) + (num << 4);

                } else if (seen_curly_bracket) {
                    if (c != '}') {
                        locp->last = *src;
                        return SRE_REGEX_TOKEN_BAD;
                    }

                    lvalp->ch = (u_char) num;
                    locp->last = *src;
                    return SRE_REGEX_TOKEN_CHAR;

                } else {
                    (*src)--;
                    break;
                }

                if (++i == 2) {
                    if (seen_curly_bracket) {
                        dd("cur: '%c' (%d)", **src, **src);

                        if (sre_read_char(src) != '}') {
                            locp->last = *src;
                            return SRE_REGEX_TOKEN_BAD;
                        }
                    }

                    break;
                }

                c = sre_read_char(src);
            }

            dd("\\x{...}: %u, next: %c", num, **src);

            lvalp->ch = (u_char) num;
            locp->last = *src;
            return SRE_REGEX_TOKEN_CHAR;

        case 'B':
            r = sre_regex_create(pool, SRE_REGEX_TYPE_ASSERT, NULL,
                                 NULL);
            if (r == NULL) {
                break;
            }

            r->assertion_type = SRE_REGEX_ASSERTION_BIG_B;

            lvalp->re = r;
            locp->last = *src;
            return SRE_REGEX_TOKEN_ASSERTION;

        case 'b':
            r = sre_regex_create(pool, SRE_REGEX_TYPE_ASSERT, NULL,
                                 NULL);
            if (r == NULL) {
                break;
            }

            r->assertion_type = SRE_REGEX_ASSERTION_SMALL_B;

            lvalp->re = r;
            locp->last = *src;
            return SRE_REGEX_TOKEN_ASSERTION;

        case 'z':
            r = sre_regex_create(pool, SRE_REGEX_TYPE_ASSERT, NULL,
                                 NULL);
            if (r == NULL) {
                break;
            }

            r->assertion_type = SRE_REGEX_ASSERTION_SMALL_Z;

            lvalp->re = r;
            locp->last = *src;
            return SRE_REGEX_TOKEN_ASSERTION;

        case 'A':

            r = sre_regex_create(pool, SRE_REGEX_TYPE_ASSERT, NULL,
                                 NULL);
            if (r == NULL) {
                break;
            }

            r->assertion_type = SRE_REGEX_ASSERTION_BIG_A;

            lvalp->re = r;
            locp->last = *src;
            return SRE_REGEX_TOKEN_ASSERTION;

        case 'd':
            /* \d is defined as [0-9] */

            r = sre_regex_create(pool, SRE_REGEX_TYPE_CLASS, NULL,
                                 NULL);
            if (r == NULL) {
                break;
            }

            range = sre_palloc(pool, sizeof(sre_regex_range_t));
            if (range == NULL) {
                break;
            }

            range->from = '0';
            range->to = '9';
            range->next = NULL;

            r->range = range;

            lvalp->re = r;
            locp->last = *src;
            return SRE_REGEX_TOKEN_CHAR_CLASS;

        case 'D':
            /* \D is defined as [^0-9] */

            r = sre_regex_create(pool, SRE_REGEX_TYPE_NCLASS, NULL,
                                 NULL);
            if (r == NULL) {
                break;
            }

            range = sre_palloc(pool, sizeof(sre_regex_range_t));
            if (range == NULL) {
                break;
            }

            range->from = '0';
            range->to = '9';
            range->next = NULL;

            r->range = range;

            lvalp->re = r;
            locp->last = *src;
            return SRE_REGEX_TOKEN_CHAR_CLASS;

        case 'w':
            /* \w is defined as [A-Za-z0-9_] */

            r = sre_regex_create(pool, SRE_REGEX_TYPE_CLASS, NULL,
                                 NULL);
            if (r == NULL) {
                break;
            }

            for (i = 0; i < sre_nelems(esc_w_ranges); i += 2) {
                range = sre_palloc(pool, sizeof(sre_regex_range_t));
                if (range == NULL) {
                    locp->last = *src;
                    return SRE_REGEX_TOKEN_BAD;
                }

                range->from = esc_w_ranges[i];
                range->to = esc_w_ranges[i + 1];

                if (i == 0) {
                    r->range = range;

                } else {
                    last->next = range;
                }

                if (i == sre_nelems(esc_w_ranges) - 2) {
                    range->next = NULL;

                } else {
                    last = range;
                }
            }

            lvalp->re = r;
            locp->last = *src;
            return SRE_REGEX_TOKEN_CHAR_CLASS;

        case 'W':
            /* \W is defined as [^A-Za-z0-9_] */

            r = sre_regex_create(pool, SRE_REGEX_TYPE_NCLASS, NULL,
                                 NULL);
            if (r == NULL) {
                break;
            }

            for (i = 0; i < sre_nelems(esc_w_ranges); i += 2) {
                range = sre_palloc(pool, sizeof(sre_regex_range_t));
                if (range == NULL) {
                    lvalp->ch = 0;
                    locp->last = *src;
                    return SRE_REGEX_TOKEN_BAD;
                }

                range->from = esc_w_ranges[i];
                range->to = esc_w_ranges[i + 1];

                if (i == 0) {
                    r->range = range;

                } else {
                    last->next = range;
                }

                if (i == sre_nelems(esc_w_ranges) - 2) {
                    range->next = NULL;

                } else {
                    last = range;
                }
            }

            lvalp->re = r;
            locp->last = *src;
            return SRE_REGEX_TOKEN_CHAR_CLASS;

        case 's':
            /* \s is defined as [ \f\n\r\t] */

            r = sre_regex_create(pool, SRE_REGEX_TYPE_CLASS, NULL,
                                 NULL);
            if (r == NULL) {
                break;
            }

            for (i = 0; i < sre_nelems(esc_s_ranges); i += 2) {
                range = sre_palloc(pool, sizeof(sre_regex_range_t));
                if (range == NULL) {
                    locp->last = *src;
                    return SRE_REGEX_TOKEN_BAD;
                }

                range->from = esc_s_ranges[i];
                range->to = esc_s_ranges[i + 1];

                if (i == 0) {
                    r->range = range;

                } else {
                    last->next = range;
                }

                if (i == sre_nelems(esc_s_ranges) - 2) {
                    range->next = NULL;

                } else {
                    last = range;
                }
            }

            lvalp->re = r;
            locp->last = *src;
            return SRE_REGEX_TOKEN_CHAR_CLASS;

        case 'S':
            /* \S is defined as [^ \f\n\r\t] */

            r = sre_regex_create(pool, SRE_REGEX_TYPE_NCLASS, NULL,
                                 NULL);
            if (r == NULL) {
                break;
            }

            for (i = 0; i < sre_nelems(esc_s_ranges); i += 2) {
                range = sre_palloc(pool, sizeof(sre_regex_range_t));
                if (range == NULL) {
                    locp->last = *src;
                    return SRE_REGEX_TOKEN_BAD;
                }

                range->from = esc_s_ranges[i];
                range->to = esc_s_ranges[i + 1];

                if (i == 0) {
                    r->range = range;

                } else {
                    last->next = range;
                }

                if (i == sre_nelems(esc_s_ranges) - 2) {
                    range->next = NULL;

                } else {
                    last = range;
                }
            }

            lvalp->re = r;
            locp->last = *src;
            return SRE_REGEX_TOKEN_CHAR_CLASS;

        case 'N':
            /* \N is defined as [^\n] */

            r = sre_regex_create(pool, SRE_REGEX_TYPE_NCLASS, NULL,
                                 NULL);
            if (r == NULL) {
                break;
            }

            range = sre_palloc(pool, sizeof(sre_regex_range_t));
            if (range == NULL) {
                break;
            }

            range->from = '\n';
            range->to = '\n';
            range->next = NULL;

            r->range = range;

            lvalp->re = r;
            locp->last = *src;
            return SRE_REGEX_TOKEN_CHAR_CLASS;

        case 'C':
            /* \C is defined as . */

            r = sre_regex_create(pool, SRE_REGEX_TYPE_DOT, NULL,
                                 NULL);
            if (r == NULL) {
                break;
            }

            lvalp->re = r;
            locp->last = *src;
            return SRE_REGEX_TOKEN_CHAR_CLASS;

        case 'h':
            r = sre_regex_create(pool, SRE_REGEX_TYPE_CLASS, NULL,
                                 NULL);
            if (r == NULL) {
                break;
            }

            for (i = 0; i < sre_nelems(esc_h_ranges); i += 2) {
                range = sre_palloc(pool, sizeof(sre_regex_range_t));
                if (range == NULL) {
                    locp->last = *src;
                    return SRE_REGEX_TOKEN_BAD;
                }

                range->from = esc_h_ranges[i];
                range->to = esc_h_ranges[i + 1];

                if (i == 0) {
                    r->range = range;

                } else {
                    last->next = range;
                }

                if (i == sre_nelems(esc_h_ranges) - 2) {
                    range->next = NULL;

                } else {
                    last = range;
                }
            }

            lvalp->re = r;
            locp->last = *src;
            return SRE_REGEX_TOKEN_CHAR_CLASS;

        case 'H':
            r = sre_regex_create(pool, SRE_REGEX_TYPE_NCLASS, NULL,
                                 NULL);
            if (r == NULL) {
                break;
            }

            for (i = 0; i < sre_nelems(esc_h_ranges); i += 2) {
                range = sre_palloc(pool, sizeof(sre_regex_range_t));
                if (range == NULL) {
                    locp->last = *src;
                    return SRE_REGEX_TOKEN_BAD;
                }

                range->from = esc_h_ranges[i];
                range->to = esc_h_ranges[i + 1];

                if (i == 0) {
                    r->range = range;

                } else {
                    last->next = range;
                }

                if (i == sre_nelems(esc_h_ranges) - 2) {
                    range->next = NULL;

                } else {
                    last = range;
                }
            }

            lvalp->re = r;
            locp->last = *src;
            return SRE_REGEX_TOKEN_CHAR_CLASS;

        case 'v':
            r = sre_regex_create(pool, SRE_REGEX_TYPE_CLASS, NULL,
                                 NULL);
            if (r == NULL) {
                break;
            }

            for (i = 0; i < sre_nelems(esc_v_ranges); i += 2) {
                range = sre_palloc(pool, sizeof(sre_regex_range_t));
                if (range == NULL) {
                    locp->last = *src;
                    return SRE_REGEX_TOKEN_BAD;
                }

                range->from = esc_v_ranges[i];
                range->to = esc_v_ranges[i + 1];

                if (i == 0) {
                    r->range = range;

                } else {
                    last->next = range;
                }

                if (i == sre_nelems(esc_v_ranges) - 2) {
                    range->next = NULL;

                } else {
                    last = range;
                }
            }

            lvalp->re = r;
            locp->last = *src;
            return SRE_REGEX_TOKEN_CHAR_CLASS;

        case 'V':
            r = sre_regex_create(pool, SRE_REGEX_TYPE_NCLASS, NULL,
                                 NULL);
            if (r == NULL) {
                break;
            }

            for (i = 0; i < sre_nelems(esc_v_ranges); i += 2) {
                range = sre_palloc(pool, sizeof(sre_regex_range_t));
                if (range == NULL) {
                    locp->last = *src;
                    return SRE_REGEX_TOKEN_BAD;
                }

                range->from = esc_v_ranges[i];
                range->to = esc_v_ranges[i + 1];

                if (i == 0) {
                    r->range = range;

                } else {
                    last->next = range;
                }

                if (i == sre_nelems(esc_v_ranges) - 2) {
                    range->next = NULL;

                } else {
                    last = range;
                }
            }

            lvalp->re = r;
            locp->last = *src;
            return SRE_REGEX_TOKEN_CHAR_CLASS;

        case 't':
            lvalp->ch = '\t';
            locp->last = *src;
            return SRE_REGEX_TOKEN_CHAR;

        case 'n':
            lvalp->ch = '\n';
            locp->last = *src;
            return SRE_REGEX_TOKEN_CHAR;

        case 'r':
            lvalp->ch = '\r';
            locp->last = *src;
            return SRE_REGEX_TOKEN_CHAR;

        case 'f':
            lvalp->ch = '\f';
            locp->last = *src;
            return SRE_REGEX_TOKEN_CHAR;

        case 'a':
            lvalp->ch = '\a';
            locp->last = *src;
            return SRE_REGEX_TOKEN_CHAR;

        case 'e':
            lvalp->ch = '\e';
            locp->last = *src;
            return SRE_REGEX_TOKEN_CHAR;

        default:
            break;
        }

        locp->last = *src;
        return SRE_REGEX_TOKEN_BAD;
    }

    switch (c) {
    case '[':
        /* get character class */

        if (**src == '^') {
            type = SRE_REGEX_TYPE_NCLASS;
            (*src)++;

        } else {
            type = SRE_REGEX_TYPE_CLASS;
        }

        r = sre_regex_create(pool, type, NULL, NULL);
        if (r == NULL) {
            locp->last = *src;
            return SRE_REGEX_TOKEN_BAD;
        }

        last = NULL;
        seen_dash = 0;
        no_dash = 0;
        n = 0;

        for ( ;; ) {
            n++;

            c = sre_read_char(src);

            dd("read char: %d", c);

            switch (c) {
            case '\0':
                locp->last = *src;
                return SRE_REGEX_TOKEN_BAD;

            case ']':
                dd("n == %d", n);

                if (n == 1) {
                    goto process_char;
                }

                if (seen_dash) {
                    range = sre_palloc(pool, sizeof(sre_regex_range_t));
                    if (range == NULL) {
                        locp->last = *src;
                        return SRE_REGEX_TOKEN_BAD;
                    }

                    range->from = '-';
                    range->to = '-';
                    range->next = NULL;

                    if (last) {
                        last->next = range;

                    } else {
                        r->range = range;
                    }
                }

                lvalp->re = r;
                locp->last = *src;
                return SRE_REGEX_TOKEN_CHAR_CLASS;

            case '\\':
                c = sre_read_char(src);

                if (c >= '0' && c <= '7') {

                    num = c - '0';
                    i = 1;

                    dd("\\ddd: %d", num);

                    for (;;) {
                        c = **src;

                        if (c < '0' || c > '7') {
                            dd("c before: %d", c);

                            c = (u_char) num;

                            dd("c after: %d", c);
                            goto process_char;
                        }

                        num = (c - '0') + (num << 3);

                        (*src)++;

                        if (++i == 3) {
                            c = (u_char) num;
                            goto process_char;
                        }
                    }
                }

                switch (c) {
                case 'c':
                    c = sre_read_char(src);

                    if (c == '\0') {
                        locp->last = *src;
                        return SRE_REGEX_TOKEN_BAD;
                    }

                    if (c >= 'a' && c <= 'z') {
                        c -= 32;
                    }

                    c = (u_char) (c ^ 64);

                    dd("\\cK: %d", lvalp->ch);

                    goto process_char;

                case 'o':
                    c = sre_read_char(src);
                    if (c != '{') {
                        locp->last = *src;
                        return SRE_REGEX_TOKEN_BAD;
                    }

                    c = sre_read_char(src);

                    num = 0;
                    i = 0;

                    for (;;) {
                        dd("%d: oct digit: %c (%d)", (int) i, (int) c, c);

                        if (c >= '0' && c <= '7') {
                            num = (c - '0') + (num << 3);

                        } else if (c == '}') {
                            c = (u_char) num;
                            goto process_char;

                        } else {
                            locp->last = *src;
                            return SRE_REGEX_TOKEN_BAD;
                        }

                        if (++i == 3) {
                            dd("cur: '%c' (%d)", **src, **src);

                            if (sre_read_char(src) != '}') {
                                locp->last = *src;
                                return SRE_REGEX_TOKEN_BAD;
                            }

                            break;
                        }

                        c = sre_read_char(src);
                    }

                    dd("\\x{...}: %u, next: %c", num, **src);

                    c = (u_char) num;
                    goto process_char;

                case 'x':
                    c = sre_read_char(src);
                    if (c == '{') {
                        c = sre_read_char(src);
                        seen_curly_bracket = 1;

                    } else {
                        seen_curly_bracket = 0;
                    }

                    num = 0;
                    i = 0;

                    for (;;) {
                        dd("%d: hex digit: %c (%d)", (int) i, (int) c, c);

                        if (c >= '0' && c <= '9') {
                            num = (c - '0') + (num << 4);

                        } else if (c >= 'A' && c <= 'F') {
                            num = (c - 'A' + 10) + (num << 4);

                        } else if (c >= 'a' && c <= 'f') {
                            num = (c - 'a' + 10) + (num << 4);

                        } else if (seen_curly_bracket) {
                            if (c != '}') {
                                locp->last = *src;
                                return SRE_REGEX_TOKEN_BAD;
                            }

                            c = (u_char) num;
                            goto process_char;

                        } else if (c == '\0') {
                            locp->last = *src;
                            return SRE_REGEX_TOKEN_BAD;

                        } else {
                            (*src)--;
                            break;
                        }

                        if (++i == 2) {
                            if (seen_curly_bracket) {
                                dd("cur: '%c' (%d)", **src, **src);

                                if (sre_read_char(src) != '}') {
                                    locp->last = *src;
                                    return SRE_REGEX_TOKEN_BAD;
                                }
                            }

                            break;
                        }

                        c = sre_read_char(src);
                    }

                    dd("\\x{...}: %u, next: %c", num, **src);

                    c = (u_char) num;
                    goto process_char;

                case 't':
                    c = '\t';
                    goto process_char;

                case 'n':
                    c = '\n';
                    goto process_char;

                case 'r':
                    c = '\r';
                    goto process_char;

                case 'f':
                    c = '\f';
                    goto process_char;

                case 'a':
                    c = '\a';
                    goto process_char;

                case 'e':
                    c = '\e';
                    goto process_char;

                case 'b':
                    c = '\b';
                    goto process_char;

                case '\0':
                    locp->last = *src;
                    return SRE_REGEX_TOKEN_BAD;

                default:
                    break;
                }

                if (!isprint(c)) {
                    goto process_char;
                }

                if (strchr("'\" iMzC%@!,_-|*+?():.^$\\/[]{}", (int) c)) {
                    goto process_char;
                }

                if (seen_dash) {
                    range = sre_palloc(pool, sizeof(sre_regex_range_t));
                    if (range == NULL) {
                        locp->last = *src;
                        return SRE_REGEX_TOKEN_BAD;
                    }

                    range->from = '-';
                    range->to = '-';
                    range->next = NULL;

                    if (last) {
                        last->next = range;

                    } else {
                        r->range = range;
                    }

                    last = range;
                    seen_dash = 0;
                }

                switch (c) {
                case 'd':
                    range = sre_palloc(pool, sizeof(sre_regex_range_t));
                    if (range == NULL) {
                        locp->last = *src;
                        return SRE_REGEX_TOKEN_BAD;
                    }

                    range->from = '0';
                    range->to = '9';
                    range->next = NULL;

                    if (last) {
                        last->next = range;

                    } else {
                        r->range = range;
                    }

                    last = range;

                    break;

                case 'D':
                    for (i = 0; i < sre_nelems(esc_D_ranges); i += 2) {
                        range = sre_palloc(pool, sizeof(sre_regex_range_t));
                        if (range == NULL) {
                            locp->last = *src;
                            return SRE_REGEX_TOKEN_BAD;
                        }

                        range->from = esc_D_ranges[i];
                        range->to = esc_D_ranges[i + 1];

                        if (last) {
                            last->next = range;

                        } else {
                            r->range = range;
                        }

                        range->next = NULL;
                        last = range;
                    }

                    break;

                case 'w':
                    for (i = 0; i < sre_nelems(esc_w_ranges); i += 2) {
                        range = sre_palloc(pool, sizeof(sre_regex_range_t));
                        if (range == NULL) {
                            locp->last = *src;
                            return SRE_REGEX_TOKEN_BAD;
                        }

                        range->from = esc_w_ranges[i];
                        range->to = esc_w_ranges[i + 1];

                        if (last) {
                            last->next = range;

                        } else {
                            r->range = range;
                        }

                        range->next = NULL;
                        last = range;
                    }

                    break;

                case 'W':
                    for (i = 0; i < sre_nelems(esc_W_ranges); i += 2) {
                        range = sre_palloc(pool, sizeof(sre_regex_range_t));
                        if (range == NULL) {
                            locp->last = *src;
                            return SRE_REGEX_TOKEN_BAD;
                        }

                        range->from = esc_W_ranges[i];
                        range->to = esc_W_ranges[i + 1];

                        if (last) {
                            last->next = range;

                        } else {
                            r->range = range;
                        }

                        range->next = NULL;
                        last = range;
                    }

                    break;

                case 's':
                    for (i = 0; i < sre_nelems(esc_s_ranges); i += 2) {
                        range = sre_palloc(pool, sizeof(sre_regex_range_t));
                        if (range == NULL) {
                            locp->last = *src;
                            return SRE_REGEX_TOKEN_BAD;
                        }

                        range->from = esc_s_ranges[i];
                        range->to = esc_s_ranges[i + 1];

                        if (last) {
                            last->next = range;

                        } else {
                            r->range = range;
                        }

                        range->next = NULL;
                        last = range;
                    }

                    break;

                case 'S':
                    for (i = 0; i < sre_nelems(esc_S_ranges); i += 2) {
                        range = sre_palloc(pool, sizeof(sre_regex_range_t));
                        if (range == NULL) {
                            locp->last = *src;
                            return SRE_REGEX_TOKEN_BAD;
                        }

                        range->from = esc_S_ranges[i];
                        range->to = esc_S_ranges[i + 1];

                        if (last) {
                            last->next = range;

                        } else {
                            r->range = range;
                        }

                        range->next = NULL;
                        last = range;
                    }

                    break;

                case 'v':
                    for (i = 0; i < sre_nelems(esc_v_ranges); i += 2) {
                        range = sre_palloc(pool, sizeof(sre_regex_range_t));
                        if (range == NULL) {
                            locp->last = *src;
                            return SRE_REGEX_TOKEN_BAD;
                        }

                        range->from = esc_v_ranges[i];
                        range->to = esc_v_ranges[i + 1];

                        if (last) {
                            last->next = range;

                        } else {
                            r->range = range;
                        }

                        range->next = NULL;
                        last = range;
                    }

                    break;

                case 'V':
                    for (i = 0; i < sre_nelems(esc_V_ranges); i += 2) {
                        range = sre_palloc(pool, sizeof(sre_regex_range_t));
                        if (range == NULL) {
                            locp->last = *src;
                            return SRE_REGEX_TOKEN_BAD;
                        }

                        range->from = esc_V_ranges[i];
                        range->to = esc_V_ranges[i + 1];

                        if (last) {
                            last->next = range;

                        } else {
                            r->range = range;
                        }

                        range->next = NULL;
                        last = range;
                    }

                    break;

                case 'h':
                    for (i = 0; i < sre_nelems(esc_h_ranges); i += 2) {
                        range = sre_palloc(pool, sizeof(sre_regex_range_t));
                        if (range == NULL) {
                            locp->last = *src;
                            return SRE_REGEX_TOKEN_BAD;
                        }

                        range->from = esc_h_ranges[i];
                        range->to = esc_h_ranges[i + 1];

                        if (last) {
                            last->next = range;

                        } else {
                            r->range = range;
                        }

                        range->next = NULL;
                        last = range;
                    }

                    break;

                case 'H':
                    for (i = 0; i < sre_nelems(esc_H_ranges); i += 2) {
                        range = sre_palloc(pool, sizeof(sre_regex_range_t));
                        if (range == NULL) {
                            locp->last = *src;
                            return SRE_REGEX_TOKEN_BAD;
                        }

                        range->from = esc_H_ranges[i];
                        range->to = esc_H_ranges[i + 1];

                        if (last) {
                            last->next = range;

                        } else {
                            r->range = range;
                        }

                        range->next = NULL;
                        last = range;
                    }

                    break;

                default:
                    locp->last = *src;
                    return SRE_REGEX_TOKEN_BAD;
                }

                no_dash = 1;
                break;

            case '-':
                if (!seen_dash && last && !no_dash) {
                    seen_dash = 1;
                    break;
                }

            default:
process_char:
                dd("next: %d", **src);

                if (seen_dash) {
                    last->to = c;

                    if (last->to < last->from) {
                        locp->last = *src;
                        return SRE_REGEX_TOKEN_BAD;
                    }

                    seen_dash = 0;
                    no_dash = 1;
                    break;
                }

                if (no_dash) {
                    no_dash = 0;
                }

                range = sre_palloc(pool, sizeof(sre_regex_range_t));
                if (range == NULL) {
                    locp->last = *src;
                    return SRE_REGEX_TOKEN_BAD;
                }

                range->from = c;
                range->to = c;
                range->next = NULL;

                if (last) {
                    last->next = range;

                } else {
                    r->range = range;
                }

                last = range;
                break;
            }
        }

        break;

    case '{':
        /* quantifier for counted repetition */

        c = **src;
        if (c < '0' || c > '9') {
            c = (*src)[-1];
            break;
        }

        i = 0;
        from = 0;
        do {
            from = c - '0' + from * 10;
            c = (*src)[++i];
        } while (c >= '0' && c <= '9');

        dd("from parsed: %d, next: %c", from, (*src)[i]);

        if (c == '}') {
            to = from;
            (*src) += i + 1;
            goto cquant_parsed;
        }

        if (c != ',') {
            dd("',' expected but got %c", c);
            c = (*src)[-1];
            break;
        }

        c = (*src)[++i];

        if (c == '}') {
            to = -1;
            (*src) += i + 1;
            goto cquant_parsed;
        }

        if (c < '0' || c > '9') {
            c = (*src)[-1];
            break;
        }

        to = 0;
        do {
            to = c - '0' + to * 10;
            c = (*src)[++i];
        } while (c >= '0' && c <= '9');

        if (c != '}') {
            c = (*src)[-1];
            break;
        }

        (*src) += i + 1;

cquant_parsed:
        dd("from = %d, to = %d, next: %d", from, to, (*src)[0]);

        if (from >= 500 || to >= 500) {
            dd("from or to too large: %d %d", from, to);
            locp->last = *src;
            return SRE_REGEX_TOKEN_BAD;
        }

        if (to >= 0 && from > to) {
            locp->last = *src;
            return SRE_REGEX_TOKEN_BAD;
        }

        if (from == 0) {
            if (to == 1) {
                locp->last = *src;
                return '?';
            }

            if (to == -1) {
                locp->last = *src;
                return '*';
            }

        } else if (from == 1) {
            if (to == -1) {
                locp->last = *src;
                return '+';
            }
        }

        lvalp->cquant.from = from;
        lvalp->cquant.to = to;
        locp->last = *src;
        return SRE_REGEX_TOKEN_CQUANT;

    default:
        break;
    }

    dd("token char: %c(%d)", c, c);

    lvalp->ch = c;
    locp->last = *src;
    return SRE_REGEX_TOKEN_CHAR;
}


static void
yyerror(YYLTYPE *locp, sre_pool_t *pool, u_char **src, sre_uint_t *ncaps, int flags,
    sre_regex_t **parsed, u_char **err_pos, char *msg)
{
    *err_pos = locp->pos;
}


sre_regex_t *
sre_regex_parse(sre_pool_t *pool, u_char *src, sre_uint_t *ncaps, int flags,
    sre_int_t *err_offset)
{
    u_char          *start, *err_pos = NULL;
    sre_regex_t     *re, *r;
    sre_regex_t     *parsed = NULL;

    start = src;
    *ncaps = 0;
    *err_offset = -1;

    if (yyparse(pool, &src, ncaps, flags, &parsed, &err_pos) != SRE_OK) {
        if (err_pos) {
            *err_offset = (sre_int_t) (err_pos - start);
        }

        return NULL;
    }

    if (parsed == NULL) {
        return NULL;
    }

    /* assemble the regex ".*?(regex)" */

    re = sre_regex_create(pool, SRE_REGEX_TYPE_PAREN, parsed, NULL);
            /* $0 capture */

    if (re == NULL) {
        return NULL;
    }

    r = sre_regex_create(pool, SRE_REGEX_TYPE_DOT, NULL, NULL);
    if (r == NULL) {
        return NULL;
    }

    r = sre_regex_create(pool, SRE_REGEX_TYPE_STAR, r, NULL);
    if (r == NULL) {
        return NULL;
    }

    return sre_regex_create(pool, SRE_REGEX_TYPE_CAT, r, re);
}


static sre_regex_t *
sre_regex_desugar_counted_repetition(sre_pool_t *pool, sre_regex_t *subj,
    sre_regex_cquant_t *cquant, unsigned greedy)
{
    int                  i;
    sre_regex_t         *concat, *quest, *star;

    if (cquant->from == 1 && cquant->to == 1) {
        return subj;
    }

    /* generate subj{from} first */

    if (cquant->from == 0) {
        concat = sre_regex_create(pool, SRE_REGEX_TYPE_NIL, NULL, NULL);
        if (concat == NULL) {
            return NULL;
        }

        i = 0;

    } else {
        concat = subj;

        for (i = 1; i < cquant->from; i++) {
            concat = sre_regex_create(pool, SRE_REGEX_TYPE_CAT, concat, subj);
            if (concat == NULL) {
                return NULL;
            }
        }
    }

    if (cquant->from == cquant->to) {
        return concat;
    }

    if (cquant->to == -1) {
        /* append subj* to concat */

        star = sre_regex_create(pool, SRE_REGEX_TYPE_STAR, subj,
                                NULL);
        if (star == NULL) {
            return NULL;
        }

        star->greedy = greedy;

        concat = sre_regex_create(pool, SRE_REGEX_TYPE_CAT, concat, star);
        if (concat == NULL) {
            return NULL;
        }

        return concat;
    }

    /* append (?:subj?){to - from} */

    quest = sre_regex_create(pool, SRE_REGEX_TYPE_QUEST, subj,
                             NULL);
    if (quest == NULL) {
        return NULL;
    }

    quest->greedy = greedy;

    for ( ; i < cquant->to; i++) {
        concat = sre_regex_create(pool, SRE_REGEX_TYPE_CAT, concat, quest);
        if (concat == NULL) {
            return NULL;
        }
    }

    return concat;
}

