
/*
 * Copyright 2012 Yichun "agentzh" Zhang
 * Use of this source code is governed by a BSD-style
 * license that can be found in the LICENSE file.
 */


#include <sregex/sregex.h>
#include <assert.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <time.h>


static void usage(int rc);
static void run_engines(sre_program_t *prog, unsigned engine_types,
    sre_uint_t ncaps, sre_char *input, size_t len);
static void alloc_error(void);
sre_int_t run_jitted_thompson(sre_vm_thompson_exec_pt handler,
    sre_vm_thompson_ctx_t *ctx, sre_char *input, size_t size, unsigned eof);


enum {
    ENGINE_THOMPSON     = (1 << 0),
    ENGINE_THOMPSON_JIT = (1 << 1),
    ENGINE_PIKE         = (1 << 2)
};


#define TIMER_START                                                          \
        if (clock_gettime(CLOCK_PROCESS_CPUTIME_ID, &begin) == -1) {         \
            perror("clock_gettime");                                         \
            exit(2);                                                         \
        }


#define TIMER_STOP                                                           \
        if (clock_gettime(CLOCK_PROCESS_CPUTIME_ID, &end) == -1) {           \
            perror("clock_gettime");                                         \
            exit(2);                                                         \
        }                                                                    \
        elapsed = (end.tv_sec - begin.tv_sec) * 1e3 + (end.tv_nsec - begin.tv_nsec) * 1e-6;


