# vim:set ft= ts=4 sw=4 et fdm=marker:

use t::SRegex 'no_plan';

run_tests();

__DATA__

=== TEST 1: testinput1:2246
--- re: ([^a]*?)*
--- s eval: "b"



=== TEST 2: testinput1:2247
--- re: ([^a]*?)*
--- s eval: "bbbb"



=== TEST 3: testinput1:2248
--- re: ([^a]*?)*
--- s eval: "aaa   "



=== TEST 4: testinput1:2251
--- re: ([^ab]*?)*
--- s eval: "c"



=== TEST 5: testinput1:2252
--- re: ([^ab]*?)*
--- s eval: "cccc"



=== TEST 6: testinput1:2253
--- re: ([^ab]*?)*
--- s eval: "baba   "



=== TEST 7: testinput1:2378
--- re: abc
--- s eval: "abc"



=== TEST 8: testinput1:2379
--- re: abc
--- s eval: "xabcy"



=== TEST 9: testinput1:2380
--- re: abc
--- s eval: "ababc"



=== TEST 10: testinput1:2381
--- re: abc
--- s eval: "*** Failers"



=== TEST 11: testinput1:2382
--- re: abc
--- s eval: "xbc"



=== TEST 12: testinput1:2383
--- re: abc
--- s eval: "axc"



=== TEST 13: testinput1:2384
--- re: abc
--- s eval: "abx"



=== TEST 14: testinput1:2387
--- re: ab*c
--- s eval: "abc"



=== TEST 15: testinput1:2390
--- re: ab*bc
--- s eval: "abc"



=== TEST 16: testinput1:2391
--- re: ab*bc
--- s eval: "abbc"



=== TEST 17: testinput1:2392
--- re: ab*bc
--- s eval: "abbbbc"



=== TEST 18: testinput1:2395
--- re: .{1}
--- s eval: "abbbbc"



=== TEST 19: testinput1:2398
--- re: .{3,4}
--- s eval: "abbbbc"



=== TEST 20: testinput1:2401
--- re: ab{0,}bc
--- s eval: "abbbbc"



=== TEST 21: testinput1:2404
--- re: ab+bc
--- s eval: "abbc"



=== TEST 22: testinput1:2405
--- re: ab+bc
--- s eval: "*** Failers"



=== TEST 23: testinput1:2406
--- re: ab+bc
--- s eval: "abc"



=== TEST 24: testinput1:2407
--- re: ab+bc
--- s eval: "abq"



=== TEST 25: testinput1:2412
--- re: ab+bc
--- s eval: "abbbbc"



=== TEST 26: testinput1:2415
--- re: ab{1,}bc
--- s eval: "abbbbc"



=== TEST 27: testinput1:2421
--- re: ab{3,4}bc
--- s eval: "abbbbc"



=== TEST 28: testinput1:2424
--- re: ab{4,5}bc
--- s eval: "*** Failers"



=== TEST 29: testinput1:2425
--- re: ab{4,5}bc
--- s eval: "abq"



=== TEST 30: testinput1:2426
--- re: ab{4,5}bc
--- s eval: "abbbbc"



=== TEST 31: testinput1:2429
--- re: ab?bc
--- s eval: "abbc"



=== TEST 32: testinput1:2430
--- re: ab?bc
--- s eval: "abc"



=== TEST 33: testinput1:2433
--- re: ab{0,1}bc
--- s eval: "abc"



=== TEST 34: testinput1:2438
--- re: ab?c
--- s eval: "abc"



=== TEST 35: testinput1:2441
--- re: ab{0,1}c
--- s eval: "abc"



=== TEST 36: testinput1:2446
--- re: ^abc$
--- s eval: "abbbbc"



=== TEST 37: testinput1:2447
--- re: ^abc$
--- s eval: "abcc"



=== TEST 38: testinput1:2450
--- re: ^abc
--- s eval: "abcc"



=== TEST 39: testinput1:2455
--- re: abc$
--- s eval: "aabc"



=== TEST 40: testinput1:2458
--- re: abc$
--- s eval: "aabcd"



=== TEST 41: testinput1:2461
--- re: ^
--- s eval: "abc"



=== TEST 42: testinput1:2464
--- re: $
--- s eval: "abc"



=== TEST 43: testinput1:2467
--- re: a.c
--- s eval: "abc"



=== TEST 44: testinput1:2468
--- re: a.c
--- s eval: "axc"



=== TEST 45: testinput1:2471
--- re: a.*c
--- s eval: "axyzc"



=== TEST 46: testinput1:2474
--- re: a[bc]d
--- s eval: "abd"



=== TEST 47: testinput1:2475
--- re: a[bc]d
--- s eval: "*** Failers"



=== TEST 48: testinput1:2476
--- re: a[bc]d
--- s eval: "axyzd"



=== TEST 49: testinput1:2477
--- re: a[bc]d
--- s eval: "abc"



=== TEST 50: testinput1:2480
--- re: a[b-d]e
--- s eval: "ace"



