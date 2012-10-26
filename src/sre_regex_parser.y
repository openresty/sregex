
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
#include <ddebug.h>


#include <sre_regex_parser.h>
#include <sre_palloc.h>


static int yylex(void);
static void yyerror(char *msg);
static sre_regex_t *sre_regex_desugar_counted_repetition(sre_regex_t *subj,
    sre_regex_cquant_t *cquant, unsigned greedy);


static unsigned      sre_regex_group;
static sre_pool_t   *sre_regex_pool;
static sre_regex_t  *sre_regex_parsed;

%}

%union {
    sre_regex_t         *re;
    u_char               ch;
    unsigned             group;
    sre_regex_cquant_t   cquant;
}


%token <ch>         SRE_REGEX_TOKEN_CHAR SRE_REGEX_TOKEN_EOF SRE_REGEX_TOKEN_BAD

%token <cquant>     SRE_REGEX_TOKEN_CQUANT

%token <re>         SRE_REGEX_TOKEN_CHAR_CLASS

%type  <re>         alt concat repeat atom regex
%type  <group>      count

%start              regex

%%

regex: alt SRE_REGEX_TOKEN_EOF
      {
        sre_regex_parsed = $1;
        return SRE_OK;
      }
    ;


alt: concat
   | alt '|' concat
     {
        $$ = sre_regex_create(sre_regex_pool, SRE_REGEX_TYPE_ALT, $1, $3);
        if ($$ == NULL) {
            YYABORT;
        }
     }
   ;


concat: repeat
      | concat repeat
        {
            $$ = sre_regex_create(sre_regex_pool, SRE_REGEX_TYPE_CAT, $1, $2);
            if ($$ == NULL) {
                YYABORT;
            }
        }
    |
      {
        $$ = sre_regex_create(sre_regex_pool, SRE_REGEX_TYPE_NIL, NULL, NULL);
        if ($$ == NULL) {
            YYABORT;
        }
      }
    ;


repeat: atom
      | atom '*'
        {
            $$ = sre_regex_create(sre_regex_pool, SRE_REGEX_TYPE_STAR, $1,
                                  NULL);
            if ($$ == NULL) {
                YYABORT;
            }

            $$->greedy = 1;
        }

      | atom '*' '?'
        {
            $$ = sre_regex_create(sre_regex_pool, SRE_REGEX_TYPE_STAR, $1,
                                  NULL);
            if ($$ == NULL) {
                YYABORT;
            }
        }

      | atom '+'
        {
            $$ = sre_regex_create(sre_regex_pool, SRE_REGEX_TYPE_PLUS, $1,
                                  NULL);
            if ($$ == NULL) {
                YYABORT;
            }

            $$->greedy = 1;
        }

      | atom '+' '?'
        {
            $$ = sre_regex_create(sre_regex_pool, SRE_REGEX_TYPE_PLUS, $1,
                                  NULL);
            if ($$ == NULL) {
                YYABORT;
            }
        }

      | atom '?'
        {
            $$ = sre_regex_create(sre_regex_pool, SRE_REGEX_TYPE_QUEST, $1,
                                  NULL);
            if ($$ == NULL) {
                YYABORT;
            }

            $$->greedy = 1;
        }

      | atom '?' '?'
        {
            $$ = sre_regex_create(sre_regex_pool, SRE_REGEX_TYPE_QUEST, $1,
                                  NULL);
            if ($$ == NULL) {
                YYABORT;
            }
        }

      | atom SRE_REGEX_TOKEN_CQUANT
        {
            $$ = sre_regex_desugar_counted_repetition($1, &$2, 1 /* greedy */);
            if ($$ == NULL) {
                YYABORT;
            }
        }

      | atom SRE_REGEX_TOKEN_CQUANT '?'
        {
            $$ = sre_regex_desugar_counted_repetition($1, &$2, 0 /* greedy */);
            if ($$ == NULL) {
                YYABORT;
            }
        }
      ;

count: { $$ = ++sre_regex_group; }
     ;


