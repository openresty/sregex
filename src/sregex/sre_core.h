
/*
 * Copyright (C) Igor Sysoev
 * Copyright (C) Nginx, Inc.
 */


#ifndef _SRE_CORE_H_INCLUDED_
#define _SRE_CORE_H_INCLUDED_


#include <sregex/sregex.h>
#include <string.h>
#include <assert.h>


#ifndef SRE_USE_VALGRIND
#define SRE_USE_VALGRIND  0
#endif


#define SRE_UNSET_PTR        (void *) -1


#define sre_memzero(buf, n)  (void) memset(buf, 0, n)
#define sre_nelems(a)        (sizeof(a)/sizeof((a)[0]))

#define sre_min(a, b)        ((a) <= (b) ? (a) : (b))
#define sre_max(a, b)        ((a) >= (b) ? (a) : (b))

#define sre_isword(c)                                                       \
    (((c) >= '0' && (c) <= '9')                                             \
     || ((c) >= 'A' && (c) <= 'Z')                                          \
     || ((c) >= 'a' && (c) <= 'z')                                          \
     || (c) == '_')


#define SRE_ARCH_UNKNOWN     0
#define SRE_ARCH_X86         1
#define SRE_ARCH_X64         2


#ifndef SRE_TARGET

#if defined(__i386) || defined(__i386__) || defined(_M_IX86)
#   define SRE_TARGET   SRE_ARCH_X86
#elif defined(__x86_64__) || defined(__x86_64) || defined(_M_X64)           \
      || defined(_M_AMD64)
#   define SRE_TARGET   SRE_ARCH_X64
#else
#   define SRE_TARGET   SRE_ARCH_UNKNOWN
#endif

#endif /* SRE_TARGET */


#if 0
#   undef SRE_TARGET
#   define SRE_TARGET 0
#endif


#ifndef sre_assert
#define sre_assert  assert
#endif


#endif /* _SRE_CORE_H_INCLUDED_ */
