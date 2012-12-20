# vim:set ft= ts=4 sw=4 et fdm=marker:

use t::SRegex 'no_plan';

run_tests();

__DATA__

=== TEST 1: testinput1:2729
--- re: (bc+d$|ef*g.|h?i(j|k))
--- s eval: "bcdd"



=== TEST 2: testinput1:2732
--- re: ((((((((((a))))))))))
--- s eval: "a"



=== TEST 3: testinput1:2738
--- re: (((((((((a)))))))))
--- s eval: "a"



=== TEST 4: testinput1:2741
--- re: multiple words of text
--- s eval: "*** Failers"



=== TEST 5: testinput1:2742
--- re: multiple words of text
--- s eval: "aa"



=== TEST 6: testinput1:2743
--- re: multiple words of text
--- s eval: "uh-uh"



=== TEST 7: testinput1:2746
--- re: multiple words
--- s eval: "multiple words, yeah"



=== TEST 8: testinput1:2749
--- re: (.*)c(.*)
--- s eval: "abcde"



=== TEST 9: testinput1:2752
--- re: \((.*), (.*)\)
--- s eval: "(a, b)"



=== TEST 10: testinput1:2757
--- re: abcd
--- s eval: "abcd"



=== TEST 11: testinput1:2760
--- re: a(bc)d
--- s eval: "abcd"



=== TEST 12: testinput1:2763
--- re: a[-]?c
--- s eval: "ac"



=== TEST 13: testinput1:2790
--- re: abc
--- s eval: "ABC"
--- flags: i



=== TEST 14: testinput1:2791
--- re: abc
--- s eval: "XABCY"
--- flags: i



=== TEST 15: testinput1:2792
--- re: abc
--- s eval: "ABABC"
--- flags: i



=== TEST 16: testinput1:2793
--- re: abc
--- s eval: "*** Failers"
--- flags: i



=== TEST 17: testinput1:2794
--- re: abc
--- s eval: "aaxabxbaxbbx"
--- flags: i



=== TEST 18: testinput1:2795
--- re: abc
--- s eval: "XBC"
--- flags: i



=== TEST 19: testinput1:2796
--- re: abc
--- s eval: "AXC"
--- flags: i



=== TEST 20: testinput1:2797
--- re: abc
--- s eval: "ABX"
--- flags: i



=== TEST 21: testinput1:2800
--- re: ab*c
--- s eval: "ABC"
--- flags: i



=== TEST 22: testinput1:2803
--- re: ab*bc
--- s eval: "ABC"
--- flags: i



=== TEST 23: testinput1:2804
--- re: ab*bc
--- s eval: "ABBC"
--- flags: i



=== TEST 24: testinput1:2807
--- re: ab*?bc
--- s eval: "ABBBBC"
--- flags: i



=== TEST 25: testinput1:2810
--- re: ab{0,}?bc
--- s eval: "ABBBBC"
--- flags: i



=== TEST 26: testinput1:2813
--- re: ab+?bc
--- s eval: "ABBC"
--- flags: i



=== TEST 27: testinput1:2816
--- re: ab+bc
--- s eval: "*** Failers"
--- flags: i



=== TEST 28: testinput1:2817
--- re: ab+bc
--- s eval: "ABC"
--- flags: i



=== TEST 29: testinput1:2818
--- re: ab+bc
--- s eval: "ABQ"
--- flags: i



=== TEST 30: testinput1:2823
--- re: ab+bc
--- s eval: "ABBBBC"
--- flags: i



=== TEST 31: testinput1:2826
--- re: ab{1,}?bc
--- s eval: "ABBBBC"
--- flags: i



=== TEST 32: testinput1:2829
--- re: ab{1,3}?bc
--- s eval: "ABBBBC"
--- flags: i



=== TEST 33: testinput1:2832
--- re: ab{3,4}?bc
--- s eval: "ABBBBC"
--- flags: i



=== TEST 34: testinput1:2835
--- re: ab{4,5}?bc
--- s eval: "*** Failers"
--- flags: i



=== TEST 35: testinput1:2836
--- re: ab{4,5}?bc
--- s eval: "ABQ"
--- flags: i



=== TEST 36: testinput1:2837
--- re: ab{4,5}?bc
--- s eval: "ABBBBC"
--- flags: i



=== TEST 37: testinput1:2840
--- re: ab??bc
--- s eval: "ABBC"
--- flags: i



=== TEST 38: testinput1:2841
--- re: ab??bc
--- s eval: "ABC"
--- flags: i



=== TEST 39: testinput1:2844
--- re: ab{0,1}?bc
--- s eval: "ABC"
--- flags: i



=== TEST 40: testinput1:2849
--- re: ab??c
--- s eval: "ABC"
--- flags: i



=== TEST 41: testinput1:2852
--- re: ab{0,1}?c
--- s eval: "ABC"
--- flags: i



=== TEST 42: testinput1:2855
--- re: ^abc$
--- s eval: "ABC"
--- flags: i



=== TEST 43: testinput1:2856
--- re: ^abc$
--- s eval: "*** Failers"
--- flags: i



=== TEST 44: testinput1:2857
--- re: ^abc$
--- s eval: "ABBBBC"
--- flags: i



=== TEST 45: testinput1:2858
--- re: ^abc$
--- s eval: "ABCC"
--- flags: i



=== TEST 46: testinput1:2861
--- re: ^abc
--- s eval: "ABCC"
--- flags: i



=== TEST 47: testinput1:2866
--- re: abc$
--- s eval: "AABC"
--- flags: i



=== TEST 48: testinput1:2869
--- re: ^
--- s eval: "ABC"
--- flags: i



=== TEST 49: testinput1:2872
--- re: $
--- s eval: "ABC"
--- flags: i



=== TEST 50: testinput1:2875
--- re: a.c
--- s eval: "ABC"
--- flags: i



