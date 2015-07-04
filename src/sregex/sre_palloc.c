
/*
 * Copyright (C) Igor Sysoev
 * Copyright (C) Nginx, Inc.
 */


#ifndef DDEBUG
#define DDEBUG 0
#endif
#include <sregex/ddebug.h>


#include <sregex/sre_palloc.h>


#if !(SRE_USE_VALGRIND)
static void *sre_palloc_block(sre_pool_t *pool, size_t size);
#endif
static void *sre_palloc_large(sre_pool_t *pool, size_t size);
#if !(SRE_USE_VALGRIND)
static void * sre_memalign(size_t alignment, size_t size);
#endif


SRE_API sre_pool_t *
sre_create_pool(size_t size)
{
    sre_pool_t  *p;

#if (SRE_USE_VALGRIND)
    size = sizeof(sre_pool_t);
    p = malloc(size);
#else
    p = sre_memalign(SRE_POOL_ALIGNMENT, size);
#endif
    if (p == NULL) {
        return NULL;
    }

#if !(SRE_USE_VALGRIND)
    p->d.last = (uint8_t *) p + sizeof(sre_pool_t);
    p->d.end = (uint8_t *) p + size;
    p->d.next = NULL;
    p->d.failed = 0;

    size = size - sizeof(sre_pool_t);
    p->max = (size < SRE_MAX_ALLOC_FROM_POOL) ? size : SRE_MAX_ALLOC_FROM_POOL;

    p->current = p;
#endif

    p->large = NULL;
    p->cleanup = NULL;

    return p;
}


SRE_API void
sre_destroy_pool(sre_pool_t *pool)
{
#if !(SRE_USE_VALGRIND)
    sre_pool_t          *p, *n;
#else
    sre_pool_large_t    *n;
#endif
    sre_pool_large_t    *l;
    sre_pool_cleanup_t  *c;

    for (c = pool->cleanup; c; c = c->next) {
        if (c->handler) {
            c->handler(c->data);
        }
    }

#if (SRE_USE_VALGRIND)
    if (pool->large == NULL) {
        free(pool);
        return;
    }
#endif

#if (SRE_USE_VALGRIND)
    for (l = pool->large; l; l = n) {
        if (l->alloc) {
            free(l->alloc);
            n = l->next;
            free(l);

        } else {
            n = l->next;
        }
    }
#else
    for (l = pool->large; l; l = l->next) {
        if (l->alloc) {
            free(l->alloc);
        }
    }
#endif

#if !(SRE_USE_VALGRIND)
    for (p = pool, n = pool->d.next; /* void */; p = n, n = n->d.next) {
        free(p);

        if (n == NULL) {
            break;
        }
    }
#else
    pool->large = NULL;
    free(pool);
#endif
}


SRE_API void
sre_reset_pool(sre_pool_t *pool)
{
#if !(SRE_USE_VALGRIND)
    sre_pool_t        *p;
#else
    sre_pool_large_t  *next = NULL;
#endif
    sre_pool_large_t  *l;

    for (l = pool->large; l; l = l->next) {
        if (l->alloc) {
            free(l->alloc);
        }
    }

#if (SRE_USE_VALGRIND)
    for (l = pool->large; l; l = next) {
        next = l->next;
        free(l);
    }
#endif

    pool->large = NULL;

#if !(SRE_USE_VALGRIND)
    for (p = pool; p; p = p->d.next) {
        p->d.last = (uint8_t *) p + sizeof(sre_pool_t);
    }
#endif
}


void *
sre_palloc(sre_pool_t *pool, size_t size)
{
#if !(SRE_USE_VALGRIND)
    uint8_t     *m;
    sre_pool_t  *p;

    if (size <= pool->max) {

        p = pool->current;

        do {
            m = sre_align_ptr(p->d.last, SRE_ALIGNMENT);

            if ((size_t) (p->d.end - m) >= size) {
                p->d.last = m + size;

                return m;
            }

            p = p->d.next;

        } while (p);

        return sre_palloc_block(pool, size);
    }
#endif

    return sre_palloc_large(pool, size);
}


