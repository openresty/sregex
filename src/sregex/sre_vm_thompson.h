
/*
 * Copyright 2012 Yichun "agentzh" Zhang
 * Use of this source code is governed by a BSD-style
 * license that can be found in the LICENSE file.
 */


#ifndef _SRE_VM_THOMPSON_H_INCLUDED_
#define _SRE_VM_THOMPSON_H_INCLUDED_


#include <sregex/sre_core.h>
#include <sregex/sre_vm_bytecode.h>


typedef struct {
    sre_instruction_t       *pc;
    void                    *asserts_handler;
    uint8_t                  seen_word;     /* :1 */
} sre_vm_thompson_thread_t;


typedef struct {
    sre_uint_t                  count;
    sre_vm_thompson_thread_t    threads[1];
} sre_vm_thompson_thread_list_t;


struct sre_vm_thompson_ctx_s {
    sre_pool_t          *pool;
    sre_program_t       *program;
    sre_char            *buffer;

    sre_vm_thompson_thread_list_t       *current_threads;
    sre_vm_thompson_thread_list_t       *next_threads;

    unsigned             tag;
    uint8_t              first_buf;     /* :1 */
    uint8_t              threads_added[1];  /* bit array */
};


sre_vm_thompson_thread_list_t *
    sre_vm_thompson_create_thread_list(sre_pool_t *pool, sre_uint_t size);

unsigned sre_vm_thompson_jit_get_threads_added_size(sre_program_t *prog);


#endif /* _SRE_VM_THOMPSON_H_INCLUDED_ */
