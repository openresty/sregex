/*
** This file has been pre-processed with DynASM.
** http://luajit.org/dynasm.html
** DynASM version 1.3.0, DynASM x64 version 1.3.0
** DO NOT EDIT! The original file is in "src/sregex/sre_vm_thompson_x64.dasc".
*/

#if DASM_VERSION != 10300
#error "Version mismatch between DynASM and included encoding engine"
#endif

# 1 "src/sregex/sre_vm_thompson_x64.dasc"

/*
 * Copyright 2012 Yichun "agentzh" Zhang
 * Use of this source code is governed by a BSD-style
 * license that can be found in the LICENSE file.
 */


//|.arch x64
//|.actionlist sre_vm_thompson_jit_actions
static const unsigned char sre_vm_thompson_jit_actions[703] = {
  249,255,132,252,255,15,133,244,247,255,132,252,255,15,133,244,247,65,128,
  252,251,235,15,133,244,247,255,65,128,252,251,235,15,132,244,248,255,65,128,
  252,251,235,15,130,244,249,255,252,233,244,248,255,65,128,252,251,235,15,
  134,244,248,255,248,3,255,252,233,244,247,248,2,255,65,128,252,251,235,15,
  132,244,247,255,65,128,252,251,235,15,130,244,248,255,252,233,244,247,255,
  65,128,252,251,235,15,134,244,247,255,73,105,198,239,77,141,132,253,7,233,
  255,65,128,252,251,235,15,133,244,255,255,48,192,255,132,252,255,15,133,244,
  248,255,65,128,252,251,235,15,130,244,248,65,128,252,251,235,15,134,244,249,
  65,128,252,251,235,15,130,244,248,65,128,252,251,235,15,134,244,249,65,128,
  252,251,235,15,130,244,248,65,128,252,251,235,15,134,244,249,65,128,252,251,
  235,15,132,244,249,248,2,255,48,192,252,233,244,250,248,3,176,1,248,4,255,
  72,139,143,233,255,72,15,186,252,233,235,15,130,244,248,255,72,137,143,233,
  255,65,136,128,233,255,72,141,5,244,10,73,137,128,233,255,72,141,5,245,73,
  137,128,233,255,72,49,192,73,137,128,233,255,73,131,198,1,255,73,129,192,
  239,255,184,1,0,0,0,195,255,248,9,255,248,1,49,192,195,255,65,86,65,87,65,
  80,65,85,82,65,84,65,82,85,65,81,83,65,83,81,133,201,15,132,244,247,179,1,
  252,233,244,248,248,1,48,219,248,2,76,139,151,233,77,139,178,233,48,252,255,
  138,135,233,132,192,15,132,244,11,248,12,198,135,233,0,77,137,215,77,49,252,
  237,232,245,133,192,15,132,244,11,72,49,192,252,233,244,13,248,11,255,72,
  1,252,242,76,139,191,233,73,137,252,244,252,233,244,14,248,15,73,131,196,
  1,248,14,73,57,212,15,132,244,16,69,138,28,36,252,233,244,17,248,16,132,219,
  15,132,244,18,183,1,248,17,77,133,252,246,15,132,244,19,255,76,141,135,233,
  72,49,192,72,199,193,237,248,1,73,137,0,73,131,192,8,72,252,255,201,15,133,
  244,1,255,72,49,201,255,73,105,198,239,77,141,140,253,2,233,73,141,170,233,
  77,49,252,246,252,233,244,20,248,21,72,129,197,239,248,20,76,57,205,15,132,
  244,22,255,72,139,133,233,72,133,192,15,132,244,247,252,255,208,133,192,15,
  132,244,21,248,1,255,252,255,149,233,133,192,15,132,244,21,72,49,192,252,
  233,244,13,248,22,76,137,208,77,137,252,250,73,137,199,132,252,255,15,132,
  244,15,248,19,132,219,15,132,244,18,72,199,192,237,252,233,244,13,248,18,
  72,199,192,237,248,13,76,137,151,233,77,137,178,233,76,137,191,233,255,77,
  49,252,246,77,137,183,233,89,65,91,91,65,89,93,65,90,65,92,90,65,93,65,88,
  65,95,65,94,195,255,248,10,184,1,0,0,0,195,255,132,252,255,15,132,244,247,
  255,65,128,252,251,235,15,133,244,247,248,2,255,138,165,233,255,48,192,252,
  233,244,250,248,3,176,1,248,4,48,224,255,184,1,0,0,0,195,248,1,49,192,195,
  255
};

# 11 "src/sregex/sre_vm_thompson_x64.dasc"

//|.globals SRE_VM_THOMPSON_GLOB_
enum {
  SRE_VM_THOMPSON_GLOB_match,
  SRE_VM_THOMPSON_GLOB_not_first_buf,
  SRE_VM_THOMPSON_GLOB_first_buf,
  SRE_VM_THOMPSON_GLOB_return,
  SRE_VM_THOMPSON_GLOB_sp_loop_start,
  SRE_VM_THOMPSON_GLOB_sp_loop_next,
  SRE_VM_THOMPSON_GLOB_buf_consumed,
  SRE_VM_THOMPSON_GLOB_run_cur_threads,
  SRE_VM_THOMPSON_GLOB_again,
  SRE_VM_THOMPSON_GLOB_done,
  SRE_VM_THOMPSON_GLOB_run_thread,
  SRE_VM_THOMPSON_GLOB_run_next_thread,
  SRE_VM_THOMPSON_GLOB_run_threads_done,
  SRE_VM_THOMPSON_GLOB__MAX
};
# 13 "src/sregex/sre_vm_thompson_x64.dasc"

