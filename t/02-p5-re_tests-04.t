# vim:set ft= ts=4 sw=4 et fdm=marker:

use t::SRegex 'no_plan';

run_tests();

__DATA__

=== TEST 1: re_tests:222
--- re: a([bc]*)(c*d)
--- s eval: "abcd"



=== TEST 2: re_tests:229
--- re: a([bc]+)(c*d)
--- s eval: "abcd"



=== TEST 3: re_tests:230
--- re: a([bc]*)(c+d)
--- s eval: "abcd"



=== TEST 4: re_tests:237
--- re: a[bcd]*dcdcde
--- s eval: "adcdcde"



=== TEST 5: re_tests:238
--- re: a[bcd]+dcdcde
--- s eval: "adcdcde"



=== TEST 6: re_tests:239
--- re: (ab|a)b*c
--- s eval: "abc"



=== TEST 7: re_tests:244
--- re: ((a)(b)c)(d)
--- s eval: "abcd"



=== TEST 8: re_tests:255
--- re: [a-zA-Z_][a-zA-Z0-9_]*
--- s eval: "alpha"



=== TEST 9: re_tests:256
--- re: ^a(bc+|b[eh])g|.h$
--- s eval: "abh"



=== TEST 10: re_tests:257
--- re: (bc+d$|ef*g.|h?i(j|k))
--- s eval: "effgz"



=== TEST 11: re_tests:258
--- re: (bc+d$|ef*g.|h?i(j|k))
--- s eval: "ij"



=== TEST 12: re_tests:259
--- re: (bc+d$|ef*g.|h?i(j|k))
--- s eval: "effg"



=== TEST 13: re_tests:260
--- re: (bc+d$|ef*g.|h?i(j|k))
--- s eval: "bcdd"



=== TEST 14: re_tests:261
--- re: (bc+d$|ef*g.|h?i(j|k))
--- s eval: "reffgz"



=== TEST 15: re_tests:262
--- re: ((((((((((a))))))))))
--- s eval: "a"



=== TEST 16: re_tests:268
--- re: ((((((((((a))))))))))\041
--- s eval: "aa"



=== TEST 17: re_tests:269
--- re: ((((((((((a))))))))))\041
--- s eval: "a!"



=== TEST 18: re_tests:270
--- re: (((((((((a)))))))))
--- s eval: "a"



=== TEST 19: re_tests:271
--- re: multiple words of text
--- s eval: "uh-uh"



=== TEST 20: re_tests:272
--- re: multiple words
--- s eval: "multiple words, yeah"



=== TEST 21: re_tests:273
--- re: (.*)c(.*)
--- s eval: "abcde"



=== TEST 22: re_tests:274
--- re: \((.*), (.*)\)
--- s eval: "(a, b)"



=== TEST 23: re_tests:275
--- re: [k]
--- s eval: "ab"



=== TEST 24: re_tests:276
--- re: abcd
--- s eval: "abcd"



=== TEST 25: re_tests:277
--- re: a(bc)d
--- s eval: "abcd"



=== TEST 26: re_tests:278
--- re: a[-]?c
--- s eval: "ac"



=== TEST 27: re_tests:285
--- re: \g{1}
--- s eval: "-"
--- err_like: ^\[error\] syntax error at pos \d+$



=== TEST 28: re_tests:287
--- re: \g0
--- s eval: "-"
--- err_like: ^\[error\] syntax error at pos \d+$



=== TEST 29: re_tests:289
--- re: \g{0}
--- s eval: "-"
--- err_like: ^\[error\] syntax error at pos \d+$



=== TEST 30: re_tests:302
--- re: (a)|(b)
--- s eval: "b"



=== TEST 31: re_tests:308
--- re: abc
--- s eval: "ABC"
--- flags: i



=== TEST 32: re_tests:309
--- re: abc
--- s eval: "XBC"
--- flags: i



=== TEST 33: re_tests:310
--- re: abc
--- s eval: "AXC"
--- flags: i



=== TEST 34: re_tests:311
--- re: abc
--- s eval: "ABX"
--- flags: i



=== TEST 35: re_tests:312
--- re: abc
--- s eval: "XABCY"
--- flags: i



=== TEST 36: re_tests:313
--- re: abc
--- s eval: "ABABC"
--- flags: i



=== TEST 37: re_tests:314
--- re: ab*c
--- s eval: "ABC"
--- flags: i



=== TEST 38: re_tests:315
--- re: ab*bc
--- s eval: "ABC"
--- flags: i



=== TEST 39: re_tests:316
--- re: ab*bc
--- s eval: "ABBC"
--- flags: i



=== TEST 40: re_tests:317
--- re: ab*?bc
--- s eval: "ABBBBC"
--- flags: i



=== TEST 41: re_tests:318
--- re: ab{0,}?bc
--- s eval: "ABBBBC"
--- flags: i



=== TEST 42: re_tests:319
--- re: ab+?bc
--- s eval: "ABBC"
--- flags: i



=== TEST 43: re_tests:320
--- re: ab+bc
--- s eval: "ABC"
--- flags: i



=== TEST 44: re_tests:321
--- re: ab+bc
--- s eval: "ABQ"
--- flags: i



=== TEST 45: re_tests:322
--- re: ab{1,}bc
--- s eval: "ABQ"
--- flags: i



=== TEST 46: re_tests:323
--- re: ab+bc
--- s eval: "ABBBBC"
--- flags: i



=== TEST 47: re_tests:324
--- re: ab{1,}?bc
--- s eval: "ABBBBC"
--- flags: i



=== TEST 48: re_tests:325
--- re: ab{1,3}?bc
--- s eval: "ABBBBC"
--- flags: i



=== TEST 49: re_tests:326
--- re: ab{3,4}?bc
--- s eval: "ABBBBC"
--- flags: i



=== TEST 50: re_tests:327
--- re: ab{4,5}?bc
--- s eval: "ABBBBC"
--- flags: i



