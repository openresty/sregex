# vim:set ft= ts=4 sw=4 et fdm=marker:

use t::SRegex 'no_plan';

run_tests();

__DATA__

=== TEST 1: testinput1:2483
--- re: a[b-d]
--- s eval: "aac"



=== TEST 2: testinput1:2486
--- re: a[-b]
--- s eval: "a-"



=== TEST 3: testinput1:2489
--- re: a[b-]
--- s eval: "a-"



=== TEST 4: testinput1:2492
--- re: a]
--- s eval: "a]"



=== TEST 5: testinput1:2495
--- re: a[]]b
--- s eval: "a]b"



=== TEST 6: testinput1:2498
--- re: a[^bc]d
--- s eval: "aed"



=== TEST 7: testinput1:2499
--- re: a[^bc]d
--- s eval: "*** Failers"



=== TEST 8: testinput1:2500
--- re: a[^bc]d
--- s eval: "abd"



=== TEST 9: testinput1:2504
--- re: a[^-b]c
--- s eval: "adc"



=== TEST 10: testinput1:2507
--- re: a[^]b]c
--- s eval: "adc"



=== TEST 11: testinput1:2508
--- re: a[^]b]c
--- s eval: "*** Failers"



=== TEST 12: testinput1:2509
--- re: a[^]b]c
--- s eval: "a-c"



=== TEST 13: testinput1:2510
--- re: a[^]b]c
--- s eval: "a]c"



=== TEST 14: testinput1:2513
--- re: \ba\b
--- s eval: "a-"



=== TEST 15: testinput1:2514
--- re: \ba\b
--- s eval: "-a"



=== TEST 16: testinput1:2515
--- re: \ba\b
--- s eval: "-a-"



=== TEST 17: testinput1:2518
--- re: \by\b
--- s eval: "*** Failers"



=== TEST 18: testinput1:2519
--- re: \by\b
--- s eval: "xy"



=== TEST 19: testinput1:2520
--- re: \by\b
--- s eval: "yz"



=== TEST 20: testinput1:2521
--- re: \by\b
--- s eval: "xyz"



=== TEST 21: testinput1:2524
--- re: \Ba\B
--- s eval: "*** Failers"



=== TEST 22: testinput1:2525
--- re: \Ba\B
--- s eval: "a-"



=== TEST 23: testinput1:2526
--- re: \Ba\B
--- s eval: "-a"



=== TEST 24: testinput1:2527
--- re: \Ba\B
--- s eval: "-a-"



=== TEST 25: testinput1:2530
--- re: \By\b
--- s eval: "xy"



=== TEST 26: testinput1:2533
--- re: \by\B
--- s eval: "yz"



=== TEST 27: testinput1:2536
--- re: \By\B
--- s eval: "xyz"



=== TEST 28: testinput1:2539
--- re: \w
--- s eval: "a"



=== TEST 29: testinput1:2542
--- re: \W
--- s eval: "-"



=== TEST 30: testinput1:2543
--- re: \W
--- s eval: "*** Failers"



=== TEST 31: testinput1:2545
--- re: \W
--- s eval: "a"



=== TEST 32: testinput1:2548
--- re: a\sb
--- s eval: "a b"



=== TEST 33: testinput1:2551
--- re: a\Sb
--- s eval: "a-b"



=== TEST 34: testinput1:2552
--- re: a\Sb
--- s eval: "*** Failers"



=== TEST 35: testinput1:2554
--- re: a\Sb
--- s eval: "a b"



=== TEST 36: testinput1:2557
--- re: \d
--- s eval: "1"



=== TEST 37: testinput1:2560
--- re: \D
--- s eval: "-"



=== TEST 38: testinput1:2561
--- re: \D
--- s eval: "*** Failers"



=== TEST 39: testinput1:2563
--- re: \D
--- s eval: "1"



=== TEST 40: testinput1:2566
--- re: [\w]
--- s eval: "a"



=== TEST 41: testinput1:2569
--- re: [\W]
--- s eval: "-"



=== TEST 42: testinput1:2570
--- re: [\W]
--- s eval: "*** Failers"



=== TEST 43: testinput1:2572
--- re: [\W]
--- s eval: "a"



=== TEST 44: testinput1:2575
--- re: a[\s]b
--- s eval: "a b"



=== TEST 45: testinput1:2578
--- re: a[\S]b
--- s eval: "a-b"



=== TEST 46: testinput1:2579
--- re: a[\S]b
--- s eval: "*** Failers"



=== TEST 47: testinput1:2581
--- re: a[\S]b
--- s eval: "a b"



=== TEST 48: testinput1:2584
--- re: [\d]
--- s eval: "1"



=== TEST 49: testinput1:2587
--- re: [\D]
--- s eval: "-"



=== TEST 50: testinput1:2588
--- re: [\D]
--- s eval: "*** Failers"



