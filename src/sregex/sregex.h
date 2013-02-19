
/*
 * Copyright 2012 Yichun "agentzh" Zhang
 * Use of this source code is governed by a BSD-style
 * license that can be found in the LICENSE file.
 */


#ifndef _SREGEX_H_INCLUDED_
#define _SREGEX_H_INCLUDED_


#include <stdint.h>
#include <stdlib.h>


/* core constants and types */


#if defined _WIN32 || defined __CYGWIN__
#   ifdef BUILDING_DLL
#       ifdef __GNUC__
#           define SRE_API __attribute__ ((dllexport))
#       else
#           define SRE_API __declspec(dllexport)
#       endif
#   else
#       ifdef __GNUC__
#           define SRE_API __attribute__ ((dllimport))
#       else
#           define SRE_API __declspec(dllimport)
#       endif
#   endif
#   define SRE_NOAPI
#else
#   if __GNUC__ >= 4
#       define SRE_API    __attribute__ ((visibility ("default")))
#       define SRE_NOAPI  __attribute__ ((visibility ("hidden")))
#   else
#       define SRE_API
#       define SRE_NOAPI
#   endif
#endif


#ifndef sre_char
#define sre_char  sre_char
typedef uint8_t  sre_char;
#endif


#ifndef sre_int_t
#define sre_int_t sre_int_t
typedef intptr_t  sre_int_t;
#endif


#ifndef sre_uint_t
#define sre_uint_t sre_uint_t
typedef uintptr_t  sre_uint_t;
#endif


/* status code */
enum {
    SRE_OK       = 0,
    SRE_ERROR    = -1,
    SRE_AGAIN    = -2,
    SRE_BUSY     = -3,
    SRE_DONE     = -4,
    SRE_DECLINED = -5
};


/* the memory pool API */


struct sre_pool_s;
typedef struct sre_pool_s  sre_pool_t;


SRE_API sre_pool_t *sre_create_pool(size_t size);
SRE_API void sre_reset_pool(sre_pool_t *pool);
SRE_API void sre_destroy_pool(sre_pool_t *pool);


/* the regex parser API */


/* regex flags */
enum {
    SRE_REGEX_CASELESS = 1
};


struct sre_regex_s;
typedef struct sre_regex_s  sre_regex_t;


SRE_API sre_regex_t *sre_regex_parse(sre_pool_t *pool, sre_char *src,
    sre_uint_t *ncaps, int flags, sre_int_t *err_offset);

SRE_API void sre_regex_dump(sre_regex_t *re);

SRE_API sre_regex_t * sre_regex_parse_multi(sre_pool_t *pool,
    sre_char **regexes, sre_int_t nregexes, sre_uint_t *max_ncaps,
    int *multi_flags, sre_int_t *err_offset, sre_int_t *err_regex_id);


/* the regex compiler API */


struct sre_program_s;
typedef struct sre_program_s  sre_program_t;


SRE_API void sre_program_dump(sre_program_t *prog);

SRE_API sre_program_t *sre_regex_compile(sre_pool_t *pool, sre_regex_t *re);


/* the Pike VM API */


struct sre_vm_pike_ctx_s;
typedef struct sre_vm_pike_ctx_s  sre_vm_pike_ctx_t;


SRE_API sre_vm_pike_ctx_t *sre_vm_pike_create_ctx(sre_pool_t *pool,
    sre_program_t *prog, sre_int_t *ovector, size_t ovecsize);

SRE_API sre_int_t sre_vm_pike_exec(sre_vm_pike_ctx_t *ctx, sre_char *input,
    size_t len, unsigned eof, sre_int_t **pending_matched);


/* the Thompson VM API */


struct sre_vm_thompson_ctx_s;
typedef struct sre_vm_thompson_ctx_s  sre_vm_thompson_ctx_t;


SRE_API sre_vm_thompson_ctx_t *sre_vm_thompson_create_ctx(sre_pool_t *pool,
    sre_program_t *prog);

SRE_API sre_int_t sre_vm_thompson_exec(sre_vm_thompson_ctx_t *ctx, sre_char *input,
    size_t len, unsigned eof);


/* Thompson VM JIT API */


struct sre_vm_thompson_code_s;
typedef struct sre_vm_thompson_code_s  sre_vm_thompson_code_t;


typedef sre_int_t (*sre_vm_thompson_exec_pt)(sre_vm_thompson_ctx_t *ctx,
    sre_char *input, size_t size, unsigned eof);


SRE_API sre_int_t sre_vm_thompson_jit_compile(sre_pool_t *pool,
    sre_program_t *prog, sre_vm_thompson_code_t **pcode);

SRE_API sre_vm_thompson_ctx_t *sre_vm_thompson_jit_create_ctx(sre_pool_t *pool,
    sre_program_t *prog);

SRE_API sre_vm_thompson_exec_pt
    sre_vm_thompson_jit_get_handler(sre_vm_thompson_code_t *code);

SRE_API sre_int_t sre_vm_thompson_jit_free(sre_vm_thompson_code_t *code);


#endif /* _SREGEX_H_INCLUDED_ */
