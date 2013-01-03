# vim:set ft= ts=4 sw=4 et fdm=marker:

use t::SRegex 'no_plan';

run_tests();

__DATA__

=== TEST 1: re_tests:154
--- re: a[\S]b
--- s eval: "a b"



=== TEST 2: re_tests:155
--- re: a[\S]b
--- s eval: "a-b"



=== TEST 3: re_tests:156
--- re: [\d]
--- s eval: "1"



=== TEST 4: re_tests:157
--- re: [\d]
--- s eval: "-"



=== TEST 5: re_tests:158
--- re: [\D]
--- s eval: "1"



=== TEST 6: re_tests:159
--- re: [\D]
--- s eval: "-"



=== TEST 7: re_tests:160
--- re: ab|cd
--- s eval: "abc"



=== TEST 8: re_tests:161
--- re: ab|cd
--- s eval: "abcd"



=== TEST 9: re_tests:162
--- re: ()ef
--- s eval: "def"



=== TEST 10: re_tests:167
--- re: *a
--- s eval: "-"
--- err_like: ^\[error\] syntax error at pos \d+$



=== TEST 11: re_tests:168
--- re: (|*)b
--- s eval: "-"
--- err_like: ^\[error\] syntax error at pos \d+$



=== TEST 12: re_tests:169
--- re: (*)b
--- s eval: "-"
--- err_like: ^\[error\] syntax error at pos \d+$



=== TEST 13: re_tests:170
--- re: $b
--- s eval: "b"



=== TEST 14: re_tests:171
--- re: a\
--- s eval: "-"
--- err_like: ^\[error\] syntax error at pos \d+$



=== TEST 15: re_tests:172
--- re: a\(b
--- s eval: "a(b"



=== TEST 16: re_tests:173
--- re: a\(*b
--- s eval: "ab"



=== TEST 17: re_tests:174
--- re: a\(*b
--- s eval: "a((b"



=== TEST 18: re_tests:175
--- re: a\\b
--- s eval: "a\\b"



=== TEST 19: re_tests:176
--- re: abc)
--- s eval: "-"
--- err_like: ^\[error\] syntax error at pos \d+$



=== TEST 20: re_tests:177
--- re: (abc
--- s eval: "-"
--- err_like: ^\[error\] syntax error at pos \d+$



=== TEST 21: re_tests:178
--- re: ((a))
--- s eval: "abc"



=== TEST 22: re_tests:183
--- re: (a)b(c)
--- s eval: "abc"



=== TEST 23: re_tests:186
--- re: a+b+c
--- s eval: "aabbabc"



=== TEST 24: re_tests:187
--- re: a{1,}b{1,}c
--- s eval: "aabbabc"



=== TEST 25: re_tests:188
--- re: a**
--- s eval: "-"
--- err_like: ^\[error\] syntax error at pos \d+$



=== TEST 26: re_tests:189
--- re: a.+?c
--- s eval: "abcabc"



=== TEST 27: re_tests:190
--- re: (a+|b)*
--- s eval: "ab"



=== TEST 28: re_tests:195
--- re: (a+|b){0,}
--- s eval: "ab"



=== TEST 29: re_tests:196
--- re: (a+|b)+
--- s eval: "ab"



=== TEST 30: re_tests:197
--- re: (a+|b){1,}
--- s eval: "ab"



=== TEST 31: re_tests:198
--- re: (a+|b)?
--- s eval: "ab"



=== TEST 32: re_tests:199
--- re: (a+|b){0,1}
--- s eval: "ab"



=== TEST 33: re_tests:200
--- re: )(
--- s eval: "-"
--- err_like: ^\[error\] syntax error at pos \d+$



=== TEST 34: re_tests:201
--- re: [^ab]*
--- s eval: "cde"



=== TEST 35: re_tests:202
--- re: abc
--- s eval: ""



=== TEST 36: re_tests:203
--- re: a*
--- s eval: ""



=== TEST 37: re_tests:204
--- re: ([abc])*d
--- s eval: "abbbcd"



=== TEST 38: re_tests:205
--- re: ([abc])*bcd
--- s eval: "abcd"



=== TEST 39: re_tests:206
--- re: a|b|c|d|e
--- s eval: "e"



=== TEST 40: re_tests:207
--- re: (a|b|c|d|e)f
--- s eval: "ef"



=== TEST 41: re_tests:212
--- re: abcd*efg
--- s eval: "abcdefg"



=== TEST 42: re_tests:213
--- re: ab*
--- s eval: "xabyabbbz"



=== TEST 43: re_tests:214
--- re: ab*
--- s eval: "xayabbbz"



=== TEST 44: re_tests:215
--- re: (ab|cd)e
--- s eval: "abcde"



=== TEST 45: re_tests:216
--- re: [abhgefdc]ij
--- s eval: "hij"



=== TEST 46: re_tests:217
--- re: ^(ab|cd)e
--- s eval: "abcde"



=== TEST 47: re_tests:218
--- re: (abc|)ef
--- s eval: "abcdef"



=== TEST 48: re_tests:219
--- re: (a|b)c*d
--- s eval: "abcd"



=== TEST 49: re_tests:220
--- re: (ab|ab*)bc
--- s eval: "abc"



=== TEST 50: re_tests:221
--- re: a([bc]*)c*
--- s eval: "abc"



