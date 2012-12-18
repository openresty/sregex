
/*
 * Copyright 2012 Yichun "agentzh" Zhang
 * Copyright 2007-2009 Russ Cox.  All Rights Reserved.
 * Use of this source code is governed by a BSD-style
 * license that can be found in the LICENSE file.
 */


#ifndef DDEBUG
#define DDEBUG 0
#endif
#include <ddebug.h>


#include <sre_regex_parser.h>
#include <sre_regex_compiler.h>
#include <sre_vm_thompson.h>
#include <sre_vm_pike.h>
#include <assert.h>


static void usage(void);
static void process_string(u_char *s, size_t len, sre_pool_t *pool,
    sre_program_t *prog, int *ovector, unsigned ovecsize, unsigned ncaps);


int
main(int argc, char **argv)
{
    int                  i, n;
    sre_pool_t          *pool;
    sre_regex_t         *re;
    sre_program_t       *prog;
    unsigned             ncaps;
    int                 *ovector;
    unsigned             ovecsize;
    u_char              *s, *p;
    size_t               len;
    unsigned             from_stdin;

    if (argc < 2) {
        usage();
    }

    i = 1;

    if (strcmp(argv[i], "--stdin") == 0) {
        from_stdin = 1;
        i++;

    } else {
        from_stdin = 0;

        if (argc < 3) {
            usage();
        }
    }

    pool = sre_create_pool(4096);
    if (pool == NULL) {
        return 2;
    }

    re = sre_regex_parse(pool, (u_char *) argv[i], &ncaps);
    if (re == NULL) {
        return 2;
    }

    i++;

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

    dd("binary: %d, i = %d", binary, i);

    if (from_stdin) {

        for (;;) {
            len = (size_t) getchar();
            if (len == EOF) {
                break;
            }

            s = malloc(len);
            if (s == NULL) {
                return 2;
            }

            n = fread(s, 1, len, stdin);
            if (n < len) {
                fprintf(stderr, "failed to read %d bytes of string from "
                        "stdin (only read %d bytes).", (int) len, n);

                free(s);
                return 2;
            }

            process_string(s, len, pool, prog, ovector, ovecsize, ncaps);

            free(s);
        }

    } else {

        for (; i < argc; i++) {
            len = strlen(argv[i]);
            p = (u_char *) argv[i];

            s = malloc(len);
            if (s == NULL) {
                return 2;
            }

            memcpy(s, p, len);

            process_string(s, len, pool, prog, ovector, ovecsize, ncaps);

            free(s);
        }
    }

    sre_destroy_pool(pool);

    return 0;
}


static void
process_string(u_char *s, size_t len, sre_pool_t *pool, sre_program_t *prog,
    int *ovector, unsigned int ovecsize, unsigned ncaps)
{
    int                          i, rc;
    u_char                      *p;
    sre_vm_thompson_ctx_t       *tctx;
    sre_vm_pike_ctx_t           *pctx;
    unsigned                     gen_empty_buf;

    printf("## %.*s (len %d)\n", (int) len, s, (int) len);

    p = malloc(1);
    if (p == NULL) {
        exit(2);
    }

    printf("thompson ");

    tctx = sre_vm_thompson_init(pool, prog);
    assert(tctx);

    rc = sre_vm_thompson_exec(tctx, s, len, 1);

    switch (rc) {
    case SRE_OK:
        printf("match\n");
        break;

    case SRE_DECLINED:
        printf("no match\n");
        break;

    case SRE_AGAIN:
        printf("again\n");
        break;

    case SRE_ERROR:
        printf("error\n");
        break;

    default:
        assert(rc);
    }

    sre_vm_thompson_finalize(tctx);

    printf("splitted thompson ");

    tctx = sre_vm_thompson_init(pool, prog);
    assert(tctx);

    gen_empty_buf = 1;

    for (i = 0; i <= len; i++) {
        if (i == len) {
            rc = sre_vm_thompson_exec(tctx, NULL, 0 /* len */, 1 /* eof */);

        } else if (gen_empty_buf) {
            rc = sre_vm_thompson_exec(tctx, NULL, 0 /* len */, 0 /* eof */);
            gen_empty_buf = 0;
            i--;

        } else {
            p[0] = s[i];

            rc = sre_vm_thompson_exec(tctx, p, 1 /* len */, 0 /* eof */);
            gen_empty_buf = 1;
        }

        switch (rc) {
        case SRE_AGAIN:
#if 0
            printf("again");
#endif
            continue;

        case SRE_OK:
            printf("match\n");
            break;

        case SRE_DECLINED:
            printf("no match\n");
            break;

        case SRE_ERROR:
            printf("error\n");
            break;

        default:
            assert(rc);
        }

        break;
    }

    sre_vm_thompson_finalize(tctx);

    printf("pike ");

    pctx = sre_vm_pike_init(pool, prog, ovector, ovecsize);
    assert(pctx);

    rc = sre_vm_pike_exec(pctx, s, len, 1 /* eof */);

    switch (rc) {
    case SRE_OK:
        printf("match");

        for (i = 0; i < 2 * (ncaps + 1); i += 2) {
            printf(" (%d, %d)", ovector[i], ovector[i + 1]);
        }

        printf("\n");
        break;

    case SRE_AGAIN:
        printf("again\n");
        break;

    case SRE_DECLINED:
        printf("no match\n");
        break;

    case SRE_ERROR:
        printf("error\n");
        break;

    default:
        assert(rc);
        break;
    }

    sre_vm_pike_finalize(pctx);

    printf("splitted pike ");

    pctx = sre_vm_pike_init(pool, prog, ovector, ovecsize);
    assert(pctx);

    gen_empty_buf = 1;

    for (i = 0; i <= len; i++) {
        if (i == len) {
            rc = sre_vm_pike_exec(pctx, NULL, 0 /* len */, 1 /* eof */);

        } else if (gen_empty_buf) {
            rc = sre_vm_pike_exec(pctx, NULL, 0 /* len */, 0 /* eof */);
            gen_empty_buf = 0;
            i--;

        } else {
            p[0] = s[i];
            rc = sre_vm_pike_exec(pctx, p, 1 /* len */, 0 /* eof */);
            gen_empty_buf = 1;
        }

        switch (rc) {
        case SRE_OK:
            printf("match");

            for (i = 0; i < 2 * (ncaps + 1); i += 2) {
                printf(" (%d, %d)", ovector[i], ovector[i + 1]);
            }

            printf("\n");
            break;

        case SRE_AGAIN:
#if 0
            printf("again\n");
#endif
            continue;

        case SRE_DECLINED:
            printf("no match\n");
            break;

        case SRE_ERROR:
            printf("error\n");
            break;

        default:
            assert(rc);
            break;
        }

        break;
    }

    sre_vm_pike_finalize(pctx);

    free(p);
}


static void
usage(void)
{
    fprintf(stderr, "usage: sregex-cli regexp string...\n");
    fprintf(stderr, "       sregex-cli --stdin regexp\n");
    exit(2);
}

