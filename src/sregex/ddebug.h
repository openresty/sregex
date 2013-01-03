
/*
 * Copyright 2012 Yichun "agentzh" Zhang
 * Use of this source code is governed by a BSD-style
 * license that can be found in the LICENSE file.
 */


#ifndef _SREGEX_DDEBUG_H_INCLUDED_
#define _SREGEX_DDEBUG_H_INCLUDED_


#if defined(DDEBUG) && (DDEBUG)

#   include <stdio.h>

#   define dd(...) \
    fprintf(stderr, "sregex ** "); \
    fprintf(stderr, __VA_ARGS__); \
    fprintf(stderr, "\n")

#else

#   define dd(fmt, ...)

#endif


#endif /* _SREGEX_DDEBUG_H_INCLUDED_ */
