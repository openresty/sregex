
/*
 * Copyright 2012 Yichun "agentzh" Zhang
 * Use of this source code is governed by a BSD-style
 * license that can be found in the LICENSE file.
 */


#ifndef DDEBUG
#define DDEBUG 0
#endif
#include <sregex/ddebug.h>


#include <dynasm/dasm_proto.h>
#include <dynasm/dasm_x86.h>

#include <sregex/sre_vm_thompson.h>

#if (SRE_TARGET == SRE_ARCH_X64)
#include <sregex/sre_vm_thompson_x64.h>
#endif

#include <sregex/sre_capture.h>
#include <sregex/sre_vm_bytecode.h>
#if (SRE_TARGET != SRE_ARCH_UNKNOWN)
#include <sys/mman.h>
#include <stdio.h>
#endif


struct sre_vm_thompson_code_s {
    size_t          size;

    sre_vm_thompson_exec_pt     handler;
};


SRE_API sre_int_t
sre_vm_thompson_jit_compile(sre_pool_t *pool, sre_program_t *prog,
    sre_vm_thompson_code_t **pcode)
{
#if (SRE_TARGET != SRE_ARCH_X64)
    return SRE_DECLINED;
#else
    int              status;
    size_t           codesz;
    size_t           size;
    unsigned char   *mem;
    dasm_State      *dasm;
    void           **glob;
    unsigned         nglobs = SRE_VM_THOMPSON_GLOB__MAX;

    sre_vm_thompson_code_t      *code;

    glob = sre_pcalloc(pool, nglobs * sizeof(void *));
    if (glob == NULL) {
        return SRE_ERROR;
    }

    dasm_init(&dasm, 1);
    dasm_setupglobal(&dasm, glob, nglobs);
    dasm_setup(&dasm, sre_vm_thompson_jit_actions);

    dd("thread size: %d", (int) sizeof(sre_vm_thompson_thread_t));

    if (sre_vm_thompson_jit_do_compile(&dasm, pool, prog) != SRE_OK) {
        dasm_free(&dasm);
        return SRE_ERROR;
    }

    status = dasm_link(&dasm, &codesz);
    if (status != DASM_S_OK) {
        dasm_free(&dasm);
        return SRE_ERROR;
    }

    size = codesz + sizeof(sre_vm_thompson_code_t);

    dd("size: %d, codesiz: %d", (int) size, (int) codesz);

    mem = mmap(NULL, size, PROT_READ|PROT_WRITE, MAP_ANON|MAP_PRIVATE, -1, 0);
    if (mem == MAP_FAILED) {
        perror("mmap");
        dasm_free(&dasm);
        return SRE_ERROR;
    }

    code = (sre_vm_thompson_code_t *) mem;

    code->size = size;
    code->handler = (sre_vm_thompson_exec_pt)
        (mem + sizeof(sre_vm_thompson_code_t));

    *pcode = code;

    dasm_encode(&dasm, code->handler);

#if (DDEBUG)
    {
        int              i;
        int              len;
        FILE            *f;
        const char      *gl;

        /*
         * write generated machine code to a temporary file.
         * wiew with objdump or ndisasm
         */
        f = fopen("/tmp/thompson-jit.bin", "wb");
        fwrite(code->handler, codesz, 1, f);
        fclose(f);

        f = fopen("/tmp/thompson-jit.txt", "w");
        fprintf(f, "code section: start=%p len=%lu\n", code->handler,
                (unsigned long) codesz);

        fprintf(f, "global names:\n");

        for (i = 0; i < nglobs; i++) {
            gl = sre_vm_thompson_jit_global_names[i];
            len = (int) strlen(gl);
            if (!glob[i]) {
                continue;
            }
            /* Skip the _Z symbols. */
            if (!(len >= 2 && gl[len-2] == '_' && gl[len-1] == 'Z')) {
                fprintf(f, "  %s => %p\n", gl, glob[i]);
            }
        }

        fprintf(f, "\npc labels:\n");
        for (i = 0; i < dasm->pcsize; i++) {
            int32_t ofs = dasm_getpclabel(&dasm, i);
            if (ofs >= 0) {
                fprintf(f, "  %d => %ld\n", i, (long) ofs);
            }
        }

        fclose(f);
    }
#endif

    dasm_free(&dasm);

    if (mprotect(mem, size, PROT_EXEC | PROT_READ) != 0) {
        (void) munmap(code, code->size);
        return SRE_ERROR;
    }

    dd("code start addr: %p", code->handler);

    return SRE_OK;
#endif /* SRE_TARGET == SRE_ARCH_X64 */
}


SRE_API sre_int_t
sre_vm_thompson_jit_free(sre_vm_thompson_code_t *code)
{
#if (SRE_TARGET != SRE_ARCH_UNKNOWN)
    if (munmap(code, code->size) != 0) {
        return SRE_ERROR;
    }
#endif
    return SRE_OK;
}


SRE_API sre_vm_thompson_exec_pt
sre_vm_thompson_jit_get_handler(sre_vm_thompson_code_t *code)
{
    if (code == NULL) {
        return NULL;
    }

    return code->handler;
}


SRE_API sre_vm_thompson_ctx_t *
sre_vm_thompson_jit_create_ctx(sre_pool_t *pool, sre_program_t *prog)
{
    sre_uint_t                       size, len;
    sre_vm_thompson_ctx_t           *ctx;
    sre_vm_thompson_thread_list_t   *clist, *nlist;

    size = sre_vm_thompson_jit_get_threads_added_size(prog);

    dd("threads_added size: %d", (int) size);

    ctx = sre_palloc(pool, sizeof(sre_vm_thompson_ctx_t) - 1 + size);
    if (ctx == NULL) {
        return NULL;
    }

    dd("ctx->threads_added: %x",
       (int) offsetof(sre_vm_thompson_ctx_t, threads_added));

    ctx->pool = pool;
    ctx->program = prog;

    len = prog->uniq_threads;

    clist = sre_vm_thompson_create_thread_list(pool, len);
    if (clist == NULL) {
        return NULL;
    }

    ctx->current_threads = clist;

    nlist = sre_vm_thompson_create_thread_list(pool, len);
    if (nlist == NULL) {
        return NULL;
    }

    ctx->next_threads = nlist;

    ctx->tag = prog->tag + 1;
    ctx->first_buf = 1;

    return ctx;
}


unsigned
sre_vm_thompson_jit_get_threads_added_size(sre_program_t *prog)
{
#if (SRE_TARGET == SRE_ARCH_X64)

#if 1
    if (prog->dup_threads <= 64) {
        return 0;
    }
#endif

    return sre_align(prog->dup_threads, 64) / 8;
#else
    return 0;
#endif
}
