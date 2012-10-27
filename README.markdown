Name
====

libsregex - A non-backtracking regex engine library for large data streams

Status
======

This library is *not* usable yet and still under early development.

This is a pure C library.

Already rewrote the code base of Russ Cox's re1 library using the nginx coding style (yes, I love it!), also incorparated a clone of the nginx memory pool into it for memory management.

Already ported the Thompson and Pike VM backends to sregex. The former is just for yes-or-no matching, and the latter also supports submatch capturing.

At the moment, I haven't added support for streaming matching to the API, but this should be easy.

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

    [ab0-9]       character classes (positive)
    [^ab0-9]      character classes (negative)

    \d            match a digit character ([0-9])
    \D            match a non-digit character ([^0-9])

    \s            match a whitespace character ([ \f\n\r\t])
    \S            match a non-whitespace character ([^ \f\n\r\t])

    \w            match a "word" character ([A-Za-z0-9_])
    \W            match a non-"word" character ([^A-Za-z0-9_])

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

Escaping a regex meta character yields the literal character itself, like `\{` and `\.`.

Only the octet mode is supported; no multi-byte character encoding love (yet).

Build
=====

    make

Gnu make and gcc are required.

Usage
=====

There is no proper API nor ABI for the library yet.

There's a simple executable that can be used to exercise the engine:

    $ ./sregex 'a|ab' 'blab'

Test Suite
==========

The test suite is driven by Perl.

    make test

Gnu make, perl 5.6.1+, and the Test::Base perl module are required.


TODO
====

1. implement more escaping sequences like `\x{}`, `\x00`, `\o{}`, and `\000`.
1. add an API for streaming processing.
1. add an API for assembling multiple user regexes and return an ID indicating exactly which regex is matched (first), as well as the corresponding submatch captures.
1. add a bytecode optimizer to the regex VM (which also generates minimized DFAs for the Thompson VM).
1. add a JIT compiler for the regex VM targeting x86_64 (and other architectures).
1. implement generalized look-around assertions like `(?=pattern)`, `(?!pattern)`, `(?<=pattern)`, and `(?<!pattern)`.

Author
======

Yichun "agentzh" Zhang (章亦春) <agentzh@gmail.com>

Copyright and License
=====================

This module is licensed under the BSD license.

Copyright (C) 2012, by Yichun "agentzh" Zhang (章亦春) <agentzh@gmail.com>.

Copyright (c) 2007-2009 Russ Cox, Google Inc. All rights reserved.

All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

* Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.

* Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
* Neither the name of Google, Inc. nor the names of its contributors may be used to endorse or promote products derived from
this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

See Also
========
* "Implementing Regular Expressions" http://swtch.com/~rsc/regexp/
* the re1 project: http://code.google.com/p/re1/
* the re2 project: http://code.google.com/p/re2/

