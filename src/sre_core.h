
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


#define  SRE_OK          0
#define  SRE_ERROR      -1
#define  SRE_DECLINED   -5


#define sre_memzero(buf, n)  (void) memset(buf, 0, n)


#endif /* _SRE_CORE_H_INCLUDED_ */