atom: '(' count alt ')'
      {
        $$ = sre_regex_create(sre_regex_pool, SRE_REGEX_TYPE_PAREN, $3, NULL);
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
        $$ = sre_regex_create(sre_regex_pool, SRE_REGEX_TYPE_LIT, NULL, NULL);
        if ($$ == NULL) {
            YYABORT;
        }

        $$->ch = $1;
      }

    | '.'
      {
        $$ = sre_regex_create(sre_regex_pool, SRE_REGEX_TYPE_DOT, NULL, NULL);
        if ($$ == NULL) {
            YYABORT;
        }
      }

    | SRE_REGEX_TOKEN_CHAR_CLASS
    ;

%%

static u_char *sre_regex_str;


static int
yylex(void)
{
    u_char               c;
    int                  from, to;
    unsigned             i, seen_dash, no_dash;
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

    if (sre_regex_str == NULL || *sre_regex_str == '\0') {
        return SRE_REGEX_TOKEN_EOF;
    }

    c = *sre_regex_str++;
    if (strchr("-|*+?():.^$", (int) c)) {
        return c;
    }

    if (c == '\\') {
        c = *sre_regex_str++;
        if (strchr("-|*+?():.^$\\[]{}", (int) c)) {
            yylval.ch = c;
            return SRE_REGEX_TOKEN_CHAR;
        }

        switch (c) {
        case 'd':
            /* \d is defined as [0-9] */

            r = sre_regex_create(sre_regex_pool, SRE_REGEX_TYPE_CLASS, NULL,
                                 NULL);
            if (r == NULL) {
                break;
            }

            range = sre_palloc(sre_regex_pool, sizeof(sre_regex_range_t));
            if (range == NULL) {
                break;
            }

            range->from = '0';
            range->to = '9';
            range->next = NULL;

            r->range = range;

            yylval.re = r;
            return SRE_REGEX_TOKEN_CHAR_CLASS;

        case 'D':
            /* \D is defined as [^0-9] */

            r = sre_regex_create(sre_regex_pool, SRE_REGEX_TYPE_NCLASS, NULL,
                                 NULL);
            if (r == NULL) {
                break;
            }

            range = sre_palloc(sre_regex_pool, sizeof(sre_regex_range_t));
            if (range == NULL) {
                break;
            }

            range->from = '0';
            range->to = '9';
            range->next = NULL;

            r->range = range;

            yylval.re = r;
            return SRE_REGEX_TOKEN_CHAR_CLASS;

        case 'w':
            /* \w is defined as [A-Za-z0-9_] */

            r = sre_regex_create(sre_regex_pool, SRE_REGEX_TYPE_CLASS, NULL,
                                 NULL);
            if (r == NULL) {
                break;
            }

            for (i = 0; i < sre_nelems(esc_w_ranges); i += 2) {
                range = sre_palloc(sre_regex_pool, sizeof(sre_regex_range_t));
                if (range == NULL) {
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

            yylval.re = r;
            return SRE_REGEX_TOKEN_CHAR_CLASS;

        case 'W':
            /* \W is defined as [^A-Za-z0-9_] */

            r = sre_regex_create(sre_regex_pool, SRE_REGEX_TYPE_NCLASS, NULL,
                                 NULL);
            if (r == NULL) {
                break;
            }

            for (i = 0; i < sre_nelems(esc_w_ranges); i += 2) {
                range = sre_palloc(sre_regex_pool, sizeof(sre_regex_range_t));
                if (range == NULL) {
                    yylval.ch = 0;
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

            yylval.re = r;
            return SRE_REGEX_TOKEN_CHAR_CLASS;

        case 's':
            /* \s is defined as [ \f\n\r\t] */

            r = sre_regex_create(sre_regex_pool, SRE_REGEX_TYPE_CLASS, NULL,
                                 NULL);
            if (r == NULL) {
                break;
            }

            for (i = 0; i < sre_nelems(esc_s_ranges); i += 2) {
                range = sre_palloc(sre_regex_pool, sizeof(sre_regex_range_t));
                if (range == NULL) {
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

            yylval.re = r;
            return SRE_REGEX_TOKEN_CHAR_CLASS;

        case 'S':
            /* \S is defined as [^ \f\n\r\t] */

            r = sre_regex_create(sre_regex_pool, SRE_REGEX_TYPE_NCLASS, NULL,
                                 NULL);
            if (r == NULL) {
                break;
            }

            for (i = 0; i < sre_nelems(esc_s_ranges); i += 2) {
                range = sre_palloc(sre_regex_pool, sizeof(sre_regex_range_t));
                if (range == NULL) {
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

            yylval.re = r;
            return SRE_REGEX_TOKEN_CHAR_CLASS;

        case 't':
            yylval.ch = '\t';
            return SRE_REGEX_TOKEN_CHAR;

        case 'n':
            yylval.ch = '\n';
            return SRE_REGEX_TOKEN_CHAR;

        case 'r':
            yylval.ch = '\r';
            return SRE_REGEX_TOKEN_CHAR;

        case 'f':
            yylval.ch = '\f';
            return SRE_REGEX_TOKEN_CHAR;

        case 'a':
            yylval.ch = '\a';
            return SRE_REGEX_TOKEN_CHAR;

        case 'e':
            yylval.ch = '\e';
            return SRE_REGEX_TOKEN_CHAR;

        default:
            break;
        }

        return SRE_REGEX_TOKEN_BAD;
    }

    switch (c) {
    case '[':
        /* get character class */

        if (*sre_regex_str == '^') {
            type = SRE_REGEX_TYPE_NCLASS;
            sre_regex_str++;

        } else {
            type = SRE_REGEX_TYPE_CLASS;
        }

        r = sre_regex_create(sre_regex_pool, type, NULL, NULL);
        if (r == NULL) {
            return SRE_REGEX_TOKEN_BAD;
        }

        last = NULL;
        seen_dash = 0;
        no_dash = 0;

        for ( ;; ) {
            c = *sre_regex_str++;
            switch (c) {
            case '\0':
                return SRE_REGEX_TOKEN_BAD;

            case ']':
                if (seen_dash) {
                    range = sre_palloc(sre_regex_pool, sizeof(sre_regex_range_t));
                    if (range == NULL) {
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

                yylval.re = r;
                return SRE_REGEX_TOKEN_CHAR_CLASS;

            case '\\':
                c = *sre_regex_str++;

                switch (c) {
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

                case '\0':
                    return SRE_REGEX_TOKEN_BAD;

                default:
                    break;
                }

                if (strchr("-|*+?():.^$\\[]{}", (int) c)) {
                    goto process_char;
                }

                if (seen_dash) {
                    range = sre_palloc(sre_regex_pool, sizeof(sre_regex_range_t));
                    if (range == NULL) {
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
                    range = sre_palloc(sre_regex_pool, sizeof(sre_regex_range_t));
                    if (range == NULL) {
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
                        range = sre_palloc(sre_regex_pool, sizeof(sre_regex_range_t));
                        if (range == NULL) {
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
                        range = sre_palloc(sre_regex_pool, sizeof(sre_regex_range_t));
                        if (range == NULL) {
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
                        range = sre_palloc(sre_regex_pool, sizeof(sre_regex_range_t));
                        if (range == NULL) {
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
                        range = sre_palloc(sre_regex_pool, sizeof(sre_regex_range_t));
                        if (range == NULL) {
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
                        range = sre_palloc(sre_regex_pool, sizeof(sre_regex_range_t));
                        if (range == NULL) {
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

                default:
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
                if (seen_dash) {
                    last->to = c;
                    seen_dash = 0;
                    no_dash = 1;
                    break;
                }

                if (no_dash) {
                    no_dash = 0;
                }

                range = sre_palloc(sre_regex_pool, sizeof(sre_regex_range_t));
                if (range == NULL) {
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

        c = *sre_regex_str;
        if (c < '0' || c > '9') {
            c = sre_regex_str[-1];
            break;
        }

        i = 0;
        from = 0;
        do {
            from = c - '0' + from * 10;
            c = sre_regex_str[++i];
        } while (c >= '0' && c <= '9');

        dd("from parsed: %d, next: %c", from, sre_regex_str[i]);

        if (c == '}') {
            to = from;
            sre_regex_str += i + 1;
            goto cquant_parsed;
        }

        if (c != ',') {
            dd("',' expected but got %c", c);
            c = sre_regex_str[-1];
            break;
        }

        c = sre_regex_str[++i];

        if (c == '}') {
            to = -1;
            sre_regex_str += i + 1;
            goto cquant_parsed;
        }

        if (c < '0' || c > '9') {
            c = sre_regex_str[-1];
            break;
        }

        to = 0;
        do {
            to = c - '0' + to * 10;
            c = sre_regex_str[++i];
        } while (c >= '0' && c <= '9');

        if (c != '}') {
            c = sre_regex_str[-1];
            break;
        }

        sre_regex_str += i + 1;

cquant_parsed:
        dd("from = %d, to = %d, next: %d", from, to, sre_regex_str[0]);

        if (from >= 100 || to >= 100) {
            dd("from or to too large: %d %d", from, to);
            return SRE_REGEX_TOKEN_BAD;
        }

        if (to > 0 && from > to) {
            return SRE_REGEX_TOKEN_BAD;
        }

        if (from == 0) {
            if (to == 1) {
                return '?';
            }

            if (to == -1) {
                return '*';
            }

        } else if (from == 1) {
            if (to == -1) {
                return '+';
            }
        }

        yylval.cquant.from = from;
        yylval.cquant.to = to;
        return SRE_REGEX_TOKEN_CQUANT;

    default:
        break;
    }

    dd("token char: %c(%d)", c, c);

    yylval.ch = c;
    return SRE_REGEX_TOKEN_CHAR;
}


static void
yyerror(char *s)
{
    sre_regex_error("%s", s);
    exit(1);
}


sre_regex_t *
sre_regex_parse(sre_pool_t *pool, u_char *src, unsigned *ncaps)
{
    sre_regex_t     *re, *r;

    sre_regex_str     = src;
    sre_regex_pool    = pool;
    sre_regex_group   = 0;

    if (yyparse() != SRE_OK) {
        return NULL;
    }

    if (sre_regex_parsed == NULL) {
        yyerror("syntax error");
        return NULL;
    }

    *ncaps = sre_regex_group;

    /* assemble the regex ".*?(regex)" */

    re = sre_regex_create(pool, SRE_REGEX_TYPE_PAREN, sre_regex_parsed, NULL);
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
sre_regex_desugar_counted_repetition(sre_regex_t *subj,
    sre_regex_cquant_t *cquant, unsigned greedy)
{
    int                  i;
    sre_regex_t         *concat, *quest, *star;

    if (cquant->from == 1 && cquant->to == 1) {
        return subj;
    }

    if (cquant->from == 0 && cquant->to == 0) {
        return sre_regex_create(sre_regex_pool, SRE_REGEX_TYPE_NIL, NULL, NULL);
    }

    /* generate subj{from} first */

    concat = subj;

    for (i = 1; i < cquant->from; i++) {
        concat = sre_regex_create(sre_regex_pool, SRE_REGEX_TYPE_CAT, concat, subj);
        if (concat == NULL) {
            return NULL;
        }
    }

    if (cquant->from == cquant->to) {
        return concat;
    }

    if (cquant->to == -1) {
        /* append subj* to concat */

        star = sre_regex_create(sre_regex_pool, SRE_REGEX_TYPE_STAR, subj,
                                NULL);
        if (star == NULL) {
            return NULL;
        }

        star->greedy = greedy;

        concat = sre_regex_create(sre_regex_pool, SRE_REGEX_TYPE_CAT, concat, star);
        if (concat == NULL) {
            return NULL;
        }

        return concat;
    }

    /* append (?:subj?){to - from} */

    quest = sre_regex_create(sre_regex_pool, SRE_REGEX_TYPE_QUEST, subj,
                             NULL);
    if (quest == NULL) {
        return NULL;
    }

    quest->greedy = greedy;

    for ( ; i < cquant->to; i++) {
        concat = sre_regex_create(sre_regex_pool, SRE_REGEX_TYPE_CAT, concat, quest);
        if (concat == NULL) {
            return NULL;
        }
    }

    return concat;
}