#if (DDEBUG)
//|.globalnames sre_vm_thompson_jit_global_names
static const char *const sre_vm_thompson_jit_global_names[] = {
  "match",
  "not_first_buf",
  "first_buf",
  "return",
  "sp_loop_start",
  "sp_loop_next",
  "buf_consumed",
  "run_cur_threads",
  "again",
  "done",
  "run_thread",
  "run_next_thread",
  "run_threads_done",
  (const char *)0
};
# 16 "src/sregex/sre_vm_thompson_x64.dasc"
#endif

/* thread count */
//|.define TC,    r14  // callee-save

/* seen word */
//|.define SW,    r13  // callee-save

/* string pointer */
//|.define SP,    r12  // callee-save

//|.define LAST,  rdx  // overriding 3rd arg
//|.define INPUT, rsi  // 2nd arg
//|.define EOF,   bl   // 4th arg

/* seen last byte */
//|.define LB,    bh

/* current input string byte */
//|.define C,     r11b

/* the position after the last thread */
//|.define LT,    r9

/* recording threads added */
//|.define ADDED, rcx

//|.type CTX, sre_vm_thompson_ctx_t,          rdi  // 1st arg
#define Dt1(_V) (int)(ptrdiff_t)&(((sre_vm_thompson_ctx_t *)0)_V)
# 44 "src/sregex/sre_vm_thompson_x64.dasc"
//|.type TL,  sre_vm_thompson_thread_list_t,  r15  // callee-save
#define Dt2(_V) (int)(ptrdiff_t)&(((sre_vm_thompson_thread_list_t *)0)_V)
# 45 "src/sregex/sre_vm_thompson_x64.dasc"
//|.type T,   sre_vm_thompson_thread_t,       r8   // callee-save
#define Dt3(_V) (int)(ptrdiff_t)&(((sre_vm_thompson_thread_t *)0)_V)
# 46 "src/sregex/sre_vm_thompson_x64.dasc"
//|.type CT,  sre_vm_thompson_thread_t,       rbp  // callee-save
#define Dt4(_V) (int)(ptrdiff_t)&(((sre_vm_thompson_thread_t *)0)_V)
# 47 "src/sregex/sre_vm_thompson_x64.dasc"

/* current thread list */
//|.type CTL, sre_vm_thompson_thread_list_t,  r10  // callee-save
#define Dt5(_V) (int)(ptrdiff_t)&(((sre_vm_thompson_thread_list_t *)0)_V)
# 50 "src/sregex/sre_vm_thompson_x64.dasc"

//|.macro addThreadWithoutCheck, target
//|
//||if (asserts & SRE_REGEX_ASSERT_WORD_BOUNDARY) {
//|    mov T->seen_word, al
//||}
//|
//|  lea rax, [target]
//|  mov T->pc, rax
//|
//||if (jit->program->lookahead_asserts) {
//||  if (asserts) {
//|
//|     lea rax, [=>(jit->program->len + asserts - 1)]
//|     mov T->asserts_handler, rax
//|
//||  } else {
//|     xor rax, rax
//|     mov T->asserts_handler, rax
//||  }
//||}
//|
//|  add TC, 1
//|
//||if (n != path->nthreads) {
//|    add T, #T
//||}
//|
//|.endmacro


//|.macro addThreadWithCheck, target
//|
//||if (jit->threads_added_in_memory) {
//||  if (tid / 64 != prev_word) {
//||    prev_word = tid / 64;
//|     mov ADDED, CTX->threads_added[(tid / 64)]
//||  }
//|
//||  bofs = tid % 64;
//|
//||} else {
//||  bofs = tid;
//||}
//|
//|  bts ADDED, (bofs)  // load CF with the bit and set the bit
//|  jb >2  // jump if CF = 1
//|
//||if (jit->threads_added_in_memory) {
//|    mov CTX->threads_added[(tid / 64)], ADDED
//||}
//|
//||if (asserts & SRE_REGEX_ASSERT_WORD_BOUNDARY) {
//|    mov T->seen_word, al
//||}
//|
//|  lea rax, [target]
//|  mov T->pc, rax
//|
//||if (jit->program->lookahead_asserts) {
//||  if (asserts) {
//|     lea rax, [=>(jit->program->len + asserts - 1)]
//|     mov T->asserts_handler, rax
//|
//||  } else {
//|     xor rax, rax
//|     mov T->asserts_handler, rax
//||  }
//||}
//|
//|  add TC, 1
//|
//||if (n != path->nthreads) {
//|    add T, #T
//||}
//|
//|2:
//|
//|.endmacro


//|.macro testWordChar
//||if (!char_always_valid) {
//|   test LB, LB
//|   jnz >2
//||}
//|  cmp C, byte '0'
//|  jb >2
//|  cmp C, byte '9'
//|  jbe >3
//|  cmp C, byte 'A'
//|  jb >2
//|  cmp C, byte 'Z'
//|  jbe >3
//|  cmp C, byte 'a'
//|  jb >2
//|  cmp C, byte 'z'
//|  jbe >3
//|  cmp C, byte '_'
//|  je >3
//|2:
//|  // not word
//|  xor al, al
//|  jmp >4
//|3:
//|  // word
//|  mov al, 1
//|4:
//|.endmacro


