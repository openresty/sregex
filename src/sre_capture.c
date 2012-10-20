
/*
 * Copyright 2012 Yichun "agentzh" Zhang
 * Copyright 2007-2009 Russ Cox.  All Rights Reserved.
 * Use of this source code is governed by a BSD-style
 * license that can be found in the LICENSE file.
 */


#ifndef DDEBUG
#define DDEBUG 0
#endif
#include <ddebug.h>


#include <sre_capture.h>


sre_capture_t *
sre_capture_create(sre_pool_t *pool, unsigned ovecsize, unsigned clear)
{
    u_char              *p;
    sre_capture_t       *cap;

    p = sre_pnalloc(pool, sizeof(sre_capture_t) + ovecsize);
    if (p == NULL) {
        return NULL;
    }

    cap = (sre_capture_t *) p;

    cap->ovecsize = ovecsize;
    cap->ref = 1;
    cap->next = NULL;

    p += sizeof(sre_capture_t);
    cap->vector = (int *) p;

    if (clear) {
        (void) memset(cap->vector, -1, ovecsize);
    }

    return cap;
}


sre_capture_t *
sre_capture_update(sre_pool_t *pool, sre_capture_t *cap, unsigned group,
    int pos, sre_capture_t *freecap)
{
    sre_capture_t       *newcap;

    dd("update cap %u to %d", group, pos);

    if (cap->ref > 1) {
        if (freecap) {
            newcap = freecap;
            freecap = freecap->next;
            newcap->next = NULL;

        } else {
            newcap = sre_capture_create(pool, cap->ovecsize, 0);
            if (newcap == NULL) {
                return NULL;
            }
        }

        memcpy(newcap->vector, cap->vector, cap->ovecsize);

        cap->ref--;

        newcap->vector[group] = pos;
        return newcap;
    }

    cap->vector[group] = pos;
    return cap;
}

