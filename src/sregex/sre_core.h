
/*
 * Copyright (C) Igor Sysoev
 * Copyright (C) Nginx, Inc.
 */


#ifndef _SRE_CORE_H_INCLUDED_
#define _SRE_CORE_H_INCLUDED_


#include <stdlib.h>
#include <stdint.h>
#include <stdarg.h>
#include <stdio.h>
#include <string.h>


#ifndef SRE_USE_VALGRIND
#define SRE_USE_VALGRIND  0
#endif

#ifndef u_char
#define u_char  uint8_t
#endif

#define  SRE_OK          0
#define  SRE_ERROR      -1
#define  SRE_AGAIN      -2
#define  SRE_BUSY       -3
#define  SRE_DONE       -4
#define  SRE_DECLINED   -5


#define SRE_UNSET_PTR   (void *) -1


#define sre_memzero(buf, n)  (void) memset(buf, 0, n)
#define sre_nelems(a)        (sizeof(a)/sizeof((a)[0]))

#define sre_min(a, b)        ((a) <= (b) ? (a) : (b))
#define sre_max(a, b)        ((a) >= (b) ? (a) : (b))

#define sre_isword(c)                                                       \
    (((c) >= '0' && (c) <= '9')                                             \
     || ((c) >= 'A' && (c) <= 'Z')                                          \
     || ((c) >= 'a' && (c) <= 'z')                                          \
     || (c) == '_')


#endif /* _SRE_CORE_H_INCLUDED_ */
