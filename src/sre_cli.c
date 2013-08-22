
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
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <errno.h>


static void usage(void);
static void process_string(sre_char *s, size_t len, sre_program_t *prog,
    sre_int_t *ovector, size_t ovecsize, sre_uint_t ncaps);
sre_int_t run_jitted_thompson(sre_vm_thompson_exec_pt handler,
    sre_vm_thompson_ctx_t *ctx, sre_char *input, size_t size, unsigned eof);
static sre_int_t parse_regex_flags(const char *flags_str, int nregexes,
    int *multi_flags);


int
main(int argc, char **argv)
{
    sre_uint_t           i, n;
    const char          *flags_str = NULL;
    int                 *multi_flags = NULL;
    sre_int_t            err_offset = -1, err_regex_id;
    sre_pool_t          *ppool; /* parser pool */
    sre_pool_t          *cpool; /* compiler pool */
    sre_regex_t         *re;
    sre_program_t       *prog;
    sre_uint_t           ncaps;
    sre_int_t           *ovector;
    size_t               ovecsize;
    sre_char            *s, *p;
    size_t               len;
    unsigned             from_stdin = 0;
    sre_int_t            nregexes = 1;

    if (argc < 2) {
        usage();
    }

    for (i = 1; i < argc; i++) {
        if (argv[i][0] != '-') {
            break;
        }

        if (strncmp(argv[i], "--stdin", sizeof("--stdin") - 1) == 0) {
            from_stdin = 1;

        } else if (strncmp(argv[i], "--flags", sizeof("--flags") - 1) == 0) {
            if (i == argc - 1) {
                fprintf(stderr, "--flags should take a value.\n");
                return 1;
            }

            i++;

            flags_str = argv[i];

        } else if (strncmp(argv[i], "-n", 2) == 0) {
            if (i == argc - 1) {
                fprintf(stderr, "-n should take a value.\n");
                return 1;
            }

            i++;

            nregexes = atoi(argv[i]);
            if (nregexes <= 0) {
                fprintf(stderr, "invalid -n value: %s.\n", argv[i]);
                return 1;
            }

        } else {
            fprintf(stderr, "unknown option: %s\n", argv[i]);
            return 1;
        }
    }

    ppool = sre_create_pool(1024);
    if (ppool == NULL) {
        return 2;
    }

    dd("nregexes: %d", (int) nregexes);

    if (flags_str) {
        multi_flags = malloc(nregexes * sizeof(int));
        if (multi_flags == NULL) {
            return 2;
        }

        memset(multi_flags, 0, nregexes * sizeof(int));

        if (parse_regex_flags(flags_str, nregexes, multi_flags) != SRE_OK) {
            fprintf(stderr, "Bad --flags option value: %s", flags_str);
            free(multi_flags);
            return 1;
        }
    }

    if (nregexes == 1) {
        re = sre_regex_parse(ppool, (sre_char *) argv[i], &ncaps,
                             multi_flags ? multi_flags[0] : 0, &err_offset);
        if (re == NULL) {
            if (err_offset >= 0) {
                fprintf(stderr, "[error] syntax error at pos %lld\n",
                        (long long) err_offset);

            } else {
                fprintf(stderr, "unknown error\n");
            }

            if (multi_flags) {
                free(multi_flags);
            }

            sre_destroy_pool(ppool);
            return 1;
        }

        i++;

    } else {

        if (argc - i < nregexes) {
            fprintf(stderr, "at least %ld regexes should be specified\n",
                    (long) nregexes);

            if (multi_flags) {
                free(multi_flags);
            }

            sre_destroy_pool(ppool);
            return 1;
        }

        re = sre_regex_parse_multi(ppool, (sre_char **) &argv[i], nregexes,
                                   &ncaps, multi_flags, &err_offset, &err_regex_id);
        if (re == NULL) {
            if (err_offset >= 0) {
                fprintf(stderr, "[error] regex %lu: syntax error at pos %ld\n",
                        (unsigned long) err_regex_id, (long) err_offset);

            } else {
                fprintf(stderr, "unknown error\n");
            }

            if (multi_flags) {
                free(multi_flags);
            }

            sre_destroy_pool(ppool);
            return 1;
        }

        i += nregexes;
    }

    sre_regex_dump(re);
    printf("\n");

    printf("captures: %ld\n", (long) ncaps);

    cpool = sre_create_pool(1024);
    if (cpool == NULL) {
        if (multi_flags) {
            free(multi_flags);
        }
        return 2;
    }

    prog = sre_regex_compile(cpool, re);
    if (prog == NULL) {
        fprintf(stderr, "failed to compile the regex.\n");
        sre_destroy_pool(ppool);
        sre_destroy_pool(cpool);
        if (multi_flags) {
            free(multi_flags);
        }
        return 2;
    }

    sre_destroy_pool(ppool);
    ppool = NULL;
    re = NULL;

    sre_program_dump(prog);

    ovecsize = 2 * (ncaps + 1) * sizeof(sre_int_t);
    ovector = malloc(ovecsize);
    if (ovector == NULL) {
        if (multi_flags) {
            free(multi_flags);
        }
        return 2;
    }

    if (from_stdin) {

        for (;;) {
            {
                int i, n;

                n = scanf("%d", &i);
                if (n != 1) {
                    if (errno != 0) {
                        perror("scanf");
                        exit(1);
                    }

                    break;
                }

                len = (size_t) i;

                n = getchar();
                if (n != '\n') {
                    fprintf(stderr, "the next character after the chunk size "
                            "must be a newline");
                    exit(1);
                }
            }

            s = malloc(len);
            if (s == NULL) {
                free(ovector);
                return 2;
            }

            n = fread(s, 1, len, stdin);
            if (n < len) {
                fprintf(stderr, "failed to read %ld bytes of string from "
                        "stdin (only read %ld bytes).", (long) len, (long) n);

                free(s);
                free(ovector);
                return 2;
            }

            process_string(s, len, prog, ovector, ovecsize, ncaps);

            free(s);
        }

    } else {

        if (i >= argc) {
            fprintf(stderr, "no subject string specified.\n");
            return 1;
        }

        for (; i < argc; i++) {
            len = strlen(argv[i]);
            p = (sre_char *) argv[i];

            s = malloc(len);
            if (s == NULL) {
                free(ovector);
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
    free(ovector);

    if (multi_flags) {
        free(multi_flags);
    }

    return 0;
}


static void
process_string(sre_char *s, size_t len, sre_program_t *prog, sre_int_t *ovector,
    size_t ovecsize, sre_uint_t ncaps)
{
    sre_uint_t                   i, j;
    sre_int_t                    rc;
    sre_char                    *p;
    unsigned                     gen_empty_buf;
    sre_int_t                   *pending_matched;
    sre_pool_t                  *pool;
    sre_vm_pike_ctx_t           *pctx;
    sre_vm_thompson_ctx_t       *tctx;
    sre_vm_thompson_code_t      *tcode;
    sre_vm_thompson_exec_pt      texec;

    printf("## %.*s (len %d)\n", (int) len, s, (int) len);

    p = malloc(1);
    if (p == NULL) {
        exit(2);
    }

    pool = sre_create_pool(1024);
    if (pool == NULL) {
        free(p);
        exit(2);
    }

    /*
     * Thompson
     */

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

    sre_reset_pool(pool);

    /*
     * Splitted Thompson
     */

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

    sre_reset_pool(pool);

    /*
     * run Thompson VM's JIT compiler
     */

    rc = sre_vm_thompson_jit_compile(pool, prog, &tcode);
    if (rc == SRE_DECLINED) {
        printf("jitted thompson disabled\n");
        printf("splitted jitted thompson disabled\n");
        goto pike;
    }

    if (rc != SRE_OK) {
        fprintf(stderr, "failed to run thompson jit compile: %ld\n", (long) rc);
        exit(2);
    }

    texec = sre_vm_thompson_jit_get_handler(tcode);
    if (texec == NULL) {
        fprintf(stderr, "failed to get thompson jit handler.\n");
        exit(2);
    }

    /*
     * JITted Thompson
     */

    printf("jitted thompson ");

    tctx = sre_vm_thompson_jit_create_ctx(pool, prog);
    assert(tctx);

    rc = run_jitted_thompson(texec, tctx, s, len, 1);
#if 0
    rc = (sre_int_t) run_jitted_thompson;
#endif

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
        printf("bad retval: %lx\n", (unsigned long) rc);
        break;
    }

    sre_reset_pool(pool);

    /*
     * Splitted JITted Thompson
     */

    printf("splitted jitted thompson ");

    tctx = sre_vm_thompson_jit_create_ctx(pool, prog);
    assert(tctx);

    gen_empty_buf = 1;

    for (i = 0; i <= len; i++) {
        if (i == len) {
            rc = run_jitted_thompson(texec, tctx, NULL, 0 /* len */,
                                     1 /* eof */);

        } else if (gen_empty_buf) {
            rc = run_jitted_thompson(texec, tctx, NULL, 0 /* len */,
                                     0 /* eof */);
            gen_empty_buf = 0;
            i--;

        } else {
            p[0] = s[i];

            rc = run_jitted_thompson(texec, tctx, p, 1 /* len */, 0 /* eof */);
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

    if (sre_vm_thompson_jit_free(tcode) != SRE_OK) {
        fprintf(stderr, "failed to free thompson jit.\n");
        exit(2);
    }

    sre_reset_pool(pool);

pike:
    printf("pike ");

    pctx = sre_vm_pike_create_ctx(pool, prog, ovector, ovecsize);
    assert(pctx);

    rc = sre_vm_pike_exec(pctx, s, len, 1 /* eof */, NULL);

    if (rc >= 0) {
        printf("match %ld", (long) rc);

        for (i = 0; i < 2 * (ncaps + 1); i += 2) {
            printf(" (%ld, %ld)", (long) ovector[i], (long) ovector[i + 1]);
        }

        printf("\n");

    } else {
        switch (rc) {
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
            printf("unknown (%d)\n", (int) rc);
            break;
        }
    }

    sre_reset_pool(pool);

    printf("splitted pike ");

    dd("===== splitted pike =====");

    pctx = sre_vm_pike_create_ctx(pool, prog, ovector, ovecsize);
    assert(pctx);

    gen_empty_buf = 1;

    for (i = 0; i <= len; i++) {
        if (i == len) {
            rc = sre_vm_pike_exec(pctx, NULL, 0 /* len */, 1 /* eof */,
                                  &pending_matched);

        } else if (gen_empty_buf) {
            rc = sre_vm_pike_exec(pctx, NULL, 0 /* len */, 0 /* eof */, NULL);
            gen_empty_buf = 0;
            i--;

        } else {
            p[0] = s[i];
            rc = sre_vm_pike_exec(pctx, p, 1 /* len */, 0 /* eof */,
                                  &pending_matched);

#if 1
            if (rc == SRE_AGAIN) {
                printf("[");
                for (j = 0; j < 2; j += 2) {
                    printf("(%ld, %ld)", (long) ovector[j],
                           (long) ovector[j + 1]);
                }
                printf("]");

                if (pending_matched) {
                    printf("(%ld, %ld) ", (long) pending_matched[0],
                           (long) pending_matched[1]);

                } else {
                    printf(" ");
                }
            }
#endif

            gen_empty_buf = 1;
        }

        dd("i = %d, rc = %d", (int) i, (int) rc);

        if (rc >= 0) {
            printf("match %ld", (long) rc);

            for (j = 0; j < 2 * (ncaps + 1); j += 2) {
                printf(" (%ld, %ld)", (long) ovector[j], (long) ovector[j + 1]);
            }

            printf("\n");

        } else {
            switch (rc) {
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
                printf("unknown (%d)\n", (int) rc);
                break;
            }
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


sre_int_t
run_jitted_thompson(sre_vm_thompson_exec_pt handler, sre_vm_thompson_ctx_t *ctx,
    sre_char *input, size_t size, unsigned eof)
{
    return handler(ctx, input, size, eof);
}


static sre_int_t
parse_regex_flags(const char *flags_str, int nregexes,
    int *multi_flags)
{
    int           i = 0;
    const char   *p;

    for (p = flags_str; *p != '\0'; p++) {
        if (i >= nregexes) {
            fprintf(stderr, "Too many flags given but only %d regexes "
                    "specified.\n", nregexes);

            return SRE_ERROR;
        }

        switch (*p) {
        case ' ':
            i++;
            break;

        case 'i':
            multi_flags[i] |= SRE_REGEX_CASELESS;
            break;

        default:
            fprintf(stderr, "Bad regex flag '%c' for regex %d\n", *p, i);
            return SRE_ERROR;
        }
    }

    return SRE_OK;
}
