# vim:set ft= ts=4 sw=4 et fdm=marker:

use t::SRegex 'no_plan';

run_tests();

__DATA__

=== TEST 1: testinput1:65
--- re: ^(abc){1,2}zz
--- s eval: ">>abczz"



=== TEST 2: testinput1:68
--- re: ^(b+?|a){1,2}?c
--- s eval: "bc"



=== TEST 3: testinput1:69
--- re: ^(b+?|a){1,2}?c
--- s eval: "bbc"



=== TEST 4: testinput1:70
--- re: ^(b+?|a){1,2}?c
--- s eval: "bbbc"



=== TEST 5: testinput1:71
--- re: ^(b+?|a){1,2}?c
--- s eval: "bac"



=== TEST 6: testinput1:72
--- re: ^(b+?|a){1,2}?c
--- s eval: "bbac"



=== TEST 7: testinput1:73
--- re: ^(b+?|a){1,2}?c
--- s eval: "aac"



=== TEST 8: testinput1:74
--- re: ^(b+?|a){1,2}?c
--- s eval: "abbbbbbbbbbbc"



=== TEST 9: testinput1:75
--- re: ^(b+?|a){1,2}?c
--- s eval: "bbbbbbbbbbbac"



=== TEST 10: testinput1:76
--- re: ^(b+?|a){1,2}?c
--- s eval: "*** Failers"



=== TEST 11: testinput1:77
--- re: ^(b+?|a){1,2}?c
--- s eval: "aaac"



=== TEST 12: testinput1:78
--- re: ^(b+?|a){1,2}?c
--- s eval: "abbbbbbbbbbbac"



=== TEST 13: testinput1:81
--- re: ^(b+|a){1,2}c
--- s eval: "bc"



=== TEST 14: testinput1:82
--- re: ^(b+|a){1,2}c
--- s eval: "bbc"



=== TEST 15: testinput1:83
--- re: ^(b+|a){1,2}c
--- s eval: "bbbc"



=== TEST 16: testinput1:84
--- re: ^(b+|a){1,2}c
--- s eval: "bac"



=== TEST 17: testinput1:85
--- re: ^(b+|a){1,2}c
--- s eval: "bbac"



=== TEST 18: testinput1:86
--- re: ^(b+|a){1,2}c
--- s eval: "aac"



=== TEST 19: testinput1:87
--- re: ^(b+|a){1,2}c
--- s eval: "abbbbbbbbbbbc"



=== TEST 20: testinput1:88
--- re: ^(b+|a){1,2}c
--- s eval: "bbbbbbbbbbbac"



=== TEST 21: testinput1:89
--- re: ^(b+|a){1,2}c
--- s eval: "*** Failers"



=== TEST 22: testinput1:90
--- re: ^(b+|a){1,2}c
--- s eval: "aaac"



=== TEST 23: testinput1:91
--- re: ^(b+|a){1,2}c
--- s eval: "abbbbbbbbbbbac"



=== TEST 24: testinput1:94
--- re: ^(b+|a){1,2}?bc
--- s eval: "bbc"



=== TEST 25: testinput1:97
--- re: ^(b*|ba){1,2}?bc
--- s eval: "babc"



=== TEST 26: testinput1:98
--- re: ^(b*|ba){1,2}?bc
--- s eval: "bbabc"



=== TEST 27: testinput1:99
--- re: ^(b*|ba){1,2}?bc
--- s eval: "bababc"



=== TEST 28: testinput1:100
--- re: ^(b*|ba){1,2}?bc
--- s eval: "*** Failers"



=== TEST 29: testinput1:101
--- re: ^(b*|ba){1,2}?bc
--- s eval: "bababbc"



=== TEST 30: testinput1:102
--- re: ^(b*|ba){1,2}?bc
--- s eval: "babababc"



=== TEST 31: testinput1:105
--- re: ^(ba|b*){1,2}?bc
--- s eval: "babc"



=== TEST 32: testinput1:106
--- re: ^(ba|b*){1,2}?bc
--- s eval: "bbabc"



=== TEST 33: testinput1:107
--- re: ^(ba|b*){1,2}?bc
--- s eval: "bababc"



=== TEST 34: testinput1:108
--- re: ^(ba|b*){1,2}?bc
--- s eval: "*** Failers"



=== TEST 35: testinput1:109
--- re: ^(ba|b*){1,2}?bc
--- s eval: "bababbc"



=== TEST 36: testinput1:110
--- re: ^(ba|b*){1,2}?bc
--- s eval: "babababc"



=== TEST 37: testinput1:113
--- re: ^\ca\cA\c[\c{\c:
--- s eval: "\x01\x01\e;z"



=== TEST 38: testinput1:116
--- re: ^[ab\]cde]
--- s eval: "athing"



=== TEST 39: testinput1:117
--- re: ^[ab\]cde]
--- s eval: "bthing"



=== TEST 40: testinput1:118
--- re: ^[ab\]cde]
--- s eval: "]thing"



=== TEST 41: testinput1:119
--- re: ^[ab\]cde]
--- s eval: "cthing"



=== TEST 42: testinput1:120
--- re: ^[ab\]cde]
--- s eval: "dthing"



=== TEST 43: testinput1:121
--- re: ^[ab\]cde]
--- s eval: "ething"



=== TEST 44: testinput1:122
--- re: ^[ab\]cde]
--- s eval: "*** Failers"



=== TEST 45: testinput1:123
--- re: ^[ab\]cde]
--- s eval: "fthing"



=== TEST 46: testinput1:124
--- re: ^[ab\]cde]
--- s eval: "[thing"



=== TEST 47: testinput1:125
--- re: ^[ab\]cde]
--- s eval: "\\thing"



=== TEST 48: testinput1:128
--- re: ^[]cde]
--- s eval: "]thing"



=== TEST 49: testinput1:129
--- re: ^[]cde]
--- s eval: "cthing"



=== TEST 50: testinput1:130
--- re: ^[]cde]
--- s eval: "dthing"



