
/*
 * Copyright 2012 Yichun "agentzh" Zhang
 * Copyright 2007-2009 Russ Cox.  All Rights Reserved.
 * Use of this source code is governed by a BSD-style
 * license that can be found in the LICENSE file.
 */


#ifndef _SRE_CAPTURE_H_INCLUDED_
#define _SRE_CAPTURE_H_INCLUDED_


enum {
    SRE_MAX_CAPTURES = 20
};


typedef struct {
    unsigned      count;
    u_char       *captures[SRE_MAX_CAPTURES];
} sre_capture_t;


sre_capture_t *sre_capture_create(unsigned ncaps);
sre_capture_t *sre_capture_fork(sre_capture_t *cap, unsigned ncaps,
    u_char *pos);
void sre_capture_destroy(sre_capture_t *cap);


#endif /* _SRE_CAPTURE_H_INCLUDED_ */
