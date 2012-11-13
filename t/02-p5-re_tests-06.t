# vim:set ft= ts=4 sw=4 et fdm=marker:

use t::SRegex 'no_plan';

run_tests();

__DATA__

=== TEST 1: re_tests:378
--- re: ((a))
--- s eval: "ABC"



=== TEST 2: re_tests:379
--- re: (a)b(c)
--- s eval: "ABC"



=== TEST 3: re_tests:380
--- re: a+b+c
--- s eval: "AABBABC"



=== TEST 4: re_tests:381
--- re: a{1,}b{1,}c
--- s eval: "AABBABC"



=== TEST 5: re_tests:382
--- re: a**
--- s eval: "-"
--- err
[error] syntax error



=== TEST 6: re_tests:383
--- re: a.+?c
--- s eval: "ABCABC"



=== TEST 7: re_tests:384
--- re: a.*?c
--- s eval: "ABCABC"



=== TEST 8: re_tests:385
--- re: a.{0,5}?c
--- s eval: "ABCABC"



=== TEST 9: re_tests:386
--- re: (a+|b)*
--- s eval: "AB"



=== TEST 10: re_tests:387
--- re: (a+|b){0,}
--- s eval: "AB"



=== TEST 11: re_tests:388
--- re: (a+|b)+
--- s eval: "AB"



=== TEST 12: re_tests:389
--- re: (a+|b){1,}
--- s eval: "AB"



=== TEST 13: re_tests:390
--- re: (a+|b)?
--- s eval: "AB"



=== TEST 14: re_tests:391
--- re: (a+|b){0,1}
--- s eval: "AB"



=== TEST 15: re_tests:392
--- re: (a+|b){0,1}?
--- s eval: "AB"



=== TEST 16: re_tests:393
--- re: )(
--- s eval: "-"
--- err
[error] syntax error



=== TEST 17: re_tests:394
--- re: [^ab]*
--- s eval: "CDE"



=== TEST 18: re_tests:395
--- re: abc
--- s eval: ""



=== TEST 19: re_tests:396
--- re: a*
--- s eval: ""



=== TEST 20: re_tests:397
--- re: ([abc])*d
--- s eval: "ABBBCD"



=== TEST 21: re_tests:398
--- re: ([abc])*bcd
--- s eval: "ABCD"



=== TEST 22: re_tests:399
--- re: a|b|c|d|e
--- s eval: "E"



=== TEST 23: re_tests:400
--- re: (a|b|c|d|e)f
--- s eval: "EF"



=== TEST 24: re_tests:401
--- re: abcd*efg
--- s eval: "ABCDEFG"



=== TEST 25: re_tests:402
--- re: ab*
--- s eval: "XABYABBBZ"



=== TEST 26: re_tests:403
--- re: ab*
--- s eval: "XAYABBBZ"



=== TEST 27: re_tests:404
--- re: (ab|cd)e
--- s eval: "ABCDE"



=== TEST 28: re_tests:405
--- re: [abhgefdc]ij
--- s eval: "HIJ"



=== TEST 29: re_tests:406
--- re: ^(ab|cd)e
--- s eval: "ABCDE"



=== TEST 30: re_tests:407
--- re: (abc|)ef
--- s eval: "ABCDEF"



=== TEST 31: re_tests:408
--- re: (a|b)c*d
--- s eval: "ABCD"



=== TEST 32: re_tests:409
--- re: (ab|ab*)bc
--- s eval: "ABC"



=== TEST 33: re_tests:410
--- re: a([bc]*)c*
--- s eval: "ABC"



=== TEST 34: re_tests:411
--- re: a([bc]*)(c*d)
--- s eval: "ABCD"



=== TEST 35: re_tests:412
--- re: a([bc]+)(c*d)
--- s eval: "ABCD"



=== TEST 36: re_tests:413
--- re: a([bc]*)(c+d)
--- s eval: "ABCD"



=== TEST 37: re_tests:414
--- re: a[bcd]*dcdcde
--- s eval: "ADCDCDE"



=== TEST 38: re_tests:415
--- re: a[bcd]+dcdcde
--- s eval: "ADCDCDE"



=== TEST 39: re_tests:416
--- re: (ab|a)b*c
--- s eval: "ABC"



=== TEST 40: re_tests:417
--- re: ((a)(b)c)(d)
--- s eval: "ABCD"



=== TEST 41: re_tests:418
--- re: [a-zA-Z_][a-zA-Z0-9_]*
--- s eval: "ALPHA"



=== TEST 42: re_tests:419
--- re: ^a(bc+|b[eh])g|.h$
--- s eval: "ABH"



=== TEST 43: re_tests:420
--- re: (bc+d$|ef*g.|h?i(j|k))
--- s eval: "EFFGZ"



=== TEST 44: re_tests:421
--- re: (bc+d$|ef*g.|h?i(j|k))
--- s eval: "IJ"



=== TEST 45: re_tests:422
--- re: (bc+d$|ef*g.|h?i(j|k))
--- s eval: "EFFG"



=== TEST 46: re_tests:423
--- re: (bc+d$|ef*g.|h?i(j|k))
--- s eval: "BCDD"



=== TEST 47: re_tests:424
--- re: (bc+d$|ef*g.|h?i(j|k))
--- s eval: "REFFGZ"



=== TEST 48: re_tests:425
--- re: ((((((((((a))))))))))
--- s eval: "A"



=== TEST 49: re_tests:427
--- re: ((((((((((a))))))))))\041
--- s eval: "AA"



=== TEST 50: re_tests:428
--- re: ((((((((((a))))))))))\041
--- s eval: "A!"



