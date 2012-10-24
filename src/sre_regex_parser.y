
/*
 * Copyright 2012 Yichun "agentzh" Zhang.
 * Copyright 2007-2009 Russ Cox.  All Rights Reserved.
 * Use of this source code is governed by a BSD-style
 * license that can be found in the LICENSE file.
 */


%{

#include <sre_regex_parser.h>
#include <sre_palloc.h>


static int yylex(void);
static void yyerror(char *msg);

static unsigned      sre_regex_group;
static sre_pool_t   *sre_regex_pool;
static sre_regex_t  *sre_regex_parsed;

%}

%union {
    sre_regex_t         *re;
    u_char               ch;
    unsigned             group;
}


%token <ch>         SRE_REGEX_TOKEN_CHAR SRE_REGEX_TOKEN_EOF SRE_REGEX_TOKEN_BAD
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
    |
      {
        $$ = sre_regex_create(sre_regex_pool, SRE_REGEX_TYPE_NIL, NULL, NULL);
        if ($$ == NULL) {
            YYABORT;
        }
      }
    ;

%%

static u_char *sre_regex_str;


static int
yylex(void)
{
    u_char               c;
    unsigned             seen_dash, no_dash;
    sre_regex_t         *r;
    sre_regex_range_t   *range, *last;
    sre_regex_type_t     type;

    if (sre_regex_str == NULL || *sre_regex_str == '\0') {
        return SRE_REGEX_TOKEN_EOF;
    }

    c = *sre_regex_str++;
    if (strchr("-|*+?():.^$", (int) c)) {
        return c;
    }

    if (c == '[') {
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

            case '-':
                if (!seen_dash && last && !no_dash) {
                    seen_dash = 1;
                    break;
                }

            default:
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
    }

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
    sre_regex_t     *re, *dotstar;

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

    dotstar = sre_regex_create(pool, SRE_REGEX_TYPE_DOT, NULL, NULL);
    if (dotstar == NULL) {
        return NULL;
    }

    dotstar = sre_regex_create(pool, SRE_REGEX_TYPE_STAR, dotstar, NULL);
    if (dotstar == NULL) {
        return NULL;
    }

    return sre_regex_create(pool, SRE_REGEX_TYPE_CAT, dotstar, re);
}

