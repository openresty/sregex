
/*
 * Copyright 2012 Yichun "agentzh" Zhang
 * Copyright 2007-2009 Russ Cox.  All Rights Reserved.
 * Use of this source code is governed by a BSD-style
 * license that can be found in the LICENSE file.
 */


#include <sre_regex_parser.h>
#include <sre_regex_compiler.h>
#include <sre_vm_thompson.h>
#include <sre_vm_pike.h>


static void usage(void);


int
main(int argc, char **argv)
{
    int                  i, j;
    sre_pool_t          *pool;
    sre_regex_t         *re;
    sre_program_t       *prog;
    unsigned             ncaps;
    int                 *ovector;
    unsigned             ovecsize;

    if (argc < 2) {
        usage();
    }

    pool = sre_create_pool(4096);
    if (pool == NULL) {
        return 2;
    }

    re = sre_regex_parse(pool, (u_char *) argv[1], &ncaps);
    if (re == NULL) {
        return 2;
    }

    sre_regex_dump(re);
    printf("\n");

    printf("captures: %d\n", ncaps);

    prog = sre_regex_compile(pool, re);
    if (prog == NULL) {
        return 2;
    }

    sre_program_dump(prog);

    ovecsize = 2 * (ncaps + 1) * sizeof(int);
    ovector = sre_palloc(pool, ovecsize);
    if (ovector == NULL) {
        return 2;
    }

    for (i = 2; i < argc; i++) {
        printf("#%d %s\n", i - 1, argv[i]);

        printf("thompson ");

        if (sre_vm_thompson_exec(pool, prog, (u_char *) argv[i]) == SRE_OK) {
            printf("match\n");

        } else {
            printf("-no match-\n");
        }

        printf("pike ");

        sre_program_reset(prog);

        if (sre_vm_pike_exec(pool, prog, (u_char *) argv[i], ovector, ovecsize)
            == SRE_OK)
        {
            printf("match\n");

            for (j = 0; j < 2 * (ncaps + 1); j += 2) {
                printf(" (%d, %d)", ovector[j], ovector[j + 1]);
            }

        } else {
            printf("-no match-\n");
        }
    }

    sre_destroy_pool(pool);

    return 0;
}


static void
usage(void)
{
    fprintf(stderr, "usage: re regexp string...\n");
    exit(2);
}

