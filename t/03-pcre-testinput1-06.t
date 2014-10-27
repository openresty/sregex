# vim:set ft= ts=4 sw=4 et fdm=marker:

use t::SRegex 'no_plan';

run_tests();

__DATA__

=== TEST 1: testinput1:361
--- re: ^\d{8}\w{2,}
--- s eval: "12345678__"



=== TEST 2: testinput1:362
--- re: ^\d{8}\w{2,}
--- s eval: "*** Failers"



=== TEST 3: testinput1:363
--- re: ^\d{8}\w{2,}
--- s eval: "1234567"



=== TEST 4: testinput1:366
--- re: ^[aeiou\d]{4,5}$
--- s eval: "uoie"



=== TEST 5: testinput1:367
--- re: ^[aeiou\d]{4,5}$
--- s eval: "1234"



=== TEST 6: testinput1:368
--- re: ^[aeiou\d]{4,5}$
--- s eval: "12345"



=== TEST 7: testinput1:369
--- re: ^[aeiou\d]{4,5}$
--- s eval: "aaaaa"



=== TEST 8: testinput1:370
--- re: ^[aeiou\d]{4,5}$
--- s eval: "*** Failers"



=== TEST 9: testinput1:371
--- re: ^[aeiou\d]{4,5}$
--- s eval: "123456"



=== TEST 10: testinput1:374
--- re: ^[aeiou\d]{4,5}?
--- s eval: "uoie"



=== TEST 11: testinput1:375
--- re: ^[aeiou\d]{4,5}?
--- s eval: "1234"



=== TEST 12: testinput1:376
--- re: ^[aeiou\d]{4,5}?
--- s eval: "12345"



=== TEST 13: testinput1:377
--- re: ^[aeiou\d]{4,5}?
--- s eval: "aaaaa"



=== TEST 14: testinput1:378
--- re: ^[aeiou\d]{4,5}?
--- s eval: "123456"



=== TEST 15: testinput1:397
--- re: ^From +([^ ]+) +[a-zA-Z][a-zA-Z][a-zA-Z] +[a-zA-Z][a-zA-Z][a-zA-Z] +[0-9]?[0-9] +[0-9][0-9]:[0-9][0-9]
--- s eval: "From abcd  Mon Sep 01 12:33:02 1997"



=== TEST 16: testinput1:400
--- re: ^From\s+\S+\s+([a-zA-Z]{3}\s+){2}\d{1,2}\s+\d\d:\d\d
--- s eval: "From abcd  Mon Sep 01 12:33:02 1997"



=== TEST 17: testinput1:401
--- re: ^From\s+\S+\s+([a-zA-Z]{3}\s+){2}\d{1,2}\s+\d\d:\d\d
--- s eval: "From abcd  Mon Sep  1 12:33:02 1997"



=== TEST 18: testinput1:402
--- re: ^From\s+\S+\s+([a-zA-Z]{3}\s+){2}\d{1,2}\s+\d\d:\d\d
--- s eval: "*** Failers"



=== TEST 19: testinput1:403
--- re: ^From\s+\S+\s+([a-zA-Z]{3}\s+){2}\d{1,2}\s+\d\d:\d\d
--- s eval: "From abcd  Sep 01 12:33:02 1997"



=== TEST 20: testinput1:406
--- re: ^12.34
--- s eval: "12\n34"



=== TEST 21: testinput1:407
--- re: ^12.34
--- s eval: "12\r34"



=== TEST 22: testinput1:439
--- re: ^abcd#rhubarb
--- s eval: "abcd"



=== TEST 23: testinput1:458
--- re: ^[ab]{1,3}(ab*|b)
--- s eval: "aabbbbb"



=== TEST 24: testinput1:461
--- re: ^[ab]{1,3}?(ab*|b)
--- s eval: "aabbbbb"



=== TEST 25: testinput1:464
--- re: ^[ab]{1,3}?(ab*?|b)
--- s eval: "aabbbbb"



=== TEST 26: testinput1:467
--- re: ^[ab]{1,3}(ab*?|b)
--- s eval: "aabbbbb"



=== TEST 27: testinput1:1266
--- re: abc\0def\00pqr\000xyz\0000AB
--- s eval: "abc\0def\00pqr\000xyz\0000AB"



=== TEST 28: testinput1:1267
--- re: abc\0def\00pqr\000xyz\0000AB
--- s eval: "abc456 abc\0def\00pqr\000xyz\0000ABCDE"



=== TEST 29: testinput1:1270
--- re: abc\x0def\x00pqr\x000xyz\x0000AB
--- s eval: "abc\x0def\x00pqr\x000xyz\x0000AB"



=== TEST 30: testinput1:1271
--- re: abc\x0def\x00pqr\x000xyz\x0000AB
--- s eval: "abc456 abc\x0def\x00pqr\x000xyz\x0000ABCDE"



=== TEST 31: testinput1:1274
--- re: ^[\000-\037]
--- s eval: "\0A"



=== TEST 32: testinput1:1275
--- re: ^[\000-\037]
--- s eval: "\01B"



=== TEST 33: testinput1:1276
--- re: ^[\000-\037]
--- s eval: "\037C"



=== TEST 34: testinput1:1279
--- re: \0*
--- s eval: "\0\0\0\0"



=== TEST 35: testinput1:1282
--- re: A\x0{2,3}Z
--- s eval: "The A\x{0}\x{0}Z"



=== TEST 36: testinput1:1283
--- re: A\x0{2,3}Z
--- s eval: "An A\0\x{0}\0Z"



=== TEST 37: testinput1:1284
--- re: A\x0{2,3}Z
--- s eval: "*** Failers"



=== TEST 38: testinput1:1285
--- re: A\x0{2,3}Z
--- s eval: "A\0Z"



=== TEST 39: testinput1:1286
--- re: A\x0{2,3}Z
--- s eval: "A\0\x{0}\0\x{0}Z"



=== TEST 40: testinput1:1295
--- re: ^\s
--- s eval: "\040abc"



=== TEST 41: testinput1:1296
--- re: ^\s
--- s eval: "\x0cabc"



=== TEST 42: testinput1:1297
--- re: ^\s
--- s eval: "\nabc"



=== TEST 43: testinput1:1298
--- re: ^\s
--- s eval: "\rabc"



=== TEST 44: testinput1:1299
--- re: ^\s
--- s eval: "\tabc"



=== TEST 45: testinput1:1300
--- re: ^\s
--- s eval: "*** Failers"



=== TEST 46: testinput1:1301
--- re: ^\s
--- s eval: "abc"



=== TEST 47: testinput1:1346
--- re: ab{1,3}bc
--- s eval: "abbbbc"



=== TEST 48: testinput1:1347
--- re: ab{1,3}bc
--- s eval: "abbbc"



=== TEST 49: testinput1:1348
--- re: ab{1,3}bc
--- s eval: "abbc"



=== TEST 50: testinput1:1349
--- re: ab{1,3}bc
--- s eval: "*** Failers"



