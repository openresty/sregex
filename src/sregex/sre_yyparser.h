/* A Bison parser, made by GNU Bison 2.7.  */

/* Bison interface for Yacc-like parsers in C
   
      Copyright (C) 1984, 1989-1990, 2000-2012 Free Software Foundation, Inc.
   
   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.
   
   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.
   
   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.
   
   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

#ifndef YY_SREGEX_YY_SRC_SREGEX_SRE_YYPARSER_H_INCLUDED
# define YY_SREGEX_YY_SRC_SREGEX_SRE_YYPARSER_H_INCLUDED
/* Enabling traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int sregex_yydebug;
#endif

/* Tokens.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
   /* Put the tokens into the symbol table, so that GDB and other debuggers
      know about them.  */
   enum yytokentype {
     SRE_REGEX_TOKEN_CHAR = 258,
     SRE_REGEX_TOKEN_EOF = 259,
     SRE_REGEX_TOKEN_BAD = 260,
     SRE_REGEX_TOKEN_CQUANT = 261,
     SRE_REGEX_TOKEN_CHAR_CLASS = 262,
     SRE_REGEX_TOKEN_ASSERTION = 263
   };
#endif


#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef union YYSTYPE
{
/* Line 2058 of yacc.c  */
#line 82 "src/sregex/sre_yyparser.y"

    sre_regex_t         *re;
    sre_char             ch;
    sre_uint_t           group;
    sre_regex_cquant_t   cquant;


/* Line 2058 of yacc.c  */
#line 73 "src/sregex/sre_yyparser.h"
} YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
#endif

#if ! defined YYLTYPE && ! defined YYLTYPE_IS_DECLARED
typedef struct YYLTYPE
{
  int first_line;
  int first_column;
  int last_line;
  int last_column;
} YYLTYPE;
# define yyltype YYLTYPE /* obsolescent; will be withdrawn */
# define YYLTYPE_IS_DECLARED 1
# define YYLTYPE_IS_TRIVIAL 1
#endif


#ifdef YYPARSE_PARAM
#if defined __STDC__ || defined __cplusplus
int sregex_yyparse (void *YYPARSE_PARAM);
#else
int sregex_yyparse ();
#endif
#else /* ! YYPARSE_PARAM */
#if defined __STDC__ || defined __cplusplus
int sregex_yyparse (sre_pool_t *pool, sre_char **src, sre_uint_t *ncaps, int flags, sre_regex_t **parsed, sre_char **err_pos);
#else
int sregex_yyparse ();
#endif
#endif /* ! YYPARSE_PARAM */

#endif /* !YY_SREGEX_YY_SRC_SREGEX_SRE_YYPARSER_H_INCLUDED  */
