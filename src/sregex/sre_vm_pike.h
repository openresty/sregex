
/*
 * Copyright 2012 Yichun "agentzh" Zhang
 * Copyright 2007-2009 Russ Cox.  All Rights Reserved.
 * Use of this source code is governed by a BSD-style
 * license that can be found in the LICENSE file.
 */


#ifndef _SRE_VM_PIKE_H_INCLUDED_
#define _SRE_VM_PIKE_H_INCLUDED_


#include <sregex/sre_core.h>
#include <sregex/sre_vm_bytecode.h>


struct sre_vm_pike_ctx_s;
typedef struct sre_vm_pike_ctx_s  sre_vm_pike_ctx_t;


sre_vm_pike_ctx_t *sre_vm_pike_init(sre_pool_t *pool, sre_program_t *prog,
    int *ovector, unsigned ovecsize);

int sre_vm_pike_exec(sre_vm_pike_ctx_t *ctx, u_char *input, size_t len,
    unsigned eof);

void sre_vm_pike_finalize(sre_vm_pike_ctx_t *ctx);


#endif /* _SRE_VM_PIKE_H_INCLUDED_ */