/* This affects the "|" DynASM lines. */
#define Dst  dasm


#include <sregex/sre_core.h>
#include <sregex/sre_regex.h>
#include <sregex/sre_palloc.h>
#include <sregex/sre_vm_thompson.h>
#include <stdio.h>


typedef struct sre_vm_thompson_path_s  sre_vm_thompson_path_t;

typedef struct {
    sre_pool_t      *pool;
    sre_program_t   *program;
    dasm_State     **dasm;
    unsigned         tag;
    unsigned         thread_index_factor;

    uint8_t         *bc_accessed;  /* TODO: use a sparse or bit array here */
    int             *dup_thread_ids;  /* TODO: use a sparse array here */
    unsigned         threads_added_in_memory;  /* 1: use ctx->threads_added;
                                                  0: use the CPU register
                                                     ADDED only */

    sre_vm_thompson_path_t  *path;
} sre_vm_thompson_jit_t;


typedef struct sre_vm_thompson_state_s  sre_vm_thompson_state_t;

struct sre_vm_thompson_state_s {
    unsigned                     asserts;
    unsigned                     thread_index;
    unsigned                     is_thread;
    sre_instruction_t           *bc;
    sre_vm_thompson_state_t     *next;
};


struct sre_vm_thompson_path_s {
    unsigned                 nthreads;
    sre_instruction_t       *from;
    sre_vm_thompson_state_t *to;
    sre_vm_thompson_path_t  *next;
};


static sre_int_t sre_vm_thompson_jit_compile_path(sre_vm_thompson_jit_t *jit,
    sre_vm_thompson_path_t *path);
static sre_int_t sre_vm_thompson_jit_prologue(sre_vm_thompson_jit_t *jit);
static sre_int_t sre_vm_thompson_jit_get_next_states(sre_vm_thompson_jit_t *jit,
    sre_instruction_t *pc, sre_vm_thompson_state_t ***plast_state,
    unsigned *nthreads, unsigned asserts);
static sre_int_t sre_vm_thompson_jit_epilogue(sre_vm_thompson_jit_t *jit);
static sre_int_t sre_vm_thompson_jit_build_paths(sre_vm_thompson_jit_t *jit,
    sre_instruction_t *pc, sre_vm_thompson_path_t ***plast_path);
static unsigned sre_vm_thompson_jit_gen_thread_index(sre_vm_thompson_jit_t *jit,
     sre_instruction_t *pc, unsigned asserts);


SRE_NOAPI sre_int_t
sre_vm_thompson_jit_do_compile(dasm_State **dasm, sre_pool_t *pool,
    sre_program_t *prog)
{
    unsigned                        i, n, count;
    sre_vm_thompson_jit_t           jit;
    sre_vm_thompson_path_t         *path, **last_path;

    jit.pool = pool;
    jit.program = prog;
    jit.dasm = dasm;

    jit.bc_accessed = sre_pcalloc(pool, prog->len);
    if (jit.bc_accessed == NULL) {
        return SRE_ERROR;
    }

    jit.thread_index_factor = (SRE_REGEX_ASSERT_LOOKAHEAD + 1);

    dd("prog len: %d", (int) prog->len);
    dd("thread index factor: %d", (int) jit.thread_index_factor);

    count = prog->len * jit.thread_index_factor;
    dd("thread index count: %d", (int) count);

    jit.dup_thread_ids = sre_pcalloc(pool, count * sizeof(int));
    if (jit.dup_thread_ids == NULL) {
        return SRE_ERROR;
    }

    jit.path = NULL;
    last_path = &jit.path;

    if (sre_vm_thompson_jit_build_paths(&jit, prog->start, &last_path)
        != SRE_OK)
    {
        return SRE_ERROR;
    }

    dd("first path: %p, pc: %d", jit.path,
       (int) (jit.path->from - jit.program->start));

    n = 0;
    for (i = 0; i < count; i++) {
        if (jit.dup_thread_ids[i] > 0) {
            dd("found unique thread at pc %d, ref count: %d",
               (int) (i / jit.thread_index_factor), (int) jit.dup_thread_ids[i]);

            prog->uniq_threads++;

            if (jit.dup_thread_ids[i] > 1) {
                dd("found duplicatable thread at pc %d, ref count: %d",
                   (int) (i / jit.thread_index_factor), (int) jit.dup_thread_ids[i]);

                jit.dup_thread_ids[i] = n++;
                continue;
            }
        }

        jit.dup_thread_ids[i] = -1;
    }

    prog->dup_threads = n;

    dd("unique threads: %u, duplicatable threads: %u",
       prog->uniq_threads, prog->dup_threads);

    jit.threads_added_in_memory = (prog->dup_threads > 64);

#if 0
    jit.threads_added_in_memory = 1;
#endif

    n = prog->len + prog->lookahead_asserts;

    dd("growing pc label to %d, prog len: %d", n, (int) prog->len);
    dasm_growpc(dasm, n);

    if (sre_vm_thompson_jit_prologue(&jit) != SRE_OK) {
        return SRE_ERROR;
    }

    for (path = jit.path; path; path = path->next) {

        dd("compiling path %p with pc %d", path,
           (int) (path->from - jit.program->start));

        if (sre_vm_thompson_jit_compile_path(&jit, path) != SRE_OK) {
            return SRE_ERROR;
        }
    }

    if (sre_vm_thompson_jit_epilogue(&jit) != SRE_OK) {
        return SRE_ERROR;
    }

    return SRE_OK;
}


