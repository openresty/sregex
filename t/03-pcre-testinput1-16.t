# vim:set ft= ts=4 sw=4 et fdm=marker:

use t::SRegex 'no_plan';

run_tests();

__DATA__

=== TEST 1: testinput1:2876
--- re: a.c
--- s eval: "AXC"
--- flags: i



=== TEST 2: testinput1:2879
--- re: a.*?c
--- s eval: "AXYZC"
--- flags: i



=== TEST 3: testinput1:2882
--- re: a.*c
--- s eval: "*** Failers"
--- flags: i



=== TEST 4: testinput1:2883
--- re: a.*c
--- s eval: "AABC"
--- flags: i



=== TEST 5: testinput1:2884
--- re: a.*c
--- s eval: "AXYZD"
--- flags: i



=== TEST 6: testinput1:2887
--- re: a[bc]d
--- s eval: "ABD"
--- flags: i



=== TEST 7: testinput1:2890
--- re: a[b-d]e
--- s eval: "ACE"
--- flags: i



=== TEST 8: testinput1:2891
--- re: a[b-d]e
--- s eval: "*** Failers"
--- flags: i



=== TEST 9: testinput1:2892
--- re: a[b-d]e
--- s eval: "ABC"
--- flags: i



=== TEST 10: testinput1:2893
--- re: a[b-d]e
--- s eval: "ABD"
--- flags: i



=== TEST 11: testinput1:2896
--- re: a[b-d]
--- s eval: "AAC"
--- flags: i



=== TEST 12: testinput1:2899
--- re: a[-b]
--- s eval: "A-"
--- flags: i



=== TEST 13: testinput1:2902
--- re: a[b-]
--- s eval: "A-"
--- flags: i



=== TEST 14: testinput1:2905
--- re: a]
--- s eval: "A]"
--- flags: i



=== TEST 15: testinput1:2908
--- re: a[]]b
--- s eval: "A]B"
--- flags: i



=== TEST 16: testinput1:2911
--- re: a[^bc]d
--- s eval: "AED"
--- flags: i



=== TEST 17: testinput1:2914
--- re: a[^-b]c
--- s eval: "ADC"
--- flags: i



=== TEST 18: testinput1:2915
--- re: a[^-b]c
--- s eval: "*** Failers"
--- flags: i



=== TEST 19: testinput1:2916
--- re: a[^-b]c
--- s eval: "ABD"
--- flags: i



=== TEST 20: testinput1:2917
--- re: a[^-b]c
--- s eval: "A-C"
--- flags: i



=== TEST 21: testinput1:2920
--- re: a[^]b]c
--- s eval: "ADC"
--- flags: i



=== TEST 22: testinput1:2923
--- re: ab|cd
--- s eval: "ABC"
--- flags: i



=== TEST 23: testinput1:2924
--- re: ab|cd
--- s eval: "ABCD"
--- flags: i



=== TEST 24: testinput1:2927
--- re: ()ef
--- s eval: "DEF"
--- flags: i



=== TEST 25: testinput1:2930
--- re: $b
--- s eval: "*** Failers"
--- flags: i



=== TEST 26: testinput1:2931
--- re: $b
--- s eval: "A]C"
--- flags: i



=== TEST 27: testinput1:2932
--- re: $b
--- s eval: "B"
--- flags: i



=== TEST 28: testinput1:2935
--- re: a\(b
--- s eval: "A(B"
--- flags: i



=== TEST 29: testinput1:2938
--- re: a\(*b
--- s eval: "AB"
--- flags: i



=== TEST 30: testinput1:2939
--- re: a\(*b
--- s eval: "A((B"
--- flags: i



=== TEST 31: testinput1:2942
--- re: a\\b
--- s eval: "A\\B"
--- flags: i



=== TEST 32: testinput1:2945
--- re: ((a))
--- s eval: "ABC"
--- flags: i



=== TEST 33: testinput1:2948
--- re: (a)b(c)
--- s eval: "ABC"
--- flags: i



=== TEST 34: testinput1:2951
--- re: a+b+c
--- s eval: "AABBABC"
--- flags: i



=== TEST 35: testinput1:2954
--- re: a{1,}b{1,}c
--- s eval: "AABBABC"
--- flags: i



=== TEST 36: testinput1:2957
--- re: a.+?c
--- s eval: "ABCABC"
--- flags: i



=== TEST 37: testinput1:2960
--- re: a.*?c
--- s eval: "ABCABC"
--- flags: i



=== TEST 38: testinput1:2963
--- re: a.{0,5}?c
--- s eval: "ABCABC"
--- flags: i



=== TEST 39: testinput1:2966
--- re: (a+|b)*
--- s eval: "AB"
--- flags: i



=== TEST 40: testinput1:2969
--- re: (a+|b){0,}
--- s eval: "AB"
--- flags: i



=== TEST 41: testinput1:2972
--- re: (a+|b)+
--- s eval: "AB"
--- flags: i



=== TEST 42: testinput1:2975
--- re: (a+|b){1,}
--- s eval: "AB"
--- flags: i



=== TEST 43: testinput1:2978
--- re: (a+|b)?
--- s eval: "AB"
--- flags: i



=== TEST 44: testinput1:2981
--- re: (a+|b){0,1}
--- s eval: "AB"
--- flags: i



=== TEST 45: testinput1:2984
--- re: (a+|b){0,1}?
--- s eval: "AB"
--- flags: i



=== TEST 46: testinput1:2987
--- re: [^ab]*
--- s eval: "CDE"
--- flags: i



=== TEST 47: testinput1:2995
--- re: ([abc])*d
--- s eval: "ABBBCD"
--- flags: i



=== TEST 48: testinput1:2998
--- re: ([abc])*bcd
--- s eval: "ABCD"
--- flags: i



=== TEST 49: testinput1:3001
--- re: a|b|c|d|e
--- s eval: "E"
--- flags: i



=== TEST 50: testinput1:3004
--- re: (a|b|c|d|e)f
--- s eval: "EF"
--- flags: i



