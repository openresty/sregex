
/*
 * Copyright 2012 Yichun "agentzh" Zhang
 * Use of this source code is governed by a BSD-style
 * license that can be found in the LICENSE file.
 */


#include <regexp.h>
#include <assert.h>
#include <string.h>
#include <stdio.h>
#include <errno.h>
#include <time.h>


static void usage(int rc);
static void run_engines(Prog *prog, unsigned engine_types, unsigned ncaps,
    char *input);


enum {
    ENGINE_THOMPSON     = (1 << 0),
    ENGINE_PIKE         = (1 << 1)
};


int
main(int argc, char **argv)
{
    unsigned             engine_types = 0;
    unsigned             i;
    Regexp              *re;
    Prog                *prog;
    unsigned             ncaps;
    char                *input;
    FILE                *f;
    size_t               len;
    long                 rc;

    if (argc < 3) {
        usage(1);
    }

    for (i = 1; i < argc; i++) {
        if (argv[i][0] != '-') {
            break;
        }

        if (strncmp(argv[i], "--thompson", sizeof("--thompson") - 1) == 0) {
            engine_types |= ENGINE_THOMPSON;

        } else if (strncmp(argv[i], "--pike", sizeof("--pike") - 1)
                   == 0)
        {
            engine_types |= ENGINE_PIKE;

        } else {
            fprintf(stderr, "unknown option: %s\n", argv[i]);
            exit(1);
        }
    }

    if (engine_types == 0) {
        fprintf(stderr, "No engine specified.\n");
        exit(1);
    }

    if (argc - i != 2) {
        usage(1);
    }

    re = parse(argv[i++]);
    if (re == NULL) {
        fprintf(stderr, "failed to parse the regex.\n");
        return 2;
    }

    prog = compile(re);
    if (prog == NULL) {
        fprintf(stderr, "failed to compile the regex.\n");
        return 2;
    }

    errno = 0;

    f = fopen(argv[i], "rb");
    if (f == NULL) {
        perror("open file");
        return 1;
    }

    if (fseek(f, 0L, SEEK_END) != 0) {
        perror("seek to file end");
        return 1;
    }

    rc = ftell(f);
    if (rc == -1) {
        perror("get file offset by ftell");
        return 1;
    }

    len = (size_t) rc;

    if (fseek(f, 0L, SEEK_SET) != 0) {
        perror("seek to file beginning");
        return 1;
    }

    input = malloc(len + 1);
    if (input == NULL) {
        fprintf(stderr, "failed to allocate %ld bytes.\n", len);
        return 1;
    }

    if (fread(input, 1, len, f) < len) {
        if (feof(f)) {
            fprintf(stderr, "file truncated.\n");
            return 1;

        } else {
            perror("read file");
        }
    }

    input[len] = '\0';

    if (fclose(f) != 0) {
        perror("close file");
        return 1;
    }

    run_engines(prog, engine_types, ncaps, input);

    return 0;
}


static void
run_engines(Prog *prog, unsigned engine_types, unsigned ncaps, char *input)
{
    unsigned             i;
    int                  rc;
    char                *ovector[MAXSUB];
    size_t               ovecsize;
    clock_t              begin, elapsed;
    long                 from, to;

    if (engine_types & ENGINE_THOMPSON) {

        printf("re1 Thompson ");

        memset(ovector, 0, sizeof(ovector));

        begin = clock();
        if (begin == -1) {
            perror("clock");
            exit(2);
        }

        rc = thompsonvm(prog, input, ovector, nelem(ovector));

        elapsed = clock() - begin;
        if (elapsed < 0) {
            perror("clock");
            exit(2);
        }

        if (!rc) {
            printf("no match");

        } else {
            printf("match");
        }

        printf(": %ld clock units elapsed.\n", (long) elapsed);
    }

    if (engine_types & ENGINE_PIKE) {
        printf("re1 Pike ");

        memset(ovector, 0, sizeof(ovector));

        begin = clock();
        if (begin == -1) {
            perror("clock");
            exit(2);
        }

        rc = pikevm(prog, input, ovector, nelem(ovector));

        elapsed = clock() - begin;
        if (elapsed < 0) {
            perror("clock");
            exit(2);
        }

        if (!rc) {
            printf("no match");

        } else {
            printf("match");

            for (ovecsize = MAXSUB; ovecsize > 0; ovecsize--) {
                if (ovector[ovecsize - 1]) {
                    break;
                }
            }

            for (i = 0; i < ovecsize; i += 2) {
                if (ovector[i] == NULL) {
                    from = -1;

                } else {
                    from = ovector[i] - input;
                }

                if (ovector[i + 1] == NULL) {
                    to = -1;

                } else {
                    to = ovector[i] - input;
                }

                printf(" (%ld, %ld)", from, to);
            }
        }

        printf(": %ld clock units elapsed.\n", (long) elapsed);
    }

    printf("(1 clock unit is %lf sec)\n", (double) 1.0 / CLOCKS_PER_SEC);
}


static void
usage(int rc)
{
    fprintf(stderr, "usage: re1 [options] <regexp> <file>\n"
            "options:\n"
            "   --pike              use the Pike VM interpreter\n"
            "   --thompson          use the Thompson VM interpreter\n");
    exit(rc);
}
