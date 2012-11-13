# vim:set ft= ts=4 sw=4 et fdm=marker:

use t::SRegex 'no_plan';

run_tests();

__DATA__

=== TEST 1: re_tests:9
--- re: abc
--- s eval: "abc"



=== TEST 2: re_tests:12
--- re: abc
--- s eval: "xbc"



=== TEST 3: re_tests:13
--- re: abc
--- s eval: "axc"



=== TEST 4: re_tests:14
--- re: abc
--- s eval: "abx"



=== TEST 5: re_tests:15
--- re: abc
--- s eval: "xabcy"



=== TEST 6: re_tests:18
--- re: abc
--- s eval: "ababc"



=== TEST 7: re_tests:21
--- re: ab*c
--- s eval: "abc"



=== TEST 8: re_tests:24
--- re: ab*bc
--- s eval: "abc"



=== TEST 9: re_tests:27
--- re: ab*bc
--- s eval: "abbc"



=== TEST 10: re_tests:30
--- re: ab*bc
--- s eval: "abbbbc"



=== TEST 11: re_tests:33
--- re: .{1}
--- s eval: "abbbbc"



=== TEST 12: re_tests:36
--- re: .{3,4}
--- s eval: "abbbbc"



=== TEST 13: re_tests:42
--- re: \N {1}
--- s eval: "abbbbc"



=== TEST 14: re_tests:48
--- re: \N {3,4}
--- s eval: "abbbbc"



=== TEST 15: re_tests:51
--- re: ab{0,}bc
--- s eval: "abbbbc"



=== TEST 16: re_tests:54
--- re: ab+bc
--- s eval: "abbc"



=== TEST 17: re_tests:57
--- re: ab+bc
--- s eval: "abc"



=== TEST 18: re_tests:58
--- re: ab+bc
--- s eval: "abq"



=== TEST 19: re_tests:59
--- re: ab{1,}bc
--- s eval: "abq"



=== TEST 20: re_tests:60
--- re: ab+bc
--- s eval: "abbbbc"



=== TEST 21: re_tests:63
--- re: ab{1,}bc
--- s eval: "abbbbc"



=== TEST 22: re_tests:66
--- re: ab{1,3}bc
--- s eval: "abbbbc"



=== TEST 23: re_tests:69
--- re: ab{3,4}bc
--- s eval: "abbbbc"



=== TEST 24: re_tests:72
--- re: ab{4,5}bc
--- s eval: "abbbbc"



=== TEST 25: re_tests:73
--- re: ab?bc
--- s eval: "abbc"



=== TEST 26: re_tests:74
--- re: ab?bc
--- s eval: "abc"



=== TEST 27: re_tests:75
--- re: ab{0,1}bc
--- s eval: "abc"



=== TEST 28: re_tests:76
--- re: ab?bc
--- s eval: "abbbbc"



=== TEST 29: re_tests:77
--- re: ab?c
--- s eval: "abc"



=== TEST 30: re_tests:78
--- re: ab{0,1}c
--- s eval: "abc"



=== TEST 31: re_tests:79
--- re: ^abc$
--- s eval: "abc"



=== TEST 32: re_tests:80
--- re: ^abc$
--- s eval: "abcc"



=== TEST 33: re_tests:81
--- re: ^abc
--- s eval: "abcc"



=== TEST 34: re_tests:82
--- re: ^abc$
--- s eval: "aabc"



=== TEST 35: re_tests:83
--- re: abc$
--- s eval: "aabc"



=== TEST 36: re_tests:84
--- re: abc$
--- s eval: "aabcd"



=== TEST 37: re_tests:85
--- re: ^
--- s eval: "abc"



=== TEST 38: re_tests:86
--- re: $
--- s eval: "abc"



=== TEST 39: re_tests:87
--- re: a.c
--- s eval: "abc"



=== TEST 40: re_tests:88
--- re: a.c
--- s eval: "axc"



=== TEST 41: re_tests:89
--- re: a\Nc
--- s eval: "abc"



=== TEST 42: re_tests:90
--- re: a\N c
--- s eval: "abc"



=== TEST 43: re_tests:91
--- re: a.*c
--- s eval: "axyzc"



=== TEST 44: re_tests:92
--- re: a\N*c
--- s eval: "axyzc"



=== TEST 45: re_tests:93
--- re: a\N *c
--- s eval: "axyzc"



=== TEST 46: re_tests:94
--- re: a.*c
--- s eval: "axyzd"



=== TEST 47: re_tests:95
--- re: a\N*c
--- s eval: "axyzd"



=== TEST 48: re_tests:96
--- re: a\N *c
--- s eval: "axyzd"



=== TEST 49: re_tests:97
--- re: a[bc]d
--- s eval: "abc"



=== TEST 50: re_tests:98
--- re: a[bc]d
--- s eval: "abd"



