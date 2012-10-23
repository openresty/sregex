
/*
 * Copyright 2012 Yichun "agentzh" Zhang
 * Copyright 2007-2009 Russ Cox.  All Rights Reserved.
 * Use of this source code is governed by a BSD-style
 * license that can be found in the LICENSE file.
 */


#include "sre_vm_bytecode.h"


void
sre_program_dump(sre_program_t *prog)
{
    sre_instruction_t      *pc, *start, *end;

    start = prog->start;
    end = prog->start + prog->len;

    for (pc = start; pc < end; pc++) {

        switch (pc->opcode) {
        case SRE_OPCODE_SPLIT:
            printf("%2d. split %d, %d\n", (int) (pc - start),
                   (int) (pc->x - start), (int) (pc->y - start));
            break;

        case SRE_OPCODE_JMP:
            printf("%2d. jmp %d\n", (int) (pc - start), (int) (pc->x - start));
            break;

        case SRE_OPCODE_CHAR:
            printf("%2d. char %c\n", (int) (pc - start), pc->v.ch);
            break;

        case SRE_OPCODE_ANY:
            printf("%2d. any\n", (int) (pc - start));
            break;

        case SRE_OPCODE_MATCH:
            printf("%2d. match\n", (int) (pc - start));
            break;

        case SRE_OPCODE_SAVE:
            printf("%2d. save %d\n", (int) (pc - start), pc->v.group);
            break;

        default:
            printf("%2d. unknown\n", (int) (pc - start));
            break;
        }
    }
}