static sre_int_t
sre_vm_thompson_jit_build_paths(sre_vm_thompson_jit_t *jit, sre_instruction_t *pc,
    sre_vm_thompson_path_t ***plast_path)
{
    sre_vm_thompson_path_t      *path;
    sre_vm_thompson_state_t     *state, **last_state;

    jit->bc_accessed[pc - jit->program->start] = 1;

    path = sre_pcalloc(jit->pool, sizeof(sre_vm_thompson_path_t));
    if (path == NULL) {
        return SRE_ERROR;
    }

    dd("build path from pc %d", (int) (pc - jit->program->start));

    path->from = pc;
    last_state = &path->to;
    jit->tag = jit->program->tag + 1;

    if (pc == jit->program->start) {
        if (sre_vm_thompson_jit_get_next_states(jit, pc, &last_state,
                                                &path->nthreads, 0)
            != SRE_OK)
        {
            jit->program->tag = jit->tag;
            return SRE_ERROR;
        }

    } else {
        if (pc + 1 >= jit->program->start + jit->program->len) {
            jit->program->tag = jit->tag;
            return SRE_ERROR;
        }

        if (sre_vm_thompson_jit_get_next_states(jit, pc + 1, &last_state,
                                                &path->nthreads, 0)
            != SRE_OK)
        {
            jit->program->tag = jit->tag;
            return SRE_ERROR;
        }
    }

    jit->program->tag = jit->tag;

    if (path->to == NULL) {
        return SRE_ERROR;
    }

    **plast_path = path;
    *plast_path = &path->next;

    for (state = path->to; state; state = state->next) {
        if (state->bc->opcode == SRE_OPCODE_MATCH) {
            continue;
        }

        if (jit->bc_accessed[state->bc - jit->program->start]) {
            continue;
        }

        if (sre_vm_thompson_jit_build_paths(jit, state->bc,
                                            plast_path)
            != SRE_OK)
        {
            return SRE_ERROR;
        }
    }

    return SRE_OK;
}


