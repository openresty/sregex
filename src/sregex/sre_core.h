
/*
 * Copyright (C) Igor Sysoev
 * Copyright (C) Nginx, Inc.
 */


#ifndef _SRE_CORE_H_INCLUDED_
#define _SRE_CORE_H_INCLUDED_


#include <sregex/sregex.h>
#include <string.h>


#ifndef SRE_USE_VALGRIND
#define SRE_USE_VALGRIND  0
#endif


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


#ifndef sre_int_t
#define sre_int_t sre_int_t
typedef intptr_t  sre_int_t;
#endif

#ifndef sre_uint_t
#define sre_uint_t sre_uint_t
typedef uintptr_t  sre_uint_t;
#endif


#endif /* _SRE_CORE_H_INCLUDED_ */
