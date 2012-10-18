
/*
 * Copyright (C) Igor Sysoev
 * Copyright (C) Nginx, Inc.
 */


#include <sre_palloc.h>


static void *sre_palloc_block(sre_pool_t *pool, size_t size);
static void *sre_palloc_large(sre_pool_t *pool, size_t size);
static void * sre_memalign(size_t alignment, size_t size);


sre_pool_t *
sre_create_pool(size_t size)
{
    sre_pool_t  *p;

    p = sre_memalign(SRE_POOL_ALIGNMENT, size);
    if (p == NULL) {
        return NULL;
    }

    p->d.last = (u_char *) p + sizeof(sre_pool_t);
    p->d.end = (u_char *) p + size;
    p->d.next = NULL;
    p->d.failed = 0;

    size = size - sizeof(sre_pool_t);
    p->max = (size < SRE_MAX_ALLOC_FROM_POOL) ? size : SRE_MAX_ALLOC_FROM_POOL;

    p->current = p;
    p->large = NULL;
    p->cleanup = NULL;

    return p;
}


void
sre_destroy_pool(sre_pool_t *pool)
{
    sre_pool_t          *p, *n;
    sre_pool_large_t    *l;
    sre_pool_cleanup_t  *c;

    for (c = pool->cleanup; c; c = c->next) {
        if (c->handler) {
            c->handler(c->data);
        }
    }

    for (l = pool->large; l; l = l->next) {
        if (l->alloc) {
            free(l->alloc);
        }
    }

    for (p = pool, n = pool->d.next; /* void */; p = n, n = n->d.next) {
        free(p);

        if (n == NULL) {
            break;
        }
    }
}


void
sre_reset_pool(sre_pool_t *pool)
{
    sre_pool_t        *p;
    sre_pool_large_t  *l;

    for (l = pool->large; l; l = l->next) {
        if (l->alloc) {
            free(l->alloc);
        }
    }

    pool->large = NULL;

    for (p = pool; p; p = p->d.next) {
        p->d.last = (u_char *) p + sizeof(sre_pool_t);
    }
}


void *
sre_palloc(sre_pool_t *pool, size_t size)
{
    u_char      *m;
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

    return sre_palloc_large(pool, size);
}


void *
sre_pnalloc(sre_pool_t *pool, size_t size)
{
    u_char      *m;
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

    return sre_palloc_large(pool, size);
}


static void *
sre_palloc_block(sre_pool_t *pool, size_t size)
{
    u_char      *m;
    size_t       psize;
    sre_pool_t  *p, *new, *current;

    psize = (size_t) (pool->d.end - (u_char *) pool);

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


static void *
sre_palloc_large(sre_pool_t *pool, size_t size)
{
    void              *p;
    unsigned           n;
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

    large = sre_palloc(pool, sizeof(sre_pool_large_t));
    if (large == NULL) {
        free(p);
        return NULL;
    }

    large->alloc = p;
    large->next = pool->large;
    pool->large = large;

    return p;
}


void *
sre_pmemalign(sre_pool_t *pool, size_t size, size_t alignment)
{
    void              *p;
    sre_pool_large_t  *large;

    p = sre_memalign(alignment, size);
    if (p == NULL) {
        return NULL;
    }

    large = sre_palloc(pool, sizeof(sre_pool_large_t));
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
    sre_pool_large_t  *l;

    for (l = pool->large; l; l = l->next) {
        if (p == l->alloc) {
            free(l->alloc);
            l->alloc = NULL;

            return SRE_OK;
        }
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