int
main(int argc, char **argv)
{
    int                  flags = 0;
    unsigned             engine_types = 0;
    sre_uint_t           i;
    sre_int_t            err_offset = -1;
    sre_pool_t          *ppool; /* parser pool */
    sre_pool_t          *cpool; /* compiler pool */
    sre_regex_t         *re;
    sre_program_t       *prog;
    sre_uint_t           ncaps;
    sre_char            *input;
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

        if (strncmp(argv[i], "--thompson-jit",
                    sizeof("--thompson-jit") - 1) == 0)
        {
            engine_types |= ENGINE_THOMPSON_JIT;

        } else if (strncmp(argv[i], "--thompson", sizeof("--thompson") - 1)
                   == 0)
        {
            engine_types |= ENGINE_THOMPSON;

        } else if (strncmp(argv[i], "--pike", sizeof("--pike") - 1)
                   == 0)
        {
            engine_types |= ENGINE_PIKE;

        } else if (strncmp(argv[i], "-i", 2) == 0) {
            flags |= SRE_REGEX_CASELESS;

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

    ppool = sre_create_pool(1024);
    if (ppool == NULL) {
        return 2;
    }

    re = sre_regex_parse(ppool, (sre_char *) argv[i++], &ncaps, flags, &err_offset);
    if (re == NULL) {
        if (err_offset >= 0) {
            fprintf(stderr, "[error] syntax error at pos %lld\n",
                    (long long) err_offset);
        }

        fprintf(stderr, "unknown error\n");
        return 2;
    }

    cpool = sre_create_pool(1024);
    if (cpool == NULL) {
        return 2;
    }

    prog = sre_regex_compile(cpool, re);
    if (prog == NULL) {
        fprintf(stderr, "failed to compile the regex.\n");
        return 2;
    }

    sre_destroy_pool(ppool);
    ppool = NULL;
    re = NULL;

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

    input = malloc(len);
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

    if (fclose(f) != 0) {
        perror("close file");
        return 1;
    }

    run_engines(prog, engine_types, ncaps, input, len);

    free(input);
    sre_destroy_pool(cpool);
    return 0;
}


static void
run_engines(sre_program_t *prog, unsigned engine_types, sre_uint_t ncaps,
    sre_char *input, size_t len)
{
    sre_uint_t           i;
    sre_int_t            rc;
    sre_int_t           *ovector;
    size_t               ovecsize;
    sre_pool_t          *pool;
    struct timespec      begin, end;
    double               elapsed;

    sre_vm_thompson_ctx_t       *tctx;
    sre_vm_pike_ctx_t           *pctx;
    sre_vm_thompson_code_t      *tcode;
    sre_vm_thompson_exec_pt      texec;

    pool = sre_create_pool(1024);
    if (pool == NULL) {
        exit(2);
    }

    if (engine_types & ENGINE_THOMPSON) {

        printf("sregex Thompson ");

        tctx = sre_vm_thompson_create_ctx(pool, prog);
        if (tctx == NULL) {
            alloc_error();
        }

        TIMER_START

        rc = sre_vm_thompson_exec(tctx, input, len, 1);

        TIMER_STOP

        switch (rc) {
        case SRE_OK:
            printf("match");
            break;

        case SRE_DECLINED:
            printf("no match");
            break;

        case SRE_AGAIN:
            printf("again");
            break;

        case SRE_ERROR:
            printf("error");
            break;

        default:
            printf("bad retval: %lx\n", (unsigned long) rc);
            exit(2);
        }

        printf(": %.02lf ms elapsed.\n", elapsed);

        sre_reset_pool(pool);
    }

    if (engine_types & ENGINE_THOMPSON_JIT) {
        rc = sre_vm_thompson_jit_compile(pool, prog, &tcode);

        if (rc == SRE_DECLINED) {
            printf("sregex thompson JIT disabled\n");
            exit(2);
        }

        if (rc != SRE_OK) {
            fprintf(stderr, "failed to run thompson jit compile: %ld\n", (long) rc);
            exit(2);
        }

        texec = sre_vm_thompson_jit_get_handler(tcode);
        if (texec == NULL) {
            fprintf(stderr, "failed to get Thompson JIT handler.\n");
            exit(2);
        }

        printf("sregex Thompson JIT ");

        tctx = sre_vm_thompson_jit_create_ctx(pool, prog);
        if (tctx == NULL) {
            alloc_error();
        }

        TIMER_START

        rc = run_jitted_thompson(texec, tctx, input, len, 1);

        TIMER_STOP

        switch (rc) {
        case SRE_OK:
            printf("match");
            break;

        case SRE_DECLINED:
            printf("no match");
            break;

        case SRE_AGAIN:
            printf("again");
            break;

        case SRE_ERROR:
            printf("error");
            break;

        default:
            printf("bad retval: %lx\n", (unsigned long) rc);
            exit(2);
        }

        printf(": %.02lf ms elapsed.\n", elapsed);

        sre_reset_pool(pool);
    }

    if (engine_types & ENGINE_PIKE) {
        ovecsize = 2 * (ncaps + 1) * sizeof(sre_int_t);
        ovector = malloc(ovecsize);
        if (ovector == NULL) {
            alloc_error();
        }

        printf("sregex Pike ");

        pctx = sre_vm_pike_create_ctx(pool, prog, ovector, ovecsize);
        if (pctx == NULL) {
            alloc_error();
        }

        TIMER_START

        rc = sre_vm_pike_exec(pctx, input, len, 1 /* eof */, NULL);

        TIMER_STOP

        switch (rc) {
        case SRE_OK:
            printf("match");

            for (i = 0; i < 2 * (ncaps + 1); i += 2) {
                printf(" (%ld, %ld)", (long) ovector[i], (long) ovector[i + 1]);
            }

            break;

        case SRE_AGAIN:
            printf("again");
            break;

        case SRE_DECLINED:
            printf("no match");
            break;

        case SRE_ERROR:
            printf("error");
            break;

        default:
            assert(rc);
            break;
        }

        printf(": %.02lf ms elapsed.\n", elapsed);

        free(ovector);
        sre_reset_pool(pool);
    }

    sre_destroy_pool(pool);
}


static void
alloc_error(void)
{
    fprintf(stderr, "failed to allocate memory");
    exit(2);
}


static void
usage(int rc)
{
    fprintf(stderr, "usage: sregex [options] <regexp> <file>\n"
            "options:\n"
            "   -i                  use case insensitive matching\n"
            "   --pike              use the Pike VM interpreter\n"
            "   --thompson          use the Thompson VM interpreter\n"
            "   --thompson-jit      use the Thompson VM JIT compiler\n");
    exit(rc);
}


sre_int_t
run_jitted_thompson(sre_vm_thompson_exec_pt handler, sre_vm_thompson_ctx_t *ctx,
    sre_char *input, size_t size, unsigned eof)
{
    return handler(ctx, input, size, eof);
}
