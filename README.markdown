Name
====

libsregex - A non-backtracking regex engine library for large data streams

Status
======

This library is already quite usable but still under early development. The API is still in flux
and may be changed quickly without notice.

This is a pure C library that is designed to have zero dependencies.

No pathological regexes exist for this regex engine because it does not
use a backtracking algorithm at all.

Already rewrote the code base of Russ Cox's re1 library using the nginx coding style (yes, I love it!), also incorparated a clone of the nginx memory pool into it for memory management.

Already ported the Thompson and Pike VM backends to sregex. The former is just for yes-or-no matching, and the latter also supports submatch capturing.

Implemented the case-insensitive matching mode via the `SRE_REGEX_CASELESS` flag.

The full streaming matching API for the sregex engine has already been implemented,
for both the Pike and Thompson regex VMs. The submatch capturing also supports streaming processing.
When the state machine is yielded (that is, returning `SRE_AGAIN` on the current input data chunk),
sregex will always output the current value range for the `$&` submatch capture in the user-supplied
`ovector` array.

Almost all the relevant test cases for PCRE 8.32 and Perl 5.16.2 have been imported into sregex's test suite
and all tests are passing right now.

Already implemtend an API for assembling multiple user regexes and
returning an ID indicating exactly which regex is matched
(first), as well as the corresponding submatch captures.

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

Installation
============

    make
    make install

Gnu make and gcc are required. (On operating systems like FreeBSD and Solaris, you should type `gmake` instead of `make` here.)

It will build `libsregex.so`, `libsregex.a`, and the command-line utility `sregex-cli` and install
them into the prefix `/usr/local/` by default.

If you want to install into a custom location, then just specify the `PREFIX` variable like this:

    make PREFIX=/opt/sregex
    make install PREFIX=/opt/sregex

If you are building a binary package (like an RPM package), then
you will find the `DESTDIR` variable handy, as in

    make PREFIX=/opt/sregex
    make install PREFIX=/opt/sregex DESTDIR=/path/to/my/build/root

Usage
=====

There is no formal API nor ABI for the library yet. Please check out the sregex-cli
command-line utility's source for usage:

https://github.com/agentzh/sregex/blob/master/src/sre_cli.c#L1

The `sregex-cli` command-line interface can be used as a convenient way to exercise the engine:

    ./sregex-cli 'a|ab' 'blab'

It also supports the `--flags` option which can be used to enable case-insensitive matching:

    ./sregex-cli --flags i 'A|AB' 'blab'

A real-world application of this library is the ngx_replace_filter module:

https://github.com/agentzh/replace-filter-nginx-module

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

Author
======

Yichun "agentzh" Zhang (章亦春) <agentzh@gmail.com>, CloudFlare.

Copyright and License
=====================

This module is licensed under the BSD license.

Copyright (C) 2012, 2013, by Yichun "agentzh" Zhang (章亦春), CloudFlare.

Copyright (C) 2007-2009 Russ Cox, Google Inc. All rights reserved.

All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

* Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.

* Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
* Neither the name of Google, Inc. nor the names of its contributors may be used to endorse or promote products derived from
this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

See Also
========
* the ngx_replace_filter module: https://github.com/agentzh/replace-filter-nginx-module
* "Implementing Regular Expressions" http://swtch.com/~rsc/regexp/
* the re1 project: http://code.google.com/p/re1/
* the re2 project: http://code.google.com/p/re2/

