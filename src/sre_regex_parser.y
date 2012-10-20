
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
    sre_regex_t     *re;
    int              ch;
    unsigned         group;
}


%token <ch>         SRE_REGEX_TOKEN_CHAR SRE_REGEX_TOKEN_EOF

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
    ;

%%

static u_char *sre_regex_str;


static int
yylex(void)
{
    u_char c;

    if (sre_regex_str == NULL || *sre_regex_str == '\0') {
        return SRE_REGEX_TOKEN_EOF;
    }

    c = *sre_regex_str++;
    if (strchr("|*+?():.", (int) c)) {
        return c;
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

    dotstar->greedy = 0;

    return sre_regex_create(pool, SRE_REGEX_TYPE_CAT, dotstar, re);
}

