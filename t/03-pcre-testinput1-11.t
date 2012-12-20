# vim:set ft= ts=4 sw=4 et fdm=marker:

use t::SRegex 'no_plan';

run_tests();

__DATA__

=== TEST 1: testinput1:1900
--- re: a[^a]b
--- s eval: "acb"



=== TEST 2: testinput1:1901
--- re: a[^a]b
--- s eval: "a\nb"



=== TEST 3: testinput1:1904
--- re: a.b
--- s eval: "acb"



=== TEST 4: testinput1:1905
--- re: a.b
--- s eval: "*** Failers "



=== TEST 5: testinput1:1906
--- re: a.b
--- s eval: "a\nb   "



=== TEST 6: testinput1:1910
--- re: a[^a]b
--- s eval: "a\nb  "



=== TEST 7: testinput1:1914
--- re: a.b
--- s eval: "a\nb  "



=== TEST 8: testinput1:1919
--- re: ^(b+?|a){1,2}?c
--- s eval: "bbbac"



=== TEST 9: testinput1:1920
--- re: ^(b+?|a){1,2}?c
--- s eval: "bbbbac"



=== TEST 10: testinput1:1921
--- re: ^(b+?|a){1,2}?c
--- s eval: "bbbbbac "



=== TEST 11: testinput1:1924
--- re: ^(b+|a){1,2}?c
--- s eval: "bac"



=== TEST 12: testinput1:1925
--- re: ^(b+|a){1,2}?c
--- s eval: "bbac"



=== TEST 13: testinput1:1926
--- re: ^(b+|a){1,2}?c
--- s eval: "bbbac"



=== TEST 14: testinput1:1927
--- re: ^(b+|a){1,2}?c
--- s eval: "bbbbac"



=== TEST 15: testinput1:1928
--- re: ^(b+|a){1,2}?c
--- s eval: "bbbbbac "



=== TEST 16: testinput1:1935
--- re: \x0{ab}
--- s eval: "\0{ab} "



=== TEST 17: testinput1:1938
--- re: (A|B)*?CD
--- s eval: "CD "



=== TEST 18: testinput1:1941
--- re: (A|B)*CD
--- s eval: "CD "



=== TEST 19: testinput1:1972
--- re: \Aabc\z
--- s eval: "abc"



=== TEST 20: testinput1:1973
--- re: \Aabc\z
--- s eval: "*** Failers"



=== TEST 21: testinput1:1974
--- re: \Aabc\z
--- s eval: "abc\n   "



=== TEST 22: testinput1:1975
--- re: \Aabc\z
--- s eval: "qqq\nabc"



=== TEST 23: testinput1:1976
--- re: \Aabc\z
--- s eval: "abc\nzzz"



=== TEST 24: testinput1:1977
--- re: \Aabc\z
--- s eval: "qqq\nabc\nzzz"



=== TEST 25: testinput1:1980
--- re: \Aabc\z
--- s eval: "/this/is/a/very/long/line/in/deed/with/very/many/slashes/in/it/you/see/"



=== TEST 26: testinput1:1983
--- re: \Aabc\z
--- s eval: "/this/is/a/very/long/line/in/deed/with/very/many/slashes/in/and/foo"



=== TEST 27: testinput1:1997
--- re: (\d+)(\w)
--- s eval: "12345a"



=== TEST 28: testinput1:1998
--- re: (\d+)(\w)
--- s eval: "12345+ "



=== TEST 29: testinput1:2210
--- re: (abc|)+
--- s eval: "abc"
--- cap: (0, 3) (0, 3)



=== TEST 30: testinput1:2211
--- re: (abc|)+
--- s eval: "abcabc"
--- cap: (0, 6) (3, 6)



=== TEST 31: testinput1:2212
--- re: (abc|)+
--- s eval: "abcabcabc"
--- cap: (0, 9) (6, 9)



=== TEST 32: testinput1:2213
--- re: (abc|)+
--- s eval: "xyz      "



=== TEST 33: testinput1:2216
--- re: ([a]*)*
--- s eval: "a"
--- cap: (0, 1) (0, 1)



=== TEST 34: testinput1:2217
--- re: ([a]*)*
--- s eval: "aaaaa "
--- cap: (0, 5) (0, 5)



=== TEST 35: testinput1:2220
--- re: ([ab]*)*
--- s eval: "a"
--- cap: (0, 1) (0, 1)



=== TEST 36: testinput1:2221
--- re: ([ab]*)*
--- s eval: "b"
--- cap: (0, 1) (0, 1)



=== TEST 37: testinput1:2222
--- re: ([ab]*)*
--- s eval: "ababab"
--- cap: (0, 6) (0, 6)



=== TEST 38: testinput1:2223
--- re: ([ab]*)*
--- s eval: "aaaabcde"
--- cap: (0, 5) (0, 5)



=== TEST 39: testinput1:2224
--- re: ([ab]*)*
--- s eval: "bbbb    "
--- cap: (0, 4) (0, 4)



=== TEST 40: testinput1:2227
--- re: ([^a]*)*
--- s eval: "b"
--- cap: (0, 1) (0, 1)



=== TEST 41: testinput1:2228
--- re: ([^a]*)*
--- s eval: "bbbb"
--- cap: (0, 4) (0, 4)



=== TEST 42: testinput1:2229
--- re: ([^a]*)*
--- s eval: "aaa   "



=== TEST 43: testinput1:2232
--- re: ([^ab]*)*
--- s eval: "cccc"
--- cap: (0, 4) (0, 4)



=== TEST 44: testinput1:2233
--- re: ([^ab]*)*
--- s eval: "abab  "



=== TEST 45: testinput1:2236
--- re: ([a]*?)*
--- s eval: "a"



=== TEST 46: testinput1:2237
--- re: ([a]*?)*
--- s eval: "aaaa "



=== TEST 47: testinput1:2240
--- re: ([ab]*?)*
--- s eval: "a"



=== TEST 48: testinput1:2241
--- re: ([ab]*?)*
--- s eval: "b"



=== TEST 49: testinput1:2242
--- re: ([ab]*?)*
--- s eval: "abab"



=== TEST 50: testinput1:2243
--- re: ([ab]*?)*
--- s eval: "baba   "



