
/*
 * Copyright 2012 Yichun "agentzh" Zhang
 * Use of this source code is governed by a BSD-style
 * license that can be found in the LICENSE file.
 */


#include <re2/re2.h>
#include <re2/stringpiece.h>
#include <cassert>
#include <cstring>
#include <cstdio>
#include <cerrno>
#include <ctime>
#include <cstdlib>


static void usage(int rc);
static void run_engine(RE2 *re, char *input);


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
    int                  i;
    RE2                 *re;
    char                *re_str, *p;
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

        fprintf(stderr, "unknown option: %s\n", argv[i]);
        exit(1);
    }

    if (argc - i != 2) {
        usage(1);
    }

    re_str = argv[i++];
    len = strlen(re_str);

    p = (char *) malloc(len + 1 + sizeof("()") - 1);
    if (p == NULL) {
        return 2;
    }

    p[0] = '(';
    memcpy(&p[1], re_str, len);
    p[len + 1] = ')';
    p[len + 2] = '\0';

    //printf("regex: %s\n", p);

    re = new RE2(p);
    if (re == NULL) {
        return 2;
    }

    free(p);

    if (!re->ok()) {
        delete re;
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

    input = (char *) malloc(len + 1);
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

    run_engine(re, input);

    delete re;
    free(input);
    return 0;
}


static void
run_engine(RE2 *re, char *input)
{
    bool                 rc;
    re2::StringPiece     cap;
    struct timespec      begin, end;
    double               elapsed;
    const char          *p;

    printf("re2 ");

    TIMER_START

    rc = RE2::PartialMatch(input, *re, &cap);

    TIMER_STOP

    if (rc) {
        p = cap.data();
        printf("match (%ld, %ld)", (long) (p - input),
               (long) (p - input + cap.size()));

    } else {
        printf("no match");
    }

    printf(": %.02lf ms elapsed.\n", elapsed);
}


static void
usage(int rc)
{
    fprintf(stderr, "usage: re2 <regexp> <file>\n");
    exit(rc);
}
