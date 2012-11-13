# vim:set ft= ts=4 sw=4 et fdm=marker:

use t::SRegex 'no_plan';

run_tests();

__DATA__

=== TEST 1: testinput1:2746
--- re: multiple words
--- s eval: "multiple words, yeah"



=== TEST 2: testinput1:2749
--- re: (.*)c(.*)
--- s eval: "abcde"



=== TEST 3: testinput1:2752
--- re: \((.*), (.*)\)
--- s eval: "(a, b)"



=== TEST 4: testinput1:2757
--- re: abcd
--- s eval: "abcd"



=== TEST 5: testinput1:2760
--- re: a(bc)d
--- s eval: "abcd"



=== TEST 6: testinput1:2763
--- re: a[-]?c
--- s eval: "ac"



=== TEST 7: testinput1:2790
--- re: abc
--- s eval: "ABC"



=== TEST 8: testinput1:2791
--- re: abc
--- s eval: "XABCY"



=== TEST 9: testinput1:2792
--- re: abc
--- s eval: "ABABC"



=== TEST 10: testinput1:2794
--- re: abc
--- s eval: "aaxabxbaxbbx"



=== TEST 11: testinput1:2795
--- re: abc
--- s eval: "XBC"



=== TEST 12: testinput1:2796
--- re: abc
--- s eval: "AXC"



=== TEST 13: testinput1:2797
--- re: abc
--- s eval: "ABX"



=== TEST 14: testinput1:2800
--- re: ab*c
--- s eval: "ABC"



=== TEST 15: testinput1:2803
--- re: ab*bc
--- s eval: "ABC"



=== TEST 16: testinput1:2804
--- re: ab*bc
--- s eval: "ABBC"



=== TEST 17: testinput1:2807
--- re: ab*?bc
--- s eval: "ABBBBC"



=== TEST 18: testinput1:2810
--- re: ab{0,}?bc
--- s eval: "ABBBBC"



=== TEST 19: testinput1:2813
--- re: ab+?bc
--- s eval: "ABBC"



=== TEST 20: testinput1:2817
--- re: ab+bc
--- s eval: "ABC"



=== TEST 21: testinput1:2818
--- re: ab+bc
--- s eval: "ABQ"



=== TEST 22: testinput1:2823
--- re: ab+bc
--- s eval: "ABBBBC"



=== TEST 23: testinput1:2826
--- re: ab{1,}?bc
--- s eval: "ABBBBC"



=== TEST 24: testinput1:2829
--- re: ab{1,3}?bc
--- s eval: "ABBBBC"



=== TEST 25: testinput1:2832
--- re: ab{3,4}?bc
--- s eval: "ABBBBC"



=== TEST 26: testinput1:2835
--- re: ab{4,5}?bc
--- s eval: "*** Failers"



=== TEST 27: testinput1:2836
--- re: ab{4,5}?bc
--- s eval: "ABQ"



=== TEST 28: testinput1:2837
--- re: ab{4,5}?bc
--- s eval: "ABBBBC"



=== TEST 29: testinput1:2840
--- re: ab??bc
--- s eval: "ABBC"



=== TEST 30: testinput1:2841
--- re: ab??bc
--- s eval: "ABC"



=== TEST 31: testinput1:2844
--- re: ab{0,1}?bc
--- s eval: "ABC"



=== TEST 32: testinput1:2849
--- re: ab??c
--- s eval: "ABC"



=== TEST 33: testinput1:2852
--- re: ab{0,1}?c
--- s eval: "ABC"



=== TEST 34: testinput1:2855
--- re: ^abc$
--- s eval: "ABC"



=== TEST 35: testinput1:2857
--- re: ^abc$
--- s eval: "ABBBBC"



=== TEST 36: testinput1:2858
--- re: ^abc$
--- s eval: "ABCC"



=== TEST 37: testinput1:2861
--- re: ^abc
--- s eval: "ABCC"



=== TEST 38: testinput1:2866
--- re: abc$
--- s eval: "AABC"



=== TEST 39: testinput1:2869
--- re: ^
--- s eval: "ABC"



=== TEST 40: testinput1:2872
--- re: $
--- s eval: "ABC"



=== TEST 41: testinput1:2875
--- re: a.c
--- s eval: "ABC"



=== TEST 42: testinput1:2876
--- re: a.c
--- s eval: "AXC"



=== TEST 43: testinput1:2879
--- re: a.*?c
--- s eval: "AXYZC"



=== TEST 44: testinput1:2882
--- re: a.*c
--- s eval: "*** Failers"



=== TEST 45: testinput1:2883
--- re: a.*c
--- s eval: "AABC"



=== TEST 46: testinput1:2884
--- re: a.*c
--- s eval: "AXYZD"



=== TEST 47: testinput1:2887
--- re: a[bc]d
--- s eval: "ABD"



=== TEST 48: testinput1:2890
--- re: a[b-d]e
--- s eval: "ACE"



=== TEST 49: testinput1:2891
--- re: a[b-d]e
--- s eval: "*** Failers"



=== TEST 50: testinput1:2892
--- re: a[b-d]e
--- s eval: "ABC"



