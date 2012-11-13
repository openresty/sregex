# vim:set ft= ts=4 sw=4 et fdm=marker:

use t::SRegex 'no_plan';

run_tests();

__DATA__

=== TEST 1: testinput1:2893
--- re: a[b-d]e
--- s eval: "ABD"



=== TEST 2: testinput1:2896
--- re: a[b-d]
--- s eval: "AAC"



=== TEST 3: testinput1:2899
--- re: a[-b]
--- s eval: "A-"



=== TEST 4: testinput1:2902
--- re: a[b-]
--- s eval: "A-"



=== TEST 5: testinput1:2905
--- re: a]
--- s eval: "A]"



=== TEST 6: testinput1:2908
--- re: a[]]b
--- s eval: "A]B"



=== TEST 7: testinput1:2911
--- re: a[^bc]d
--- s eval: "AED"



=== TEST 8: testinput1:2914
--- re: a[^-b]c
--- s eval: "ADC"



=== TEST 9: testinput1:2915
--- re: a[^-b]c
--- s eval: "*** Failers"



=== TEST 10: testinput1:2916
--- re: a[^-b]c
--- s eval: "ABD"



=== TEST 11: testinput1:2917
--- re: a[^-b]c
--- s eval: "A-C"



=== TEST 12: testinput1:2920
--- re: a[^]b]c
--- s eval: "ADC"



=== TEST 13: testinput1:2923
--- re: ab|cd
--- s eval: "ABC"



=== TEST 14: testinput1:2924
--- re: ab|cd
--- s eval: "ABCD"



=== TEST 15: testinput1:2927
--- re: ()ef
--- s eval: "DEF"



=== TEST 16: testinput1:2930
--- re: $b
--- s eval: "*** Failers"



=== TEST 17: testinput1:2931
--- re: $b
--- s eval: "A]C"



=== TEST 18: testinput1:2932
--- re: $b
--- s eval: "B"



=== TEST 19: testinput1:2935
--- re: a\(b
--- s eval: "A(B"



=== TEST 20: testinput1:2938
--- re: a\(*b
--- s eval: "AB"



=== TEST 21: testinput1:2939
--- re: a\(*b
--- s eval: "A((B"



=== TEST 22: testinput1:2942
--- re: a\\b
--- s eval: "A\\B"



=== TEST 23: testinput1:2945
--- re: ((a))
--- s eval: "ABC"



=== TEST 24: testinput1:2948
--- re: (a)b(c)
--- s eval: "ABC"



=== TEST 25: testinput1:2951
--- re: a+b+c
--- s eval: "AABBABC"



=== TEST 26: testinput1:2954
--- re: a{1,}b{1,}c
--- s eval: "AABBABC"



=== TEST 27: testinput1:2957
--- re: a.+?c
--- s eval: "ABCABC"



=== TEST 28: testinput1:2960
--- re: a.*?c
--- s eval: "ABCABC"



=== TEST 29: testinput1:2963
--- re: a.{0,5}?c
--- s eval: "ABCABC"



=== TEST 30: testinput1:2966
--- re: (a+|b)*
--- s eval: "AB"



=== TEST 31: testinput1:2969
--- re: (a+|b){0,}
--- s eval: "AB"



=== TEST 32: testinput1:2972
--- re: (a+|b)+
--- s eval: "AB"



=== TEST 33: testinput1:2975
--- re: (a+|b){1,}
--- s eval: "AB"



=== TEST 34: testinput1:2978
--- re: (a+|b)?
--- s eval: "AB"



=== TEST 35: testinput1:2981
--- re: (a+|b){0,1}
--- s eval: "AB"



=== TEST 36: testinput1:2984
--- re: (a+|b){0,1}?
--- s eval: "AB"



=== TEST 37: testinput1:2987
--- re: [^ab]*
--- s eval: "CDE"



=== TEST 38: testinput1:2995
--- re: ([abc])*d
--- s eval: "ABBBCD"



=== TEST 39: testinput1:2998
--- re: ([abc])*bcd
--- s eval: "ABCD"



=== TEST 40: testinput1:3001
--- re: a|b|c|d|e
--- s eval: "E"



=== TEST 41: testinput1:3004
--- re: (a|b|c|d|e)f
--- s eval: "EF"



=== TEST 42: testinput1:3007
--- re: abcd*efg
--- s eval: "ABCDEFG"



=== TEST 43: testinput1:3010
--- re: ab*
--- s eval: "XABYABBBZ"



=== TEST 44: testinput1:3011
--- re: ab*
--- s eval: "XAYABBBZ"



=== TEST 45: testinput1:3014
--- re: (ab|cd)e
--- s eval: "ABCDE"



=== TEST 46: testinput1:3017
--- re: [abhgefdc]ij
--- s eval: "HIJ"



=== TEST 47: testinput1:3020
--- re: ^(ab|cd)e
--- s eval: "ABCDE"



=== TEST 48: testinput1:3023
--- re: (abc|)ef
--- s eval: "ABCDEF"



=== TEST 49: testinput1:3026
--- re: (a|b)c*d
--- s eval: "ABCD"



=== TEST 50: testinput1:3029
--- re: (ab|ab*)bc
--- s eval: "ABC"