static sre_int_t
sre_vm_thompson_jit_compile_path(sre_vm_thompson_jit_t *jit,
    sre_vm_thompson_path_t *path)
{
    sre_char             c;
    unsigned             i, n, asserts, char_always_valid = 1;
    int                  tid, prev_word;
    unsigned             bofs;
    sre_int_t            ofs;
    dasm_State         **dasm;
    sre_vm_range_t      *range;
    sre_instruction_t   *bc, *pc;

    sre_vm_thompson_state_t          *state;

    dasm = jit->dasm;
    pc = path->from;
    ofs = pc - jit->program->start;

    if (dasm_getpclabel(dasm, ofs) >= 0) {
        dd("bc %d already compiled", (int) ofs);
        return SRE_ERROR;
    }

    dd("compiling path at pc %d", (int) (pc - jit->program->start));

    //|=>(ofs):
    dasm_put(Dst, 0, (ofs));
# 424 "src/sregex/sre_vm_thompson_x64.dasc"

    switch (pc->opcode) {
    case SRE_OPCODE_ANY:
        //|  test LB, LB
        //|  jnz >1
        dasm_put(Dst, 2);
# 429 "src/sregex/sre_vm_thompson_x64.dasc"

        break;

    case SRE_OPCODE_CHAR:
        c = pc->v.ch;

        //|  test LB, LB
        //|  jnz >1
        //|
        //|  cmp C, byte (c)
        //|  jne >1
        dasm_put(Dst, 10, (c));
# 440 "src/sregex/sre_vm_thompson_x64.dasc"

        break;

    case SRE_OPCODE_IN:
        //|  test LB, LB
        //|  jnz >1
        dasm_put(Dst, 2);
# 446 "src/sregex/sre_vm_thompson_x64.dasc"

        for (i = 0; i < pc->v.ranges->count; i++) {
            range = &pc->v.ranges->head[i];

            dd("compile opcode IN: [%d, %d] (%u)", (int) range->from,
               (int) range->to, (unsigned) i);

            if (range->from == range->to) {
                //|  cmp C, byte (range->from)
                //|  je >2
                dasm_put(Dst, 27, (range->from));
# 456 "src/sregex/sre_vm_thompson_x64.dasc"

            } else {
                if (range->from != 0x00) {
                    //|  cmp C, byte (range->from)
                    //|  jb >3
                    dasm_put(Dst, 37, (range->from));
# 461 "src/sregex/sre_vm_thompson_x64.dasc"
                }

                if (range->to == 0xff) {
                    //|  jmp >2
                    dasm_put(Dst, 47);
# 465 "src/sregex/sre_vm_thompson_x64.dasc"

                } else {
                    //|  cmp C, byte (range->to)
                    //|  jbe >2
                    dasm_put(Dst, 52, (range->to));
# 469 "src/sregex/sre_vm_thompson_x64.dasc"
                }

                //|3:
                dasm_put(Dst, 62);
# 472 "src/sregex/sre_vm_thompson_x64.dasc"
            }
        }

        //|  jmp >1
        //|2:
        dasm_put(Dst, 65);
# 477 "src/sregex/sre_vm_thompson_x64.dasc"

        break;

    case SRE_OPCODE_NOTIN:
        //|  test LB, LB
        //|  jnz >1
        dasm_put(Dst, 2);
# 483 "src/sregex/sre_vm_thompson_x64.dasc"

        for (i = 0; i < pc->v.ranges->count; i++) {
            range = &pc->v.ranges->head[i];

            dd("compile opcode IN: [%d, %d] (%u)", (int) range->from,
               (int) range->to, (unsigned) i);

            if (range->from == range->to) {
                //|  cmp C, byte (range->from)
                //|  je >1
                dasm_put(Dst, 72, (range->from));
# 493 "src/sregex/sre_vm_thompson_x64.dasc"

            } else {
                if (range->from != 0x00) {
                    //|  cmp C, byte (range->from)
                    //|  jb >2
                    dasm_put(Dst, 82, (range->from));
# 498 "src/sregex/sre_vm_thompson_x64.dasc"
                }

                if (range->to == 0xff) {
                    //|  jmp >1
                    dasm_put(Dst, 92);
# 502 "src/sregex/sre_vm_thompson_x64.dasc"

                } else {
                    //|  cmp C, byte (range->to)
                    //|  jbe >1
                    dasm_put(Dst, 97, (range->to));
# 506 "src/sregex/sre_vm_thompson_x64.dasc"
                }

                if (range->from != 0x00) {
                    //|2:
                    dasm_put(Dst, 69);
# 510 "src/sregex/sre_vm_thompson_x64.dasc"
                }
            }
        }

        break;

    default:
        /* do nothing */
        break;
    }

    prev_word = -1;
    n = 0;
    for (state = path->to; state; state = state->next) {
        bc = state->bc;
        asserts = state->asserts;

        if (state->is_thread) {
            n++;

            if (n == 1) {
                //|  imul rax, TC, #T  // thread index offset
                //|  lea T, [TL + rax + offsetof(sre_vm_thompson_thread_list_t, threads)]
                dasm_put(Dst, 107, sizeof(sre_vm_thompson_thread_t), offsetof(sre_vm_thompson_thread_list_t, threads));
# 533 "src/sregex/sre_vm_thompson_x64.dasc"
            }
        }

        if (asserts) {
            if (asserts & SRE_REGEX_ASSERT_BIG_A) {
                asserts &= ~SRE_REGEX_ASSERT_BIG_A;

                if (pc != jit->program->start) {
                    /* assertion always does not hold */
                    continue;
                }

                /* assertion always holds when pc == jit->program->start */
            }

            if (asserts & SRE_REGEX_ASSERT_CARET) {
                asserts &= ~SRE_REGEX_ASSERT_CARET;

                /* assertion always holds when pc == jit->program->start */

                if (pc != jit->program->start) {
                    //|  cmp C, byte '\n'
                    //|  jne >9
                    dasm_put(Dst, 118, '\n');
# 556 "src/sregex/sre_vm_thompson_x64.dasc"
                }
            }

            if (asserts & SRE_REGEX_ASSERT_WORD_BOUNDARY) {
                if (pc == jit->program->start) {
                    //|  xor al, al
                    dasm_put(Dst, 128);
# 562 "src/sregex/sre_vm_thompson_x64.dasc"

                } else {
                    //|  testWordChar
                    if (!char_always_valid) {
                    dasm_put(Dst, 131);
                    }
                    dasm_put(Dst, 139, '0', '9', 'A', 'Z', 'a', 'z', '_');
                    dasm_put(Dst, 205);
# 565 "src/sregex/sre_vm_thompson_x64.dasc"
                }
            }
        }

        if (bc->opcode == SRE_OPCODE_MATCH) {

            dd("seen a match bc: %d, len: %d",
               (int) (bc - jit->program->start), (int) jit->program->len);

            if (asserts) {
                ofs = bc - jit->program->start;
                tid = jit->dup_thread_ids[state->thread_index];

                dd("compiling asserts for match: %d", asserts);

                if (tid >= 0 && pc != jit->program->start) {
                    //|  addThreadWithCheck ->match
                    if (jit->threads_added_in_memory) {
                      if (tid / 64 != prev_word) {
                        prev_word = tid / 64;
                    dasm_put(Dst, 218, Dt1(->threads_added[(tid / 64)]));
                      }
                      bofs = tid % 64;
                    } else {
                      bofs = tid;
                    }
                    dasm_put(Dst, 223, (bofs));
                    if (jit->threads_added_in_memory) {
                    dasm_put(Dst, 234, Dt1(->threads_added[(tid / 64)]));
                    }
                    if (asserts & SRE_REGEX_ASSERT_WORD_BOUNDARY) {
                    dasm_put(Dst, 239, Dt3(->seen_word));
                    }
                    dasm_put(Dst, 244, Dt3(->pc));
                    if (jit->program->lookahead_asserts) {
                      if (asserts) {
                    dasm_put(Dst, 254, (jit->program->len + asserts - 1), Dt3(->asserts_handler));
                      } else {
                    dasm_put(Dst, 263, Dt3(->asserts_handler));
                      }
                    }
                    dasm_put(Dst, 271);
                    if (n != path->nthreads) {
                    dasm_put(Dst, 276, sizeof(sre_vm_thompson_thread_t));
                    }
                    dasm_put(Dst, 69);
# 582 "src/sregex/sre_vm_thompson_x64.dasc"

                } else {
                    dd("seen a non thread entry match at bc %d", (int) ofs);

                    //|  addThreadWithoutCheck ->match
                    if (asserts & SRE_REGEX_ASSERT_WORD_BOUNDARY) {
                    dasm_put(Dst, 239, Dt3(->seen_word));
                    }
                    dasm_put(Dst, 244, Dt3(->pc));
                    if (jit->program->lookahead_asserts) {
                      if (asserts) {
                    dasm_put(Dst, 254, (jit->program->len + asserts - 1), Dt3(->asserts_handler));
                      } else {
                    dasm_put(Dst, 263, Dt3(->asserts_handler));
                      }
                    }
                    dasm_put(Dst, 271);
                    if (n != path->nthreads) {
                    dasm_put(Dst, 276, sizeof(sre_vm_thompson_thread_t));
                    }
# 587 "src/sregex/sre_vm_thompson_x64.dasc"
                }

            } else {
                //|  mov eax, 1
                //|  ret
                dasm_put(Dst, 281);
# 592 "src/sregex/sre_vm_thompson_x64.dasc"
            }

        } else {
            /* being bytecode ANY, CHAR, IN, or NOTIN */

            ofs = bc - jit->program->start;
            tid = jit->dup_thread_ids[state->thread_index];

            if (tid >= 0 && pc != jit->program->start) {
                dd("seen a thread entry bc at bc %d, id=%d", (int) ofs,
                   (int) tid);

                //|  addThreadWithCheck =>(ofs)
                if (jit->threads_added_in_memory) {
                  if (tid / 64 != prev_word) {
                    prev_word = tid / 64;
                dasm_put(Dst, 218, Dt1(->threads_added[(tid / 64)]));
                  }
                  bofs = tid % 64;
                } else {
                  bofs = tid;
                }
                dasm_put(Dst, 223, (bofs));
                if (jit->threads_added_in_memory) {
                dasm_put(Dst, 234, Dt1(->threads_added[(tid / 64)]));
                }
                if (asserts & SRE_REGEX_ASSERT_WORD_BOUNDARY) {
                dasm_put(Dst, 239, Dt3(->seen_word));
                }
                dasm_put(Dst, 254, (ofs), Dt3(->pc));
                if (jit->program->lookahead_asserts) {
                  if (asserts) {
                dasm_put(Dst, 254, (jit->program->len + asserts - 1), Dt3(->asserts_handler));
                  } else {
                dasm_put(Dst, 263, Dt3(->asserts_handler));
                  }
                }
                dasm_put(Dst, 271);
                if (n != path->nthreads) {
                dasm_put(Dst, 276, sizeof(sre_vm_thompson_thread_t));
                }
                dasm_put(Dst, 69);
# 605 "src/sregex/sre_vm_thompson_x64.dasc"

            } else {
                dd("seen a non thread entry bc at bc %d", (int) ofs);
                //|  addThreadWithoutCheck =>(ofs)
                if (asserts & SRE_REGEX_ASSERT_WORD_BOUNDARY) {
                dasm_put(Dst, 239, Dt3(->seen_word));
                }
                dasm_put(Dst, 254, (ofs), Dt3(->pc));
                if (jit->program->lookahead_asserts) {
                  if (asserts) {
                dasm_put(Dst, 254, (jit->program->len + asserts - 1), Dt3(->asserts_handler));
                  } else {
                dasm_put(Dst, 263, Dt3(->asserts_handler));
                  }
                }
                dasm_put(Dst, 271);
                if (n != path->nthreads) {
                dasm_put(Dst, 276, sizeof(sre_vm_thompson_thread_t));
                }
# 609 "src/sregex/sre_vm_thompson_x64.dasc"
            }
        }

        //|9:
        dasm_put(Dst, 288);
# 613 "src/sregex/sre_vm_thompson_x64.dasc"
    } /* for */

    //|1:
    //|  xor eax, eax
    //|  ret
    dasm_put(Dst, 291);
# 618 "src/sregex/sre_vm_thompson_x64.dasc"

    return SRE_OK;
}


