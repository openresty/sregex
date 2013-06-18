
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


#include <sregex/sre_capture.h>
#include <stdio.h>


SRE_NOAPI sre_capture_t *
sre_capture_create(sre_pool_t *pool, size_t ovecsize, unsigned clear,
    sre_capture_t **freecap)
{
    sre_char            *p;
    sre_capture_t       *cap;

    if (*freecap) {
        dd("reusing cap %p", *freecap);
        cap = *freecap;
        *freecap = cap->next;
        cap->next = NULL;
        cap->ref = 1;

    } else {
        p = sre_pnalloc(pool, sizeof(sre_capture_t) + ovecsize);
        if (p == NULL) {
            return NULL;
        }

        cap = (sre_capture_t *) p;

        cap->ovecsize = ovecsize;
        cap->ref = 1;
        cap->next = NULL;
        cap->regex_id = 0;

        p += sizeof(sre_capture_t);
        cap->vector = (sre_int_t *) p;
    }

    if (clear) {
        (void) memset(cap->vector, -1, ovecsize);
    }

    return cap;
}


SRE_NOAPI sre_capture_t *
sre_capture_update(sre_pool_t *pool, sre_capture_t *cap, sre_uint_t group,
    sre_int_t pos, sre_capture_t **freecap)
{
    sre_capture_t       *newcap;

    dd("update cap %u to %d", group, pos);

    if (cap->ref > 1) {
        newcap = sre_capture_create(pool, cap->ovecsize, 0, freecap);
        if (newcap == NULL) {
            return NULL;
        }

        memcpy(newcap->vector, cap->vector, cap->ovecsize);

        cap->ref--;

        dd("!! cap %p: set group %u to %d", newcap, group, pos);
        newcap->vector[group] = pos;
        return newcap;
    }

    dd("!! cap %p: set group %u to %d", cap, group, pos);
    cap->vector[group] = pos;
    return cap;
}


SRE_NOAPI void
sre_capture_dump(sre_capture_t *cap)
{
    sre_uint_t            i, n;

    n = cap->ovecsize / sizeof(sre_int_t);

    for (i = 0; i < n; i += 2) {
        fprintf(stderr, " (%lld, %lld)", (long long) cap->vector[i],
                (long long) cap->vector[i + 1]);
    }
}
