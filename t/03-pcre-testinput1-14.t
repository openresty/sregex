# vim:set ft= ts=4 sw=4 et fdm=marker:

use t::SRegex 'no_plan';

run_tests();

__DATA__

=== TEST 1: testinput1:2606
--- re: a\(*b
--- s eval: "a((b"



=== TEST 2: testinput1:2609
--- re: a\\b
--- s eval: "a\b"



=== TEST 3: testinput1:2612
--- re: ((a))
--- s eval: "abc"



=== TEST 4: testinput1:2615
--- re: (a)b(c)
--- s eval: "abc"



=== TEST 5: testinput1:2618
--- re: a+b+c
--- s eval: "aabbabc"



=== TEST 6: testinput1:2621
--- re: a{1,}b{1,}c
--- s eval: "aabbabc"



=== TEST 7: testinput1:2624
--- re: a.+?c
--- s eval: "abcabc"



=== TEST 8: testinput1:2627
--- re: (a+|b)*
--- s eval: "ab"



=== TEST 9: testinput1:2630
--- re: (a+|b){0,}
--- s eval: "ab"



=== TEST 10: testinput1:2633
--- re: (a+|b)+
--- s eval: "ab"



=== TEST 11: testinput1:2636
--- re: (a+|b){1,}
--- s eval: "ab"



=== TEST 12: testinput1:2639
--- re: (a+|b)?
--- s eval: "ab"



=== TEST 13: testinput1:2642
--- re: (a+|b){0,1}
--- s eval: "ab"



=== TEST 14: testinput1:2645
--- re: [^ab]*
--- s eval: "cde"



=== TEST 15: testinput1:2649
--- re: abc
--- s eval: "b"



=== TEST 16: testinput1:2656
--- re: ([abc])*d
--- s eval: "abbbcd"



=== TEST 17: testinput1:2659
--- re: ([abc])*bcd
--- s eval: "abcd"



=== TEST 18: testinput1:2662
--- re: a|b|c|d|e
--- s eval: "e"



=== TEST 19: testinput1:2665
--- re: (a|b|c|d|e)f
--- s eval: "ef"



=== TEST 20: testinput1:2668
--- re: abcd*efg
--- s eval: "abcdefg"



=== TEST 21: testinput1:2671
--- re: ab*
--- s eval: "xabyabbbz"



=== TEST 22: testinput1:2672
--- re: ab*
--- s eval: "xayabbbz"



=== TEST 23: testinput1:2675
--- re: (ab|cd)e
--- s eval: "abcde"



=== TEST 24: testinput1:2678
--- re: [abhgefdc]ij
--- s eval: "hij"



=== TEST 25: testinput1:2683
--- re: (abc|)ef
--- s eval: "abcdef"



=== TEST 26: testinput1:2686
--- re: (a|b)c*d
--- s eval: "abcd"



=== TEST 27: testinput1:2689
--- re: (ab|ab*)bc
--- s eval: "abc"



=== TEST 28: testinput1:2692
--- re: a([bc]*)c*
--- s eval: "abc"



=== TEST 29: testinput1:2695
--- re: a([bc]*)(c*d)
--- s eval: "abcd"



=== TEST 30: testinput1:2698
--- re: a([bc]+)(c*d)
--- s eval: "abcd"



=== TEST 31: testinput1:2701
--- re: a([bc]*)(c+d)
--- s eval: "abcd"



=== TEST 32: testinput1:2704
--- re: a[bcd]*dcdcde
--- s eval: "adcdcde"



=== TEST 33: testinput1:2707
--- re: a[bcd]+dcdcde
--- s eval: "*** Failers"



=== TEST 34: testinput1:2708
--- re: a[bcd]+dcdcde
--- s eval: "abcde"



=== TEST 35: testinput1:2709
--- re: a[bcd]+dcdcde
--- s eval: "adcdcde"



=== TEST 36: testinput1:2712
--- re: (ab|a)b*c
--- s eval: "abc"



=== TEST 37: testinput1:2715
--- re: ((a)(b)c)(d)
--- s eval: "abcd"



=== TEST 38: testinput1:2718
--- re: [a-zA-Z_][a-zA-Z0-9_]*
--- s eval: "alpha"



=== TEST 39: testinput1:2721
--- re: ^a(bc+|b[eh])g|.h$
--- s eval: "abh"



=== TEST 40: testinput1:2724
--- re: (bc+d$|ef*g.|h?i(j|k))
--- s eval: "effgz"



=== TEST 41: testinput1:2725
--- re: (bc+d$|ef*g.|h?i(j|k))
--- s eval: "ij"



=== TEST 42: testinput1:2726
--- re: (bc+d$|ef*g.|h?i(j|k))
--- s eval: "reffgz"



=== TEST 43: testinput1:2727
--- re: (bc+d$|ef*g.|h?i(j|k))
--- s eval: "*** Failers"



=== TEST 44: testinput1:2728
--- re: (bc+d$|ef*g.|h?i(j|k))
--- s eval: "effg"



=== TEST 45: testinput1:2729
--- re: (bc+d$|ef*g.|h?i(j|k))
--- s eval: "bcdd"



=== TEST 46: testinput1:2732
--- re: ((((((((((a))))))))))
--- s eval: "a"



=== TEST 47: testinput1:2738
--- re: (((((((((a)))))))))
--- s eval: "a"



=== TEST 48: testinput1:2741
--- re: multiple words of text
--- s eval: "*** Failers"



=== TEST 49: testinput1:2742
--- re: multiple words of text
--- s eval: "aa"



=== TEST 50: testinput1:2743
--- re: multiple words of text
--- s eval: "uh-uh"



