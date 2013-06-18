
/*
 * Copyright 2012 Yichun "agentzh" Zhang
 * Copyright 2007-2009 Russ Cox.  All Rights Reserved.
 * Use of this source code is governed by a BSD-style
 * license that can be found in the LICENSE file.
 */


#ifndef _SRE_CAPTURE_H_INCLUDED_
#define _SRE_CAPTURE_H_INCLUDED_


#include <sregex/sre_core.h>
#include <sregex/sre_palloc.h>


#define sre_capture_decr_ref(ctx, cap)                                       \
    if (--(cap)->ref == 0) {                                                 \
        (cap)->next = (ctx)->free_capture;                                   \
        (ctx)->free_capture = (cap);                                         \
    }


typedef struct sre_capture_s  sre_capture_t;

struct sre_capture_s {
    unsigned         ref;  /* reference count */
    size_t           ovecsize;
    sre_int_t        regex_id;
    sre_int_t       *vector;
    sre_capture_t   *next;
};


SRE_NOAPI sre_capture_t *sre_capture_create(sre_pool_t *pool, size_t ovecsize,
    unsigned clear, sre_capture_t **freecap);

SRE_NOAPI sre_capture_t *sre_capture_update(sre_pool_t *pool,
    sre_capture_t *cap, sre_uint_t group, sre_int_t pos,
    sre_capture_t **freecap);

SRE_NOAPI void sre_capture_dump(sre_capture_t *cap);


#endif /* _SRE_CAPTURE_H_INCLUDED_ */
