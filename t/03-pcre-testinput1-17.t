# vim:set ft= ts=4 sw=4 et fdm=marker:

use t::SRegex 'no_plan';

run_tests();

__DATA__

=== TEST 1: testinput1:3007
--- re: abcd*efg
--- s eval: "ABCDEFG"
--- flags: i



=== TEST 2: testinput1:3010
--- re: ab*
--- s eval: "XABYABBBZ"
--- flags: i



=== TEST 3: testinput1:3011
--- re: ab*
--- s eval: "XAYABBBZ"
--- flags: i



=== TEST 4: testinput1:3014
--- re: (ab|cd)e
--- s eval: "ABCDE"
--- flags: i



=== TEST 5: testinput1:3017
--- re: [abhgefdc]ij
--- s eval: "HIJ"
--- flags: i



=== TEST 6: testinput1:3020
--- re: ^(ab|cd)e
--- s eval: "ABCDE"
--- flags: i



=== TEST 7: testinput1:3023
--- re: (abc|)ef
--- s eval: "ABCDEF"
--- flags: i



=== TEST 8: testinput1:3026
--- re: (a|b)c*d
--- s eval: "ABCD"
--- flags: i



=== TEST 9: testinput1:3029
--- re: (ab|ab*)bc
--- s eval: "ABC"
--- flags: i



=== TEST 10: testinput1:3032
--- re: a([bc]*)c*
--- s eval: "ABC"
--- flags: i



=== TEST 11: testinput1:3035
--- re: a([bc]*)(c*d)
--- s eval: "ABCD"
--- flags: i



=== TEST 12: testinput1:3038
--- re: a([bc]+)(c*d)
--- s eval: "ABCD"
--- flags: i



=== TEST 13: testinput1:3041
--- re: a([bc]*)(c+d)
--- s eval: "ABCD"
--- flags: i



=== TEST 14: testinput1:3044
--- re: a[bcd]*dcdcde
--- s eval: "ADCDCDE"
--- flags: i



=== TEST 15: testinput1:3049
--- re: (ab|a)b*c
--- s eval: "ABC"
--- flags: i



=== TEST 16: testinput1:3052
--- re: ((a)(b)c)(d)
--- s eval: "ABCD"
--- flags: i



=== TEST 17: testinput1:3055
--- re: [a-zA-Z_][a-zA-Z0-9_]*
--- s eval: "ALPHA"
--- flags: i



=== TEST 18: testinput1:3058
--- re: ^a(bc+|b[eh])g|.h$
--- s eval: "ABH"
--- flags: i



=== TEST 19: testinput1:3061
--- re: (bc+d$|ef*g.|h?i(j|k))
--- s eval: "EFFGZ"
--- flags: i



=== TEST 20: testinput1:3062
--- re: (bc+d$|ef*g.|h?i(j|k))
--- s eval: "IJ"
--- flags: i



=== TEST 21: testinput1:3063
--- re: (bc+d$|ef*g.|h?i(j|k))
--- s eval: "REFFGZ"
--- flags: i



=== TEST 22: testinput1:3064
--- re: (bc+d$|ef*g.|h?i(j|k))
--- s eval: "*** Failers"
--- flags: i



=== TEST 23: testinput1:3065
--- re: (bc+d$|ef*g.|h?i(j|k))
--- s eval: "ADCDCDE"
--- flags: i



=== TEST 24: testinput1:3066
--- re: (bc+d$|ef*g.|h?i(j|k))
--- s eval: "EFFG"
--- flags: i



=== TEST 25: testinput1:3067
--- re: (bc+d$|ef*g.|h?i(j|k))
--- s eval: "BCDD"
--- flags: i



=== TEST 26: testinput1:3070
--- re: ((((((((((a))))))))))
--- s eval: "A"
--- flags: i



=== TEST 27: testinput1:3076
--- re: (((((((((a)))))))))
--- s eval: "A"
--- flags: i



=== TEST 28: testinput1:3079
--- re: (?:(?:(?:(?:(?:(?:(?:(?:(?:(a))))))))))
--- s eval: "A"
--- flags: i



=== TEST 29: testinput1:3082
--- re: (?:(?:(?:(?:(?:(?:(?:(?:(?:(a|b|c))))))))))
--- s eval: "C"
--- flags: i



=== TEST 30: testinput1:3085
--- re: multiple words of text
--- s eval: "*** Failers"
--- flags: i



=== TEST 31: testinput1:3086
--- re: multiple words of text
--- s eval: "AA"
--- flags: i



=== TEST 32: testinput1:3087
--- re: multiple words of text
--- s eval: "UH-UH"
--- flags: i



=== TEST 33: testinput1:3090
--- re: multiple words
--- s eval: "MULTIPLE WORDS, YEAH"
--- flags: i



=== TEST 34: testinput1:3093
--- re: (.*)c(.*)
--- s eval: "ABCDE"
--- flags: i



=== TEST 35: testinput1:3096
--- re: \((.*), (.*)\)
--- s eval: "(A, B)"
--- flags: i



=== TEST 36: testinput1:3101
--- re: abcd
--- s eval: "ABCD"
--- flags: i



=== TEST 37: testinput1:3104
--- re: a(bc)d
--- s eval: "ABCD"
--- flags: i



=== TEST 38: testinput1:3107
--- re: a[-]?c
--- s eval: "AC"
--- flags: i



=== TEST 39: testinput1:3125
--- re: a(?:b|c|d)(.)
--- s eval: "ace"



=== TEST 40: testinput1:3128
--- re: a(?:b|c|d)*(.)
--- s eval: "ace"



=== TEST 41: testinput1:3131
--- re: a(?:b|c|d)+?(.)
--- s eval: "ace"



=== TEST 42: testinput1:3132
--- re: a(?:b|c|d)+?(.)
--- s eval: "acdbcdbe"



=== TEST 43: testinput1:3135
--- re: a(?:b|c|d)+(.)
--- s eval: "acdbcdbe"



=== TEST 44: testinput1:3138
--- re: a(?:b|c|d){2}(.)
--- s eval: "acdbcdbe"



=== TEST 45: testinput1:3141
--- re: a(?:b|c|d){4,5}(.)
--- s eval: "acdbcdbe"



=== TEST 46: testinput1:3144
--- re: a(?:b|c|d){4,5}?(.)
--- s eval: "acdbcdbe"



=== TEST 47: testinput1:3147
--- re: ((foo)|(bar))*
--- s eval: "foobar"



=== TEST 48: testinput1:3150
--- re: a(?:b|c|d){6,7}(.)
--- s eval: "acdbcdbe"



=== TEST 49: testinput1:3153
--- re: a(?:b|c|d){6,7}?(.)
--- s eval: "acdbcdbe"



=== TEST 50: testinput1:3156
--- re: a(?:b|c|d){5,6}(.)
--- s eval: "acdbcdbe"



