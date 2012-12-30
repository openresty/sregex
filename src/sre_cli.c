
/*
 * Copyright 2012 Yichun "agentzh" Zhang
 * Copyright 2007-2009 Russ Cox.  All Rights Reserved.
 * Use of this source code is governed by a BSD-style
 * license that can be found in the LICENSE file.
 */


#ifndef DDEBUG
#define DDEBUG 0
#endif
#include <sregex/ddebug.h>


#include <sregex/sregex.h>
#include <assert.h>


static void usage(void);
static void process_string(u_char *s, size_t len, sre_program_t *prog,
    int *ovector, unsigned ovecsize, unsigned ncaps);


int
main(int argc, char **argv)
{
    int                  i, n;
    int                  flags = 0;
    sre_pool_t          *ppool; /* parser pool */
    sre_pool_t          *cpool; /* compiler pool */
    sre_regex_t         *re;
    sre_program_t       *prog;
    unsigned             ncaps;
    int                 *ovector;
    unsigned             ovecsize;
    u_char              *s, *p;
    size_t               len;
    unsigned             from_stdin = 0;

    if (argc < 2) {
        usage();
    }

    for (i = 1; i < argc; i++) {
        if (argv[i][0] != '-') {
            break;
        }

        if (strncmp(argv[i], "--stdin", sizeof("--stdin") - 1) == 0) {
            from_stdin = 1;

        } else if (strncmp(argv[i], "-i", 2) == 0) {
            flags |= SRE_REGEX_CASELESS;

        } else {
            fprintf(stderr, "unknown option: %s\n", argv[i]);
            exit(1);
        }
    }

    ppool = sre_create_pool(1024);
    if (ppool == NULL) {
        return 2;
    }

    re = sre_regex_parse(ppool, (u_char *) argv[i], &ncaps, flags);
    if (re == NULL) {
        return 2;
    }

    i++;

    sre_regex_dump(re);
    printf("\n");

    printf("captures: %d\n", ncaps);

    cpool = sre_create_pool(1024);
    if (cpool == NULL) {
        return 2;
    }

    prog = sre_regex_compile(cpool, re);
    if (prog == NULL) {
        return 2;
    }

    sre_destroy_pool(ppool);
    ppool = NULL;
    re = NULL;

    sre_program_dump(prog);

    ovecsize = 2 * (ncaps + 1) * sizeof(int);
    ovector = sre_palloc(cpool, ovecsize);
    if (ovector == NULL) {
        return 2;
    }

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

            process_string(s, len, prog, ovector, ovecsize, ncaps);

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

            process_string(s, len, prog, ovector, ovecsize, ncaps);

            free(s);
        }
    }

    sre_destroy_pool(cpool);
    prog = NULL;
    cpool = NULL;

    return 0;
}


static void
process_string(u_char *s, size_t len, sre_program_t *prog, int *ovector,
    unsigned ovecsize, unsigned ncaps)
{
    int                          i, j, rc;
    u_char                      *p;
    unsigned                     gen_empty_buf;
    sre_pool_t                  *pool;
    sre_vm_pike_ctx_t           *pctx;
    sre_vm_thompson_ctx_t       *tctx;

    printf("## %.*s (len %d)\n", (int) len, s, (int) len);

    p = malloc(1);
    if (p == NULL) {
        exit(2);
    }

    pool = sre_create_pool(1024);
    if (pool == NULL) {
        exit(2);
    }

    printf("thompson ");

    tctx = sre_vm_thompson_create_ctx(pool, prog);
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

    printf("splitted thompson ");

    tctx = sre_vm_thompson_create_ctx(pool, prog);
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

    printf("pike ");

    pctx = sre_vm_pike_create_ctx(pool, prog, ovector, ovecsize);
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

    printf("splitted pike ");

    pctx = sre_vm_pike_create_ctx(pool, prog, ovector, ovecsize);
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

#if 1
            if (rc == SRE_AGAIN) {
                printf("[");
                for (j = 0; j < 2 * (ncaps + 1); j += 2) {
                    printf("(%d, %d)", ovector[j], ovector[j + 1]);
                }
                printf("] ");
            }
#endif

            gen_empty_buf = 1;
        }

        dd("i = %d, rc = %d", i, rc);

        switch (rc) {
        case SRE_OK:
            printf("match");

            for (j = 0; j < 2 * (ncaps + 1); j += 2) {
                printf(" (%d, %d)", ovector[j], ovector[j + 1]);
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

    sre_destroy_pool(pool);
    free(p);
}


static void
usage(void)
{
    fprintf(stderr, "usage: sregex-cli regexp string...\n");
    fprintf(stderr, "       sregex-cli --stdin regexp\n");
    exit(2);
}

