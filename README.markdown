Name
====

SRegex - A non-backtracking regex engine matching on data streams

Status
======

This library is *not* usable yet and still under early development.

Already rewrote the code base of Russ Cox's re1 library using the nginx coding style (yes, I love it!), also incorparated a clone of the nginx memory pool into it for memory management.

Already ported the Thompson VM and Pike VM to sregex. The former is just for yes-or-no matching, and the latter also supports submatch capturing.

At the moment, I haven't added support for streaming matching to the API, but this should be easy.

Things to do:

1. add an API for streaming processing,
1. add more and more regex features like character classes and shortcuts like `\d`, `\w`, `\s`, along the way, so that I'll be able to start running Perl 5's regex test suite,
1. add a bytecode optimizer to the regex VM (which also generates minimized DFAs for the Thompson VM), and
1. add a JIT compiler for the regex VM targeting x86_64 (and other architectures).

Build
=====

    make

Usage
=====

There is no ABI for the library yet.

There's a simple executable that can be used to exercise the engine:

    $ ./sregex 'a|ab' 'blab'

where Gnu make and gcc are required.

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