static sre_int_t
sre_vm_thompson_jit_get_next_states(sre_vm_thompson_jit_t *jit,
    sre_instruction_t *pc, sre_vm_thompson_state_t ***plast_state,
    unsigned *nthreads, unsigned asserts)
{
    sre_vm_thompson_state_t     *state;

    if (pc->tag == jit->tag) {
        return SRE_OK;
    }

    pc->tag = jit->tag;

    switch (pc->opcode) {
    case SRE_OPCODE_SPLIT:
        if (sre_vm_thompson_jit_get_next_states(jit, pc->x, plast_state,
                                                nthreads, asserts)
            != SRE_OK)
        {
            return SRE_ERROR;
        }

        return sre_vm_thompson_jit_get_next_states(jit, pc->y, plast_state,
                                                   nthreads, asserts);

    case SRE_OPCODE_JMP:
        return sre_vm_thompson_jit_get_next_states(jit, pc->x, plast_state,
                                                   nthreads, asserts);

    case SRE_OPCODE_SAVE:
        if (++pc == jit->program->start + jit->program->len) {
            return SRE_OK;
        }

        return sre_vm_thompson_jit_get_next_states(jit, pc, plast_state,
                                                   nthreads, asserts);

    case SRE_OPCODE_MATCH:
        dd("seen match bc %d, asserts %d",
           (int) (pc - jit->program->start), (int) asserts);

        state = sre_pcalloc(jit->pool, sizeof(sre_vm_thompson_state_t));
        if (state == NULL) {
            return SRE_ERROR;
        }

        state->asserts = asserts;
        state->bc = pc;
        state->thread_index = sre_vm_thompson_jit_gen_thread_index(jit, pc,
                                                                   asserts);

        if (asserts & SRE_REGEX_ASSERT_LOOKAHEAD) {
            jit->dup_thread_ids[state->thread_index]++;

            state->is_thread = 1;
            (*nthreads)++;
        }

        **plast_state = state;
        *plast_state = &state->next;

        return SRE_OK;

    case SRE_OPCODE_ASSERT:
        dd("seen assert bc at %d", (int) (pc - jit->program->start));

        asserts |= pc->v.assertion;

        jit->program->lookahead_asserts |= (asserts & SRE_REGEX_ASSERT_LOOKAHEAD);

        if (++pc == jit->program->start + jit->program->len) {
            return SRE_OK;
        }

        return sre_vm_thompson_jit_get_next_states(jit, pc, plast_state,
                                                   nthreads, asserts);

    default:
        /* CHAR, ANY, IN, NOTIN */

        state = sre_pcalloc(jit->pool, sizeof(sre_vm_thompson_state_t));
        if (state == NULL) {
            return SRE_ERROR;
        }

        state->asserts = asserts;
        state->bc = pc;
        state->thread_index = sre_vm_thompson_jit_gen_thread_index(jit, pc,
                                                                   asserts);

        jit->dup_thread_ids[state->thread_index]++;
        state->is_thread = 1;

        **plast_state = state;
        *plast_state = &state->next;

        (*nthreads)++;

        dd("seen terminal bc: %d", (int) (pc - jit->program->start));
        return SRE_OK;
    }

    /* impossible to reach here */
}


