# vim:set ft= ts=4 sw=4 et fdm=marker:

use t::SRegex 'no_plan';

run_tests();

__DATA__

=== TEST 1: testinput1:3032
--- re: a([bc]*)c*
--- s eval: "ABC"



=== TEST 2: testinput1:3035
--- re: a([bc]*)(c*d)
--- s eval: "ABCD"



=== TEST 3: testinput1:3038
--- re: a([bc]+)(c*d)
--- s eval: "ABCD"



=== TEST 4: testinput1:3041
--- re: a([bc]*)(c+d)
--- s eval: "ABCD"



=== TEST 5: testinput1:3044
--- re: a[bcd]*dcdcde
--- s eval: "ADCDCDE"



=== TEST 6: testinput1:3049
--- re: (ab|a)b*c
--- s eval: "ABC"



=== TEST 7: testinput1:3052
--- re: ((a)(b)c)(d)
--- s eval: "ABCD"



=== TEST 8: testinput1:3055
--- re: [a-zA-Z_][a-zA-Z0-9_]*
--- s eval: "ALPHA"



=== TEST 9: testinput1:3058
--- re: ^a(bc+|b[eh])g|.h$
--- s eval: "ABH"



=== TEST 10: testinput1:3061
--- re: (bc+d$|ef*g.|h?i(j|k))
--- s eval: "EFFGZ"



=== TEST 11: testinput1:3062
--- re: (bc+d$|ef*g.|h?i(j|k))
--- s eval: "IJ"



=== TEST 12: testinput1:3063
--- re: (bc+d$|ef*g.|h?i(j|k))
--- s eval: "REFFGZ"



=== TEST 13: testinput1:3065
--- re: (bc+d$|ef*g.|h?i(j|k))
--- s eval: "ADCDCDE"



=== TEST 14: testinput1:3066
--- re: (bc+d$|ef*g.|h?i(j|k))
--- s eval: "EFFG"



=== TEST 15: testinput1:3067
--- re: (bc+d$|ef*g.|h?i(j|k))
--- s eval: "BCDD"



=== TEST 16: testinput1:3070
--- re: ((((((((((a))))))))))
--- s eval: "A"



=== TEST 17: testinput1:3076
--- re: (((((((((a)))))))))
--- s eval: "A"



=== TEST 18: testinput1:3079
--- re: (?:(?:(?:(?:(?:(?:(?:(?:(?:(a))))))))))
--- s eval: "A"



=== TEST 19: testinput1:3082
--- re: (?:(?:(?:(?:(?:(?:(?:(?:(?:(a|b|c))))))))))
--- s eval: "C"



=== TEST 20: testinput1:3086
--- re: multiple words of text
--- s eval: "AA"



=== TEST 21: testinput1:3087
--- re: multiple words of text
--- s eval: "UH-UH"



=== TEST 22: testinput1:3090
--- re: multiple words
--- s eval: "MULTIPLE WORDS, YEAH"



=== TEST 23: testinput1:3093
--- re: (.*)c(.*)
--- s eval: "ABCDE"



=== TEST 24: testinput1:3096
--- re: \((.*), (.*)\)
--- s eval: "(A, B)"



=== TEST 25: testinput1:3101
--- re: abcd
--- s eval: "ABCD"



=== TEST 26: testinput1:3104
--- re: a(bc)d
--- s eval: "ABCD"



=== TEST 27: testinput1:3107
--- re: a[-]?c
--- s eval: "AC"



=== TEST 28: testinput1:3125
--- re: a(?:b|c|d)(.)
--- s eval: "ace"



=== TEST 29: testinput1:3128
--- re: a(?:b|c|d)*(.)
--- s eval: "ace"



=== TEST 30: testinput1:3131
--- re: a(?:b|c|d)+?(.)
--- s eval: "ace"



=== TEST 31: testinput1:3132
--- re: a(?:b|c|d)+?(.)
--- s eval: "acdbcdbe"



=== TEST 32: testinput1:3135
--- re: a(?:b|c|d)+(.)
--- s eval: "acdbcdbe"



=== TEST 33: testinput1:3138
--- re: a(?:b|c|d){2}(.)
--- s eval: "acdbcdbe"



=== TEST 34: testinput1:3141
--- re: a(?:b|c|d){4,5}(.)
--- s eval: "acdbcdbe"



=== TEST 35: testinput1:3144
--- re: a(?:b|c|d){4,5}?(.)
--- s eval: "acdbcdbe"



=== TEST 36: testinput1:3147
--- re: ((foo)|(bar))*
--- s eval: "foobar"



=== TEST 37: testinput1:3150
--- re: a(?:b|c|d){6,7}(.)
--- s eval: "acdbcdbe"



=== TEST 38: testinput1:3153
--- re: a(?:b|c|d){6,7}?(.)
--- s eval: "acdbcdbe"



=== TEST 39: testinput1:3156
--- re: a(?:b|c|d){5,6}(.)
--- s eval: "acdbcdbe"



=== TEST 40: testinput1:3159
--- re: a(?:b|c|d){5,6}?(.)
--- s eval: "acdbcdbe"



=== TEST 41: testinput1:3162
--- re: a(?:b|c|d){5,7}(.)
--- s eval: "acdbcdbe"



=== TEST 42: testinput1:3165
--- re: a(?:b|c|d){5,7}?(.)
--- s eval: "acdbcdbe"



=== TEST 43: testinput1:3168
--- re: a(?:b|(c|e){1,2}?|d)+?(.)
--- s eval: "ace"



=== TEST 44: testinput1:3171
--- re: ^(.+)?B
--- s eval: "AB"



=== TEST 45: testinput1:3174
--- re: ^([^a-z])|(\^)$
--- s eval: "."



=== TEST 46: testinput1:3177
--- re: ^[<>]&
--- s eval: "<&OUT"



=== TEST 47: testinput1:3193
--- re: (?:(f)(o)(o)|(b)(a)(r))*
--- s eval: "foobar"



=== TEST 48: testinput1:3207
--- re: (?:..)*a
--- s eval: "aba"



=== TEST 49: testinput1:3210
--- re: (?:..)*?a
--- s eval: "aba"



=== TEST 50: testinput1:3216
--- re: ^(){3,5}
--- s eval: "abc"



