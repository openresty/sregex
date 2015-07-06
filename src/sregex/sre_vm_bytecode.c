
/*
 * Copyright 2012 Yichun "agentzh" Zhang
 * Copyright 2007-2009 Russ Cox.  All Rights Reserved.
 * Use of this source code is governed by a BSD-style
 * license that can be found in the LICENSE file.
 */


#include <sregex/sre_vm_bytecode.h>
#include <stdio.h>


SRE_API void
sre_program_dump(sre_program_t *prog)
{
    sre_instruction_t      *pc, *start, *end;

    start = prog->start;
    end = prog->start + prog->len;

    for (pc = start; pc < end; pc++) {
        sre_dump_instruction(stdout, pc, start);
        printf("\n");
    }
}


void
sre_dump_instruction(FILE *f, sre_instruction_t *pc,
    sre_instruction_t *start)
{
    sre_uint_t              i;
    sre_vm_range_t         *range;

    switch (pc->opcode) {
    case SRE_OPCODE_SPLIT:
        fprintf(f, "%2d. split %d, %d", (int) (pc - start),
               (int) (pc->x - start), (int) (pc->y - start));
        break;

    case SRE_OPCODE_JMP:
        fprintf(f, "%2d. jmp %d", (int) (pc - start), (int) (pc->x - start));
        break;

    case SRE_OPCODE_CHAR:
        fprintf(f, "%2d. char %d", (int) (pc - start), (int) pc->v.ch);
        break;

    case SRE_OPCODE_IN:
        fprintf(f, "%2d. in", (int) (pc - start));

        for (i = 0; i < pc->v.ranges->count; i++) {
            range = &pc->v.ranges->head[i];
            if (i > 0) {
                fputc(',', f);
            }
            fprintf(f, " %d-%d", range->from, range->to);
        }

        break;

    case SRE_OPCODE_NOTIN:
        fprintf(f, "%2d. notin", (int) (pc - start));

        for (i = 0; i < pc->v.ranges->count; i++) {
            range = &pc->v.ranges->head[i];
            if (i > 0) {
                fputc(',', f);
            }
            fprintf(f, " %d-%d", range->from, range->to);
        }

        break;

    case SRE_OPCODE_ANY:
        fprintf(f, "%2d. any", (int) (pc - start));
        break;

    case SRE_OPCODE_MATCH:
        fprintf(f, "%2d. match", (int) (pc - start));
        break;

    case SRE_OPCODE_SAVE:
        fprintf(f, "%2d. save %d", (int) (pc - start),
                (int) pc->v.group);
        break;

    case SRE_OPCODE_ASSERT:
        fprintf(f, "%2d. assert ", (int) (pc - start));

        switch (pc->v.assertion) {
        case SRE_REGEX_ASSERT_BIG_A:
            fprintf(f, "\\A");
            break;

        case SRE_REGEX_ASSERT_CARET:
            fprintf(f, "^");
            break;

        case SRE_REGEX_ASSERT_SMALL_Z:
            fprintf(f, "\\z");
            break;

        case SRE_REGEX_ASSERT_BIG_B:
            fprintf(f, "\\B");
            break;

        case SRE_REGEX_ASSERT_SMALL_B:
            fprintf(f, "\\b");
            break;

        case SRE_REGEX_ASSERT_DOLLAR:
            fprintf(f, "$");
            break;

        default:
            fprintf(f, "?");
            break;
        }

        break;

    default:
        fprintf(f, "%2d. unknown", (int) (pc - start));
        break;
    }
}