static unsigned
sre_vm_thompson_jit_gen_thread_index(sre_vm_thompson_jit_t *jit,
     sre_instruction_t *pc, unsigned asserts)
{
    return (pc - jit->program->start) * jit->thread_index_factor
           + (asserts & SRE_REGEX_ASSERT_LOOKAHEAD);
}


static sre_int_t
sre_vm_thompson_jit_prologue(sre_vm_thompson_jit_t *jit)
{
    size_t       size;
    dasm_State **dasm;

    dasm = jit->dasm;

    //|  push TC; push TL; push T; push SW; push LAST; push SP;
    //|  push CTL; push CT; push LT; push rbx; push r11; push ADDED
    //|
    //|  // check the 4th arg, "eof"
    //|  test ecx, ecx
    //|  jz >1
    //|  mov EOF, 1
    //|  jmp >2
    //|
    //|1:
    //|  xor EOF, EOF
    //|
    //|2:
    //|  mov CTL, CTX->current_threads
    //|  mov TC, CTL->count
    //|  xor LB, LB
    //|
    //|  mov al, CTX->first_buf
    //|  test al, al
    //|  jz ->not_first_buf
    //|
    //|->first_buf:
    //|  mov byte CTX->first_buf, 0
    //|
    //|  mov TL, CTL
    //|  xor SW, SW
    //|  call =>0
    //|  test eax, eax
    //|  jz ->not_first_buf
    //|  xor rax, rax // (SRE_OK)
    //|  jmp ->return
    //|
    //|->not_first_buf:
    //|  add LAST, INPUT  // last = input + size
    dasm_put(Dst, 297, Dt1(->current_threads), Dt5(->count), Dt1(->first_buf), Dt1(->first_buf), 0);
# 780 "src/sregex/sre_vm_thompson_x64.dasc"
    //|  mov TL, CTX->next_threads
    //|  mov SP, INPUT
    //|
    //|  jmp ->sp_loop_start
    //|
    //|->sp_loop_next:
    //|  add SP, 1
    //|
    //|->sp_loop_start:
    //|  cmp SP, LAST
    //|  je ->buf_consumed
    //|
    //|  // sp != last
    //|  mov C, byte [SP]
    //|  jmp ->run_cur_threads
    //|
    //|->buf_consumed:
    //|  test EOF, EOF
    //|  jz ->again
    //|  mov LB, 1
    //|
    //|->run_cur_threads:
    //|  test TC, TC
    //|  jz ->done
    //|
    dasm_put(Dst, 386, Dt1(->next_threads));
# 805 "src/sregex/sre_vm_thompson_x64.dasc"

    if (jit->threads_added_in_memory) {
        size = sre_vm_thompson_jit_get_threads_added_size(jit->program);

        /* clear the CTX->threads_added bit array */

        //|  // rcx is for ADDED, and r8 is for T
        //|  lea r8, CTX->threads_added
        //|  xor rax, rax
        //|  mov rcx, (size / 8)
        //|1:
        //|  mov qword [r8], rax
        //|  add r8, 8
        //|  dec rcx
        //|  jnz <1
        dasm_put(Dst, 446, Dt1(->threads_added), (size / 8));
# 820 "src/sregex/sre_vm_thompson_x64.dasc"

    } else {
        //|  xor ADDED, ADDED
        dasm_put(Dst, 475);
# 823 "src/sregex/sre_vm_thompson_x64.dasc"
    }

    //|  imul rax, TC, #T  // thread index offset
    //|  lea LT, [CTL + rax + offsetof(sre_vm_thompson_thread_list_t, threads)]
    //|  lea CT, [CTL + offsetof(sre_vm_thompson_thread_list_t, threads)]
    //|  xor TC, TC
    //|  jmp ->run_thread
    //|
    //|->run_next_thread:
    //|  add CT, #T
    //|
    //|->run_thread:
    //|  cmp CT, LT
    //|  je ->run_threads_done
    //|
    dasm_put(Dst, 479, sizeof(sre_vm_thompson_thread_t), offsetof(sre_vm_thompson_thread_list_t, threads), offsetof(sre_vm_thompson_thread_list_t, threads), sizeof(sre_vm_thompson_thread_t));
# 838 "src/sregex/sre_vm_thompson_x64.dasc"

    if (jit->program->lookahead_asserts) {
        //|  mov rax, CT->asserts_handler
        //|  test rax, rax
        //|  jz >1
        //|  call rax
        //|  test eax, eax
        //|  jz ->run_next_thread
        //|
        //|1:
        dasm_put(Dst, 517, Dt4(->asserts_handler));
# 848 "src/sregex/sre_vm_thompson_x64.dasc"
    }

    //|  call aword CT->pc
    //|
    //|  test eax, eax
    //|  jz ->run_next_thread
    //|
    //|  // matched
    //|  xor rax, rax // (SRE_OK)
    //|  jmp ->return
    //|
    //|->run_threads_done:
    //|  mov rax, CTL
    //|  mov CTL, TL
    //|  mov TL, rax
    //|
    //|  test LB, LB
    //|  jz ->sp_loop_next
    //|
    //|->done:
    //|  test EOF, EOF
    //|  jz ->again
    //|  mov rax, (SRE_DECLINED)
    //|  jmp ->return
    //|
    //|->again:
    //|  mov rax, (SRE_AGAIN)
    //|
    //|->return:
    //|  mov CTX->current_threads, CTL
    //|  mov CTL->count, TC
    //|
    //|  mov CTX->next_threads, TL
    //|  xor TC, TC
    dasm_put(Dst, 540, Dt4(->pc), (SRE_DECLINED), (SRE_AGAIN), Dt1(->current_threads), Dt5(->count), Dt1(->next_threads));
# 882 "src/sregex/sre_vm_thompson_x64.dasc"
    //|  mov TL->count, TC
    //|
    //|  pop ADDED; pop r11; pop rbx; pop LT; pop CT; pop CTL;
    //|  pop SP; pop LAST; pop SW; pop T; pop TL; pop TC
    //|  ret
    dasm_put(Dst, 613, Dt2(->count));
# 887 "src/sregex/sre_vm_thompson_x64.dasc"

    return SRE_OK;
}


