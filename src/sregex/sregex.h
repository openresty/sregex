
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


enum {
    SRE_OK       = 0,
    SRE_ERROR    = -1,
    SRE_AGAIN    = -2,
    SRE_BUSY     = -3,
    SRE_DONE     = -4,
    SRE_DECLINED = -5
} sre_status_code_e;


/* the memory pool API */


struct sre_pool_s;
typedef struct sre_pool_s  sre_pool_t;


sre_pool_t *sre_create_pool(size_t size);
void sre_reset_pool(sre_pool_t *pool);
void sre_destroy_pool(sre_pool_t *pool);

void *sre_palloc(sre_pool_t *pool, size_t size);
void *sre_pnalloc(sre_pool_t *pool, size_t size);
void *sre_pcalloc(sre_pool_t *pool, size_t size);
int sre_pfree(sre_pool_t *pool, void *p);


/* the regex parser API */


enum {
    SRE_REGEX_CASELESS = 1
} sre_regex_flag_e;


struct sre_regex_s;
typedef struct sre_regex_s  sre_regex_t;


sre_regex_t *sre_regex_parse(sre_pool_t *pool, sre_char *src, sre_uint_t *ncaps,
    int flags, sre_int_t *err_offset);

void sre_regex_dump(sre_regex_t *re);


/* the regex compiler API */


struct sre_program_s;
typedef struct sre_program_s  sre_program_t;


void sre_program_dump(sre_program_t *prog);

sre_program_t *sre_regex_compile(sre_pool_t *pool, sre_regex_t *re);


/* the Pike VM API */


struct sre_vm_pike_ctx_s;
typedef struct sre_vm_pike_ctx_s  sre_vm_pike_ctx_t;


sre_vm_pike_ctx_t *sre_vm_pike_create_ctx(sre_pool_t *pool, sre_program_t *prog,
    sre_int_t *ovector, size_t ovecsize);

sre_int_t sre_vm_pike_exec(sre_vm_pike_ctx_t *ctx, sre_char *input, size_t len,
    unsigned eof);


/* the Thompson VM API */


struct sre_vm_thompson_ctx_s;
typedef struct sre_vm_thompson_ctx_s  sre_vm_thompson_ctx_t;


sre_vm_thompson_ctx_t *sre_vm_thompson_create_ctx(sre_pool_t *pool,
    sre_program_t *prog);

sre_int_t sre_vm_thompson_exec(sre_vm_thompson_ctx_t *ctx, sre_char *input,
    size_t len, unsigned eof);


#endif /* _SREGEX_H_INCLUDED_ */
