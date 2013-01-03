
/*
 * Copyright 2012 Yichun "agentzh" Zhang
 * Copyright 2007-2009 Russ Cox.  All Rights Reserved.
 * Use of this source code is governed by a BSD-style
 * license that can be found in the LICENSE file.
 */


#include <sregex/sre_vm_bytecode.h>
#include <stdio.h>


void
sre_program_dump(sre_program_t *prog)
{
    sre_uint_t              i;
    sre_vm_range_t         *range;
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
            printf("%2d. char %d\n", (int) (pc - start), (int) pc->v.ch);
            break;

        case SRE_OPCODE_IN:
            printf("%2d. in", (int) (pc - start));

            for (i = 0; i < pc->v.ranges->count; i++) {
                range = &pc->v.ranges->head[i];
                printf(" %d-%d", range->from, range->to);
            }

            printf("\n");
            break;

        case SRE_OPCODE_NOTIN:
            printf("%2d. notin", (int) (pc - start));

            for (i = 0; i < pc->v.ranges->count; i++) {
                range = &pc->v.ranges->head[i];
                printf(" %d-%d", range->from, range->to);
            }

            printf("\n");
            break;

        case SRE_OPCODE_ANY:
            printf("%2d. any\n", (int) (pc - start));
            break;

        case SRE_OPCODE_MATCH:
            printf("%2d. match\n", (int) (pc - start));
            break;

        case SRE_OPCODE_SAVE:
            printf("%2d. save %d\n", (int) (pc - start), (int) pc->v.group);
            break;

        case SRE_OPCODE_ASSERT:
            printf("%2d. assert ", (int) (pc - start));

            switch (pc->v.assertion_type) {
            case SRE_REGEX_ASSERTION_BIG_A:
                printf("\\A");
                break;

            case SRE_REGEX_ASSERTION_CARET:
                printf("^");
                break;

            case SRE_REGEX_ASSERTION_SMALL_Z:
                printf("\\z");
                break;

            case SRE_REGEX_ASSERTION_BIG_B:
                printf("\\B");
                break;

            case SRE_REGEX_ASSERTION_SMALL_B:
                printf("\\b");
                break;

            case SRE_REGEX_ASSERTION_DOLLAR:
                printf("$");
                break;

            default:
                printf("?");
                break;
            }

            printf("\n");
            break;

        default:
            printf("%2d. unknown\n", (int) (pc - start));
            break;
        }
    }
}