void *
sre_pnalloc(sre_pool_t *pool, size_t size)
{
#if !(SRE_USE_VALGRIND)
    uint8_t     *m;
    sre_pool_t  *p;

    if (size <= pool->max) {

        p = pool->current;

        do {
            m = p->d.last;

            if ((size_t) (p->d.end - m) >= size) {
                p->d.last = m + size;

                return m;
            }

            p = p->d.next;

        } while (p);

        return sre_palloc_block(pool, size);
    }
#endif

    return sre_palloc_large(pool, size);
}


#if !(SRE_USE_VALGRIND)
static void *
sre_palloc_block(sre_pool_t *pool, size_t size)
{
    uint8_t     *m;
    size_t       psize;
    sre_pool_t  *p, *new, *current;

    psize = (size_t) (pool->d.end - (uint8_t *) pool);

    m = sre_memalign(SRE_POOL_ALIGNMENT, psize);
    if (m == NULL) {
        return NULL;
    }

    new = (sre_pool_t *) m;

    new->d.end = m + psize;
    new->d.next = NULL;
    new->d.failed = 0;

    m += sizeof(sre_pool_data_t);
    m = sre_align_ptr(m, SRE_ALIGNMENT);
    new->d.last = m + size;

    current = pool->current;

    for (p = current; p->d.next; p = p->d.next) {
        if (p->d.failed++ > 4) {
            current = p->d.next;
        }
    }

    p->d.next = new;

    pool->current = current ? current : new;

    return m;
}
#endif


static void *
sre_palloc_large(sre_pool_t *pool, size_t size)
{
    void              *p;
    sre_uint_t         n;
    sre_pool_large_t  *large;

    p = malloc(size);
    if (p == NULL) {
        return NULL;
    }

    n = 0;

    for (large = pool->large; large; large = large->next) {
        if (large->alloc == NULL) {
            large->alloc = p;
            return p;
        }

        if (n++ > 3) {
            break;
        }
    }

#if (SRE_USE_VALGRIND)
    large = malloc(sizeof(sre_pool_large_t));
#else
    large = sre_palloc(pool, sizeof(sre_pool_large_t));
#endif
    if (large == NULL) {
        free(p);
        return NULL;
    }

    large->alloc = p;
    large->next = pool->large;
    pool->large = large;

    return p;
}


int
sre_pfree(sre_pool_t *pool, void *p)
{
    sre_pool_large_t   *l;
#if (SRE_USE_VALGRIND)
    sre_pool_large_t  **next;

    next = &pool->large;
#endif

    for (l = pool->large; l; l = l->next) {
        if (p == l->alloc) {
            free(l->alloc);
            l->alloc = NULL;

#if (SRE_USE_VALGRIND)
            *next = l->next;
            free(l);
#endif
            return SRE_OK;
        }

#if (SRE_USE_VALGRIND)
        next = &l->next;
#endif
    }

    return SRE_DECLINED;
}


void *
sre_pcalloc(sre_pool_t *pool, size_t size)
{
    void *p;

    p = sre_palloc(pool, size);
    if (p != NULL) {
        sre_memzero(p, size);
    }

    return p;
}


sre_pool_cleanup_t *
sre_pool_cleanup_add(sre_pool_t *p, size_t size)
{
    sre_pool_cleanup_t  *c;

    c = sre_palloc(p, sizeof(sre_pool_cleanup_t));
    if (c == NULL) {
        return NULL;
    }

    if (size) {
        c->data = sre_palloc(p, size);
        if (c->data == NULL) {
            return NULL;
        }

    } else {
        c->data = NULL;
    }

    c->handler = NULL;
    c->next = p->cleanup;

    p->cleanup = c;

    return c;
}


#if !(SRE_USE_VALGRIND)
static void *
sre_memalign(size_t alignment, size_t size)
{
    void  *p;
    int    err;

    err = posix_memalign(&p, alignment, size);

    if (err) {
        p = NULL;
    }

    return p;
}
#endif
