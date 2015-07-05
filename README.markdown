Name
====

libsregex - A non-backtracking NFA/DFA-based Perl-compatible regex engine library for matching on large data streams

Table of Contents
=================

* [Name](#name)
* [Status](#status)
* [Syntax Supported](#syntax-supported)
* [API](#api)
    * [Constants](#constants)
    * [Memory pool API](#memory-pool-api)
        * [sre_create_pool](#sre_create_pool)
        * [sre_destroy_pool](#sre_destroy_pool)
        * [sre_reset_pool](#sre_reset_pool)
    * [Regex parsing and compilation API](#regex-parsing-and-compilation-api)
        * [sre_regex_parse](#sre_regex_parse)
        * [sre_regex_parse_multi](#sre_regex_parse_multi)
        * [sre_regex_compile](#sre_regex_compile)
    * [Regex execution API](#regex-execution-api)
        * [Thompson VM](#thompson-vm)
            * [sre_vm_thompson_create_ctx](#sre_vm_thompson_create_ctx)
            * [sre_vm_thompson_exec](#sre_vm_thompson_exec)
            * [Just-In-Time Support for Thompson VM](#just-in-time-support-for-thompson-vm)
                * [sre_vm_thompson_jit_compile](#sre_vm_thompson_jit_compile)
                * [sre_vm_thompson_jit_get_handler](#sre_vm_thompson_jit_get_handler)
                * [sre_vm_thompson_jit_create_ctx](#sre_vm_thompson_jit_create_ctx)
        * [Pike VM](#pike-vm)
            * [sre_vm_pike_create_ctx](#sre_vm_pike_create_ctx)
            * [sre_vm_pike_exec](#sre_vm_pike_exec)
* [Examples](#examples)
* [Installation](#installation)
* [Test Suite](#test-suite)
* [TODO](#todo)
* [Author](#author)
* [Copyright and License](#copyright-and-license)
* [See Also](#see-also)

Status
======

This library is already quite usable and some people are already using it in production.

Nevertheless this library is still under heavy development. The API is still in flux
and may be changed quickly without notice.

This is a pure C library that is designed to have zero dependencies.

No pathological regexes exist for this regex engine because it does not
use a backtracking algorithm at all.

Already rewrote the code base of Russ Cox's re1 library using the nginx coding style (yes, I love it!), also incorporated a clone of the nginx memory pool into it for memory management.

Already ported the Thompson and Pike VM backends to sregex. The former is just for yes-or-no matching, and the latter also supports sub-match capturing.

Implemented the case-insensitive matching mode via the `SRE_REGEX_CASELESS` flag.

The full streaming matching API for the sregex engine has already been implemented,
for both the Pike and Thompson regex VMs. The sub-match capturing also supports streaming processing.
When the state machine is yielded (that is, returning `SRE_AGAIN` on the current input data chunk),
sregex will always output the current value range for the `$&` sub-match capture in the user-supplied
`ovector` array.

Almost all the relevant test cases for PCRE 8.32 and Perl 5.16.2 have been imported into sregex's test suite
and all tests are passing right now.

Already implemented an API for assembling multiple user regexes and
returning an ID indicating exactly which regex is matched
(first), as well as the corresponding sub-match captures.

There is also a Just-in-Time (JIT) compiler targeting x86_64 for the Thompson VM.

Syntax Supported
================

The following Perl 5 regex syntax features have already been implemented.

    ^             match the beginning of lines
    $             match the end of lines

    \A            match only at beginning of stream
    \z            match only at end of stream

    \b            match a word boundary
    \B            match except at a word boundary

    .             match any char
    \C            match a single C-language char (octet)

    [ab0-9]       character classes (positive)
    [^ab0-9]      character classes (negative)

    \d            match a digit character ([0-9])
    \D            match a non-digit character ([^0-9])

    \s            match a whitespace character ([ \f\n\r\t])
    \S            match a non-whitespace character ([^ \f\n\r\t])

    \h            match a horizontal whitespace character
    \H            match a character that isn't horizontal whitespace

    \v            match a vertical whitespace character
    \V            match a character that isn't vertical whitespace

    \w            match a "word" character ([A-Za-z0-9_])
    \W            match a non-"word" character ([^A-Za-z0-9_])

    \cK           control char (example: VT)

    \N            match a character that isn't a newline

    ab            concatenation; first match a, and then b
    a|b           alternation; match a or b

    (a)           capturing parentheses
    (?:a)         non-capturing parantheses

    a?            match 1 or 0 times, greedily
    a*            match 0 or more times, greedily
    a+            match 1 or more times, greedily

    a??           match 1 or 0 times, not greedily
    a*?           match 0 or more times, not greedily
    a+?           match 1 or more times, not greedily

    a{n}          match exactly n times
    a{n,m}        match at least n but not more than m times, greedily
    a{n,}         match at least n times, greedily

    a{n}?         match exactly n times, not greedily (redundant)
    a{n,m}?       match at least n but not more than m times, not greedily
    a{n,}?        match at least n times, not greedily

The following escaping sequences are supported:

    \t          tab
    \n          newline
    \r          return
    \f          form feed
    \a          alarm
    \e          escape
    \b          backspace (in character class only)
    \x{}, \x00  character whose ordinal is the given hexadecimal number
    \o{}, \000  character whose ordinal is the given octal number

Escaping a regex meta character yields the literal character itself, like `\{` and `\.`.

Only the octet mode is supported; no multi-byte character encoding love (yet).

API
===

This library provides a pure C API. This API is still in flux and may change in the near future
without notice.

[Back to TOC](#table-of-contents)

Constants
---------

This library provides the following public constants for use in the various API functions.

* `SRE_OK`
* `SRE_DECLINED`
* `SRE_AGAIN`
* `SRE_ERROR`

The actual meanings of these constants depend on the concrete API functions using them.

[Back to TOC](#table-of-contents)

Memory pool API
---------------

This library utilizes a memory pool to simplify memory management. Most of the low-level API
functions provided by this library does accept a memory pool pointer as an argument.

The operations on the memory pool on the user side are limited to

1. creating a memory pool,
2. destroying a memory pool, and
3. resetting a memory pool.

[Back to TOC](#table-of-contents)

### sre_create_pool

```C
sre_pool_t *sre_create_pool(size_t size);
```

Creates a memory pool with a page size of `size`. Returns the pool as an opaque pointer type `sre_pool_t`.

Usually the page size you specify should not be too large. Usually 1KB or 4KB should be sufficient.
Optimal values depend on your actual regexes and input data pattern involved and should be
tuned empirically.

The returned memory pool pointer is usually fed into other API functions provided by this library
as an argument.

It is your responsibility to destroy the pool when you no longer need it via the [sre_destroy_pool](#sre_destroy_pool) function. Failing to destroy the pool will result in memory leaks.

[Back to TOC](#table-of-contents)

### sre_destroy_pool

```C
void sre_destroy_pool(sre_pool_t *pool);
```

Destroys the memory pool created by the [sre_create_pool](#sre_create_pool) function.

[Back to TOC](#table-of-contents)

### sre_reset_pool

```C
void sre_reset_pool(sre_pool_t *pool);
```

[Back to TOC](#table-of-contents)

Regex parsing and compilation API
---------------------------------

Before running a regex (or set of multiple regexes), you need to parse and compile them first, such that
you can run the compiled form of the regex(es) over and over again at maximum speed.

[Back to TOC](#table-of-contents)

### sre_regex_parse

```C
typedef uint8_t     sre_char;
typedef uintptr_t   sre_uint_t;
typedef intptr_t    sre_int_t;

sre_regex_t *sre_regex_parse(sre_pool_t *pool, sre_char *regex,
    sre_uint_t *ncaps, int flags, sre_int_t *err_offset);
```

Parses the string representation of the user regex specified by the `regex` parameter (as a null-terminated string).

Returns a parsed regex object of the opaque pointer type `sre_regex_t` if no error happens. Otherwise returns a NULL pointer and set the offset in the `regex` string where the parse failure happens.

The parsed regex object pointer is an Abstract-Syntax-Tree (AST) representation of the string regex.
It can later be fed into API function calls like [sre_regex_compile](#sre_regex_compile) as an argument.

The first parameter, `pool`, is a memory pool created by the [sre_create_pool](#sre_create_pool) API function.

The `ncaps` parameter is used to output the number of sub-match captures found in the regex. This integer can later be used to extract sub-match captures.

The `flags` parameter specifies additional regex compiling flags like below:

* `SRE_REGEX_CASELESS`
    case-insensitive matching mode.

[Back to TOC](#table-of-contents)

### sre_regex_parse_multi

```C
typedef uint8_t     sre_char;
typedef uintptr_t   sre_uint_t;
typedef intptr_t    sre_int_t;

sre_regex_t *sre_regex_parse_multi(sre_pool_t *pool, sre_char **regexes,
    sre_int_t nregexes, sre_uint_t *max_ncaps, int *multi_flags,
    sre_int_t *err_offset, sre_int_t *err_regex_id);
```

Similar to the [sre_regex_parse](#sre_regex_parse) API function but works on multiple
regexes at once.

These regexes are specified by the C string array `regexes`, whose size is determined by the `nregexes` parameter.

All these input regexes are combined into a single parsed regex object, returned as the opaque
pointer of the type `sre_regex_t`, just like [sre_regex_parse](#sre_regex_parse). These regexes are
logically connected via the alternative regex operator (`|`), so the order of these regexes determine
their relative precedence in a tie. Despite of being connected by `|` logically, the
[regex execution API](#regex-execution-api) can still signify which of these regexes is matched
by returning the regex ID which is the offset of the regex in the `regexes` input array.

Upon failures, returns the NULL pointer and sets

* the output parameter `err_regex_id` for the number of regex having syntax errors
(i.e., the 0-based offset of the regex in the `regexes` input parameter array), and
* the output parameter `err_offset` for the string offset in the guilty regex where the failure happens.

The output parameter `max_ncaps` returns the maximum number of sub-match captures in all these regexes.
Note that, this is is the maximum instead of the sum.

The `multi_flags` is an input array consisting of the regex flags for every regex specified in the `regexes` array.
The size of this array must be no shorter than the size specified by `nregexes`. For what
regex flags you can use, just check out the documentation for the [sre_regex_parse](#sre_regex_parse) API function.

[Back to TOC](#table-of-contents)

### sre_regex_compile

```C
sre_program_t *sre_regex_compile(sre_pool_t *pool, sre_regex_t *re);
```

Compiles the parsed regex object (returned by [sre_regex_parse](#sre_regex_parse)) into a bytecode
representation of the regex, of the opaque pointer type `sre_program_t`.

Returns the NULL pointer in case of failures.

The memory pool specified by the `pool` parameter does not have to be the same as the one used
by the earlier [sre_regex_parse](#sre_regex_parse) call. But you could use the same memory pool if you want.

The compiled regex form (or bytecode form) returned can be fed into one of the regex backend VMs
provided by this library for execution. See [regex execution API](#regex-execution-api) for more
details.

[Back to TOC](#table-of-contents)

Regex execution API
-------------------

The regex execution API provides various different virtual machines (VMs) for running
the compiled regexes by different algorithms.

Currently the following VMs are supported:

* [Thompson VM](#thompson-vm)
* [Pike VM](#pike-vm)

[Back to TOC](#table-of-contents)

### Thompson VM

The Thompson VM uses the Thompson NFA simulation algorithm to execute the compiled regex(es) by
matching against an input string (or input stream).

[Back to TOC](#table-of-contents)

#### sre_vm_thompson_create_ctx

```C
sre_vm_thompson_ctx_t *sre_vm_thompson_create_ctx(sre_pool_t *pool,
    sre_program_t *prog);
```

Creates and returns a context structure (of the opaque type `sre_vm_thompson_ctx_t`) for
the Thompson VM. Returns NULL in case of failure (like running out of memory).

This return value can later be used by the [sre_vm_thompson_exec](#sre_vm_thompson_exec) function as an argument.

The `prog` parameter accepts the compiled bytecode form of the regex(es) returned by the [sre_regex_compile](#sre_regex_compile)
function. This compiled regex(es) is embedded into the resulting context structure.

Accepts a memory pool created by the [sre_create_pool](#sre_create_pool) function as the first argument. This memory pool does not have to be the same as the pool used for parsing or compiling the regex(es).

[Back to TOC](#table-of-contents)

#### sre_vm_thompson_exec

```C
typedef intptr_t    sre_int_t;
typedef uint8_t     sre_char;

sre_int_t sre_vm_thompson_exec(sre_vm_thompson_ctx_t *ctx, sre_char *input,
    size_t size, unsigned int eof);
```

Executes the compiled regex(es) on the input string data atop the Thompson VM (without Just-In-Time optimizations).

The `ctx` argument value is returned by the [sre_vm_thompson_create_ctx](#sre_vm_thompson_create_ctx)
function. The compiled (bytecode) form of the regex(es) are already embedded in this `ctx` value.
This `ctx` argument can be changed by this function call and must be preserved for all the `sre_vm_thompson_exec` calls
on the same data stream. Different data streams MUST use different `ctx` instances. When a data stream is completely processed, the corresponding `ctx` instance MUST be discarded and cannot be reused again.

The input data is specified by a character data chunk in a data stream. The `input` parameter specifies the starting address of the data
chunk, the `size` parameter specifies the size of the chunk, while the `eof` parameter identifies
whether this chunk is the last chunk in the stream. If you just want to match on a single
C string, then always specify 1 as the `eof` argument and exclude the NULL string terminator in your C string while computing the `size` argument value.

This function may return one of the following values:

* `SRE_OK`
    A match is found.
* `SRE_DECLINED`
    No match can be found. This value can never be returned when the `eof` parameter is unset (because
    a match MAY get found when seeing more input string data).
* `SRE_AGAIN`
    More data (in a subsequent call) is needed to obtain a match. The current data chunk can
    be discarded after this call returns. This value can only be returned when the `eof` parameter is
    not set.
* `SRE_ERROR`
    A fatal error has occurred (like running out of memory).

This function does not return the regex ID of the matched regex when multiple regexes are
specified at once via the [sre_regex_parse_multi](#sre_regex_parse_multi) function is used. This
may change in the future.

Sub-match captures are not supported in this Thompson VM by design. You should use the [Pike VM](#pike-vm) instead if you want that.

[Back to TOC](#table-of-contents)

#### Just-In-Time Support for Thompson VM

The Thompson VM comes with a Just-In-Time compiler. Currently only the x86_64 architecture is supported.
Support for other architectures may come in the future.

[Back to TOC](#table-of-contents)

##### sre_vm_thompson_jit_compile

```C
typedef intptr_t    sre_int_t;

sre_int_t sre_vm_thompson_jit_compile(sre_pool_t *pool, sre_program_t *prog,
    sre_vm_thompson_code_t **pcode);
```

Compiles the bytecode form of the regex(es) created by [sre_regex_compile](#sre_regex_compile)
down into native code.

It returns one of the following values:

* `SRE_OK`
    Compilation is successful.
* `SRE_DECLINED`
    The current architecture is not supported.
* `SRE_ERROR`
    A fatal error occurs (like running out of memory).

The `pool` parameter specifies a memory pool created by [sre_create_pool](#sre_create_pool).
This pool is used for the JIT compilation.

The `prog` parameter is the compiled bytecode form of the regex(es) created by the [sre_regex_compile](#sre_regex_compile)
function call.

The resulting JIT compiled native code along with the runtime information is saved in the output
argument `pcode` of the opaque type `sre_vm_thompson_code_t`. This structure is allocated by this
function in the provided memory pool.

This `sre_vm_thompson_code_t` object can later be executed by running the C function pointer
fetched from this object via the [sre_vm_thompson_jit_get_handler](#sre_vm_thompson_jit_get_handler) call.

[Back to TOC](#table-of-contents)

##### sre_vm_thompson_jit_get_handler

```C
typedef uint8_t     sre_char;
typedef intptr_t    sre_int_t;
typedef sre_int_t (*sre_vm_thompson_exec_pt)(sre_vm_thompson_ctx_t *ctx,
    sre_char *input, size_t size, unsigned int eof);

sre_vm_thompson_exec_pt sre_vm_thompson_jit_get_handler(
    sre_vm_thompson_code_t *code);
```

Fetches a C function pointer from the JIT compiled form of the regex(es) generated via an
earlier [sre_vm_thompson_jit_compile](#sre_vm_thompson_jit_compile).

The C function pointer is of the exactly same function prototype of the interpreter entry
function [sre_vm_thompson_exec](#sre_vm_thompson_exec). The only difference is that the
`sre_vm_thompson_ctx_t` object MUST be created via the [sre_vm_thompson_jit_create_ctx](#sre_vm_thompson_jit_create_ctx)
function instead of the [sre_vm_thompson_create_ctx](#sre_vm_thompson_create_ctx) function. Despite that, the resulting C function pointer can be used as the same way as [sre_vm_thompson_exec](#sre_vm_thompson_exec).

[Back to TOC](#table-of-contents)

##### sre_vm_thompson_jit_create_ctx

```C
sre_vm_thompson_ctx_t *sre_vm_thompson_jit_create_ctx(sre_pool_t *pool,
    sre_program_t *prog);
```

Allocates a context structure for executing the compiled native code form of the regex(s) generated
by the Just-In-Time compiler of the Thompson VM.

This context object should only be used by the C function returned by the [sre_vm_thompson_jit_get_handler](#sre_vm_thompson_jit_get_handler)
function call. Use of this object in [sre_vm_thompson_exec](#sre_vm_thompson_exec) is prohibited.

[Back to TOC](#table-of-contents)

### Pike VM

The Pike VM uses an enhanced version of the Thompson NFA simulation algorithm that supports sub-match
captures.

[Back to TOC](#table-of-contents)

#### sre_vm_pike_create_ctx

```C
typedef intptr_t    sre_int_t;

sre_vm_pike_ctx_t *sre_vm_pike_create_ctx(sre_pool_t *pool, sre_program_t *prog,
    sre_int_t *ovector, size_t ovecsize);
```

Creates and returns a context structure (of the opaque type `sre_vm_pike_ctx_t`) for the
Pike VM. Returns NULL in case of failure (like running out of memory).

This return value can later be used by the [sre_vm_pike_exec](#sre_vm_pike_exec) function as an argument.

The `prog` parameter accepts the compiled bytecode form of the regex(es) returned by the [sre_regex_compile](#sre_regex_compile)
function. This compiled regex(es) is embedded into the resulting context structure.

Accepts a memory pool created by the [sre_create_pool](#sre_create_pool) function as the first argument. This memory pool does not have to be the same as the pool used for parsing or compiling the regex(es).

The `ovector` parameter specifies an array for outputting the beginning and end offsets of the (sub-)match captures.
The elements of the array are used like below:

1. The 1st element of the array holds the beginning offset of the whole match,
2. the 2nd element holds the end offset of the whole match,
3. the 3rd element holds the beginning offset of the 1st sub-match capture,
4. the 4th element holds the end offset of the 1st sub-match capture,
5. the 5rd element holds the beginning offset of the 2st sub-match capture,
6. the 6th element holds the end offset of the 2st sub-match capture,
7. and so on...

The size of the `ovector` array is specified by the `ovecsize` parameter, in bytes. The size of the array
can be computed as follows:

```
    ovecsize = 2 * (ncaps + 1) * sizeof(sre_int_t)
```

where `ncaps` is the value previously output by the [sre_regex_parse](#sre_regex_parse) 
or [sre_regex_parse_multi](#sre_regex_parse_multi) function.

The `ovector` array is allocated by the caller and filled by this function call.

[Back to TOC](#table-of-contents)

#### sre_vm_pike_exec

```C
typedef uint8_t     sre_char;
typedef intptr_t    sre_int_t;

sre_int_t sre_vm_pike_exec(sre_vm_pike_ctx_t *ctx, sre_char *input, size_t size,
    unsigned eof, sre_int_t **pending_matched);
```

Executes the compiled regex(es) on the input string data atop the Pike VM (without Just-In-Time optimizations).

The `ctx` argument value is returned by the [sre_vm_pike_create_ctx](#sre_vm_pike_create_ctx)
function. The compiled (bytecode) form of the regex(es) are already embedded in this `ctx` value.
This `ctx` argument can be changed by this function call and must be preserved for all the `sre_vm_pike_exec` calls
on the same data stream. Different data streams MUST use different `ctx` instances. When a data stream is completely processed, the corresponding `ctx` instance MUST be discarded and cannot be reused again.

The input data is specified by a character data chunk in a data stream. The `input` parameter specifies the starting address of the data
chunk, the `size` parameter specifies the size of the chunk, while the `eof` parameter identifies
whether this chunk is the last chunk in the stream. If you just want to match on a single
C string, then always specify 1 as the `eof` argument and exclude the NULL string terminator in your C string while computing the `size` argument value.

The `pending_matched` parameter outputs an array holding all the pending matched captures (whole-match only, no sub-matches) if
no complete matches have been found yet (i.e., this call returns `SRE_AGAIN`).
This is very useful for doing regex substitutions on (large) data streams where the caller
can use the info in `pending_matched` to decide exactly how much data in the current to-be-thrown data chunk needs to be buffered.
The caller should never allocate the space for this array, rather,
this function call takes care of it and just sets the (double) pointer to point to its internal (read-only) storage.

This function may return one of the following values:

* a non-negative value
    A match is found and the value is the ID of the (first) matched regex if multiple regexes are
    parsed at once via the [sre_regex_parse_multi](#sre_regex_parse_multi) function. A regex ID
    is the 0-based index of the corresponding regex in the regexes array fed into the [sre_regex_parse_multi](#sre_regex_parse_multi)
    function.
* `SRE_DECLINED`
    No match can be found. This value can never be returned when the `eof` parameter is unset (because
    a match MAY get found when seeing more input string data).
* `SRE_AGAIN`
    More data (in a subsequent call) is needed to obtain a match. The current data chunk can
    be discarded after this call returns. This value can only be returned when the `eof` parameter is
    not set.
* `SRE_ERROR`
    A fatal error has occurred (like running out of memory).

[Back to TOC](#table-of-contents)

Examples
========

Please check out the sregex-cli command-line utility's source for usage:

https://github.com/agentzh/sregex/blob/master/src/sre_cli.c#L1

The `sregex-cli` command-line interface can be used as a convenient way to exercise the engine:

    ./sregex-cli 'a|ab' 'blab'

It also supports the `--flags` option which can be used to enable case-insensitive matching:

    ./sregex-cli --flags i 'A|AB' 'blab'

And also the `--stdin` option for reading data chunks from stdin:

    # one single data chunk to be matched:
    perl -e '$s="foobar";print length($s),"\n$s"' \
        | ./sregex-cli --stdin foo

    # 3 data chunks (forming a single input stream) to be matched:
    perl -e '$s="foobar";print length($s),"\n$s" for 1..3' \
        | sregex-cli --stdin foo

A real-world application of this library is the ngx_replace_filter module:

https://github.com/agentzh/replace-filter-nginx-module

[Back to TOC](#table-of-contents)

Installation
============

    make
    make install

Gnu make and gcc are required. (On operating systems like FreeBSD and Solaris, you should type `gmake` instead of `make` here.)

It will build `libsregex.so` (or `libsregex.dylib` on Mac OS X), `libsregex.a`, and the command-line utility `sregex-cli` and install
    them into the prefix `/usr/local/` by default.

If you want to install into a custom location, then just specify the `PREFIX` variable like this:

    make PREFIX=/opt/sregex
    make install PREFIX=/opt/sregex

If you are building a binary package (like an RPM package), then
you will find the `DESTDIR` variable handy, as in

    make PREFIX=/opt/sregex
    make install PREFIX=/opt/sregex DESTDIR=/path/to/my/build/root

If you run `make distclean` before `make`, then you also need bison 2.7+
for generating the regex parser files.

[Back to TOC](#table-of-contents)

Test Suite
==========

The test suite is driven by Perl 5.

To run the test suite

    make test

Gnu make, perl 5.16.2, and the following Perl CPAN modules are required:

* Cwd
* IPC::Run3
* Test::Base
* Test::LongString

If you already have `perl` installed in your system, you can use the following
command to install these CPAN modules (you may need to run it using `root`):

    cpan Cwd IPC::Run3 Test::Base Test::LongString

You can also run the test suite using the Valgrind Memcheck tool to check
memory issues in sregex:

    make valtest

Because we have a huge test suite, to run the test suite in parallel, you can specify
the parallelism level with the `jobs` `make` variable, as in

    make test jobs=8

or similarly

    make valtest jobs=8

So the test suite will run in 8 parallel jobs (assuming you have 8 CPU cores).

The streaming matching API is much more thoroughly excerised by the test suite of
the [ngx_replace_filter](https://github.com/agentzh/replace-filter-nginx-module) module.

[Back to TOC](#table-of-contents)

TODO
====

* implement the `(?i)` and `(?-i)` regex syntax.
* implement a simplified version of the backreferences.
* implement the comment notation `(?#comment)`.
* implement the POSIX character class notation.
* allow '\0' be used in both the regex and the subject string.
* add a bytecode optimizer to the regex VM (which also generates minimized DFAs for the Thompson VM).
* add a JIT compiler for the Pike VM targeting x86_64.
* port the existing x86_64 JIT compiler for the Thompson VM to other architectures like i386.
* implement the generalized look-around assertions like `(?=pattern)`, `(?!pattern)`, `(?<=pattern)`, and `(?<!pattern)`.
* implement the UTF-8, GBK, and Latin1 matching mode.

[Back to TOC](#table-of-contents)

Author
======

Yichun "agentzh" Zhang (章亦春) <agentzh@gmail.com>, CloudFlare Inc.

[Back to TOC](#table-of-contents)

Copyright and License
=====================

Part of this code is from the NGINX open source project: http://nginx.org/LICENSE

This library is licensed under the BSD license.

Copyright (C) 2012-2015, by Yichun "agentzh" Zhang (章亦春), CloudFlare Inc.

Copyright (C) 2007-2009 Russ Cox, Google Inc. All rights reserved.

All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

* Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.

* Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
* Neither the name of Google, Inc. nor the names of its contributors may be used to endorse or promote products derived from
this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

[Back to TOC](#table-of-contents)

See Also
========
* Slides for my talk "sregex: matching Perl 5 regexes on data streams": http://agentzh.org/misc/slides/yapc-na-2013-sregex.pdf
* The ngx_replace_filter module: https://github.com/agentzh/replace-filter-nginx-module
* "Implementing Regular Expressions" http://swtch.com/~rsc/regexp/
* The re1 project: http://code.google.com/p/re1/
* The re2 project: http://code.google.com/p/re2/

[Back to TOC](#table-of-contents)
