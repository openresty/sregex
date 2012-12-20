# vim:set ft= ts=4 sw=4 et fdm=marker:

use t::SRegex 'no_plan';

run_tests();

__DATA__

=== TEST 1: testinput1:263
--- re: ^\*\.[a-z]([a-z\-\d]*[a-z\d]+)?(\.[a-z]([a-z\-\d]*[a-z\d]+)?)*$
--- s eval: "*.0"



=== TEST 2: testinput1:264
--- re: ^\*\.[a-z]([a-z\-\d]*[a-z\d]+)?(\.[a-z]([a-z\-\d]*[a-z\d]+)?)*$
--- s eval: "*.a-"



=== TEST 3: testinput1:265
--- re: ^\*\.[a-z]([a-z\-\d]*[a-z\d]+)?(\.[a-z]([a-z\-\d]*[a-z\d]+)?)*$
--- s eval: "*.a-b.c-"



=== TEST 4: testinput1:266
--- re: ^\*\.[a-z]([a-z\-\d]*[a-z\d]+)?(\.[a-z]([a-z\-\d]*[a-z\d]+)?)*$
--- s eval: "*.c-a.0-c"



=== TEST 5: testinput1:278
--- re: ^[\da-f](\.[\da-f])*$
--- s eval: "a.b.c.d"
--- flags: i



=== TEST 6: testinput1:279
--- re: ^[\da-f](\.[\da-f])*$
--- s eval: "A.B.C.D"
--- flags: i



=== TEST 7: testinput1:280
--- re: ^[\da-f](\.[\da-f])*$
--- s eval: "a.b.c.1.2.3.C"
--- flags: i



=== TEST 8: testinput1:283
--- re: ^\".*\"\s*(;.*)?$
--- s eval: "\"1234\""



=== TEST 9: testinput1:284
--- re: ^\".*\"\s*(;.*)?$
--- s eval: "\"abcd\" ;"



=== TEST 10: testinput1:285
--- re: ^\".*\"\s*(;.*)?$
--- s eval: "\"\" ; rhubarb"



=== TEST 11: testinput1:286
--- re: ^\".*\"\s*(;.*)?$
--- s eval: "*** Failers"



=== TEST 12: testinput1:287
--- re: ^\".*\"\s*(;.*)?$
--- s eval: "\"1234\" : things"



=== TEST 13: testinput1:290
--- re: ^$
--- s eval: ""



=== TEST 14: testinput1:291
--- re: ^$
--- s eval: "*** Failers"



=== TEST 15: testinput1:306
--- re: ^   a\ b[c ]d       $
--- s eval: "a bcd"



=== TEST 16: testinput1:307
--- re: ^   a\ b[c ]d       $
--- s eval: "a b d"



=== TEST 17: testinput1:308
--- re: ^   a\ b[c ]d       $
--- s eval: "*** Failers"



=== TEST 18: testinput1:309
--- re: ^   a\ b[c ]d       $
--- s eval: "abcd"



=== TEST 19: testinput1:310
--- re: ^   a\ b[c ]d       $
--- s eval: "ab d"



=== TEST 20: testinput1:313
--- re: ^(a(b(c)))(d(e(f)))(h(i(j)))(k(l(m)))$
--- s eval: "abcdefhijklm"



=== TEST 21: testinput1:316
--- re: ^(?:a(b(c)))(?:d(e(f)))(?:h(i(j)))(?:k(l(m)))$
--- s eval: "abcdefhijklm"



=== TEST 22: testinput1:319
--- re: ^[\w][\W][\s][\S][\d][\D][\b][\n][\c]][\022]
--- s eval: "a+ Z0+\x08\n\x1d\x12"



=== TEST 23: testinput1:325
--- re: ^a*\w
--- s eval: "z"



=== TEST 24: testinput1:326
--- re: ^a*\w
--- s eval: "az"



=== TEST 25: testinput1:327
--- re: ^a*\w
--- s eval: "aaaz"



=== TEST 26: testinput1:328
--- re: ^a*\w
--- s eval: "a"



=== TEST 27: testinput1:329
--- re: ^a*\w
--- s eval: "aa"



=== TEST 28: testinput1:330
--- re: ^a*\w
--- s eval: "aaaa"



=== TEST 29: testinput1:331
--- re: ^a*\w
--- s eval: "a+"



=== TEST 30: testinput1:332
--- re: ^a*\w
--- s eval: "aa+"



=== TEST 31: testinput1:335
--- re: ^a*?\w
--- s eval: "z"



=== TEST 32: testinput1:336
--- re: ^a*?\w
--- s eval: "az"



=== TEST 33: testinput1:337
--- re: ^a*?\w
--- s eval: "aaaz"



=== TEST 34: testinput1:338
--- re: ^a*?\w
--- s eval: "a"



=== TEST 35: testinput1:339
--- re: ^a*?\w
--- s eval: "aa"



=== TEST 36: testinput1:340
--- re: ^a*?\w
--- s eval: "aaaa"



=== TEST 37: testinput1:341
--- re: ^a*?\w
--- s eval: "a+"



=== TEST 38: testinput1:342
--- re: ^a*?\w
--- s eval: "aa+"



=== TEST 39: testinput1:345
--- re: ^a+\w
--- s eval: "az"



=== TEST 40: testinput1:346
--- re: ^a+\w
--- s eval: "aaaz"



=== TEST 41: testinput1:347
--- re: ^a+\w
--- s eval: "aa"



=== TEST 42: testinput1:348
--- re: ^a+\w
--- s eval: "aaaa"



=== TEST 43: testinput1:349
--- re: ^a+\w
--- s eval: "aa+"



=== TEST 44: testinput1:352
--- re: ^a+?\w
--- s eval: "az"



=== TEST 45: testinput1:353
--- re: ^a+?\w
--- s eval: "aaaz"



=== TEST 46: testinput1:354
--- re: ^a+?\w
--- s eval: "aa"



=== TEST 47: testinput1:355
--- re: ^a+?\w
--- s eval: "aaaa"



=== TEST 48: testinput1:356
--- re: ^a+?\w
--- s eval: "aa+"



=== TEST 49: testinput1:359
--- re: ^\d{8}\w{2,}
--- s eval: "1234567890"



=== TEST 50: testinput1:360
--- re: ^\d{8}\w{2,}
--- s eval: "12345678ab"



