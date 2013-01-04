
/*
 * Copyright (C) Igor Sysoev
 * Copyright (C) Nginx, Inc.
 */


#ifndef _SRE_PALLOC_H_INCLUDED_
#define _SRE_PALLOC_H_INCLUDED_


#include <sregex/sregex.h>
#include <sregex/sre_core.h>


#define sre_pagesize     4096

#define sre_align(d, a)  (((d) + (a - 1)) & ~(a - 1))


#define SRE_MAX_ALLOC_FROM_POOL  (sre_pagesize - 1)

#define SRE_DEFAULT_POOL_SIZE    (16 * 1024)

#define SRE_POOL_ALIGNMENT       16
#define SRE_MIN_POOL_SIZE                                                     \
    sre_align((sizeof(sre_pool_t) + 2 * sizeof(sre_pool_large_t)),            \
              SRE_POOL_ALIGNMENT)


#ifndef SRE_ALIGNMENT
#define SRE_ALIGNMENT   sizeof(unsigned long)    /* platform word */
#endif

#define ngx_align(d, a)     (((d) + (a - 1)) & ~(a - 1))
#define sre_align_ptr(p, a)                                                  \
    (uint8_t *) (((uintptr_t) (p) + ((uintptr_t) a - 1)) & ~((uintptr_t) a - 1))


typedef void (*sre_pool_cleanup_pt)(void *data);

typedef struct sre_pool_cleanup_s  sre_pool_cleanup_t;

struct sre_pool_cleanup_s {
    sre_pool_cleanup_pt   handler;
    void                 *data;
    sre_pool_cleanup_t   *next;
};


typedef struct sre_pool_large_s  sre_pool_large_t;

struct sre_pool_large_s {
    sre_pool_large_t     *next;
    void                 *alloc;
};


#if !(SRE_USE_VALGRIND)
typedef struct {
    sre_char             *last;
    sre_char             *end;
    sre_pool_t           *next;
    unsigned              failed;
} sre_pool_data_t;
#endif


struct sre_pool_s {
#if !(SRE_USE_VALGRIND)
    sre_pool_data_t       d;
    size_t                max;
    sre_pool_t           *current;
#endif
    sre_pool_large_t     *large;
    sre_pool_cleanup_t   *cleanup;
};


SRE_NOAPI void *sre_palloc(sre_pool_t *pool, size_t size);
SRE_NOAPI void *sre_pnalloc(sre_pool_t *pool, size_t size);
SRE_NOAPI void *sre_pcalloc(sre_pool_t *pool, size_t size);
SRE_NOAPI int sre_pfree(sre_pool_t *pool, void *p);

SRE_NOAPI sre_pool_cleanup_t *sre_pool_cleanup_add(sre_pool_t *p, size_t size);


#endif /* _SRE_PALLOC_H_INCLUDED_ */