static sre_int_t
sre_vm_thompson_jit_epilogue(sre_vm_thompson_jit_t *jit)
{
    unsigned     flags, char_always_valid = 0;
    sre_uint_t   len;
    dasm_State **dasm;

    if (jit->program->lookahead_asserts) {

        dasm = jit->dasm;
        len = jit->program->len;

        //|->match:
        //|  mov eax, 1
        //|  ret
        dasm_put(Dst, 643);
# 907 "src/sregex/sre_vm_thompson_x64.dasc"

        for (flags = 1; flags <= SRE_REGEX_ASSERT_LOOKAHEAD; flags++) {

            if ((flags & jit->program->lookahead_asserts) != flags) {
                continue;
            }

            //|=>(len + flags - 1):
            dasm_put(Dst, 0, (len + flags - 1));
# 915 "src/sregex/sre_vm_thompson_x64.dasc"

            if (flags & SRE_REGEX_ASSERT_SMALL_Z) {
                //|  test LB, LB
                //|  jz >1
                dasm_put(Dst, 652);
# 919 "src/sregex/sre_vm_thompson_x64.dasc"
            }

            if (flags & SRE_REGEX_ASSERT_DOLLAR) {
                if (!(flags & SRE_REGEX_ASSERT_SMALL_Z)) {
                    //|  test LB, LB
                    //|  jnz >2
                    dasm_put(Dst, 131);
# 925 "src/sregex/sre_vm_thompson_x64.dasc"
                }

                //|  cmp C, '\n'
                //|  jne >1
                //|2:
                dasm_put(Dst, 660, '\n');
# 930 "src/sregex/sre_vm_thompson_x64.dasc"
            }

            if (flags & SRE_REGEX_ASSERT_WORD_BOUNDARY) {
                //|  mov ah, byte CT->seen_word
                //|  testWordChar
                dasm_put(Dst, 672, Dt4(->seen_word));
                if (!char_always_valid) {
                dasm_put(Dst, 131);
                }
                dasm_put(Dst, 139, '0', '9', 'A', 'Z', 'a', 'z', '_');
# 935 "src/sregex/sre_vm_thompson_x64.dasc"
                //|  xor al, ah
                dasm_put(Dst, 676);
# 936 "src/sregex/sre_vm_thompson_x64.dasc"

                if (flags & SRE_REGEX_ASSERT_SMALL_B) {
                    //|  jz >1
                    dasm_put(Dst, 77);
# 939 "src/sregex/sre_vm_thompson_x64.dasc"

                } else {
                    /* SRE_REGEX_ASSERT_BIG_B */
                    //|  jnz >1
                    dasm_put(Dst, 5);
# 943 "src/sregex/sre_vm_thompson_x64.dasc"
                }
            }

            //|  mov eax, 1
            //|  ret
            //|1:
            //|  xor eax, eax
            //|  ret
            dasm_put(Dst, 691);
# 951 "src/sregex/sre_vm_thompson_x64.dasc"
        }
    }

    return SRE_OK;
}
