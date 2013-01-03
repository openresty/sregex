# vim:set ft= ts=4 sw=4 et fdm=marker:

use t::SRegex 'no_plan';

run_tests();

__DATA__

=== TEST 1: re_tests:99
--- re: a[b]d
--- s eval: "abd"



=== TEST 2: re_tests:100
--- re: [a][b][d]
--- s eval: "abd"



=== TEST 3: re_tests:101
--- re: .[b].
--- s eval: "abd"



=== TEST 4: re_tests:102
--- re: .[b].
--- s eval: "aBd"



=== TEST 5: re_tests:105
--- re: a[b-d]e
--- s eval: "abd"



=== TEST 6: re_tests:106
--- re: a[b-d]e
--- s eval: "ace"



=== TEST 7: re_tests:107
--- re: a[b-d]
--- s eval: "aac"



=== TEST 8: re_tests:108
--- re: a[-b]
--- s eval: "a-"



=== TEST 9: re_tests:109
--- re: a[b-]
--- s eval: "a-"



=== TEST 10: re_tests:110
--- re: a[b-a]
--- s eval: "-"
--- err_like: ^\[error\] syntax error at pos \d+$



=== TEST 11: re_tests:111
--- re: a[]b
--- s eval: "-"
--- err_like: ^\[error\] syntax error at pos \d+$



=== TEST 12: re_tests:112
--- re: a[
--- s eval: "-"
--- err_like: ^\[error\] syntax error at pos \d+$



=== TEST 13: re_tests:113
--- re: a]
--- s eval: "a]"



=== TEST 14: re_tests:114
--- re: a[]]b
--- s eval: "a]b"



=== TEST 15: re_tests:115
--- re: a[^bc]d
--- s eval: "aed"



=== TEST 16: re_tests:116
--- re: a[^bc]d
--- s eval: "abd"



=== TEST 17: re_tests:117
--- re: a[^-b]c
--- s eval: "adc"



=== TEST 18: re_tests:118
--- re: a[^-b]c
--- s eval: "a-c"



=== TEST 19: re_tests:119
--- re: a[^]b]c
--- s eval: "a]c"



=== TEST 20: re_tests:120
--- re: a[^]b]c
--- s eval: "adc"



=== TEST 21: re_tests:121
--- re: \ba\b
--- s eval: "a-"



=== TEST 22: re_tests:122
--- re: \ba\b
--- s eval: "-a"



=== TEST 23: re_tests:123
--- re: \ba\b
--- s eval: "-a-"



=== TEST 24: re_tests:124
--- re: \by\b
--- s eval: "xy"



=== TEST 25: re_tests:125
--- re: \by\b
--- s eval: "yz"



=== TEST 26: re_tests:126
--- re: \by\b
--- s eval: "xyz"



=== TEST 27: re_tests:127
--- re: \Ba\B
--- s eval: "a-"



=== TEST 28: re_tests:128
--- re: \Ba\B
--- s eval: "-a"



=== TEST 29: re_tests:129
--- re: \Ba\B
--- s eval: "-a-"



=== TEST 30: re_tests:130
--- re: \By\b
--- s eval: "xy"



=== TEST 31: re_tests:134
--- re: \by\B
--- s eval: "yz"



=== TEST 32: re_tests:135
--- re: \By\B
--- s eval: "xyz"



=== TEST 33: re_tests:136
--- re: \w
--- s eval: "a"



=== TEST 34: re_tests:137
--- re: \w
--- s eval: "-"



=== TEST 35: re_tests:138
--- re: \W
--- s eval: "a"



=== TEST 36: re_tests:139
--- re: \W
--- s eval: "-"



=== TEST 37: re_tests:140
--- re: a\sb
--- s eval: "a b"



=== TEST 38: re_tests:141
--- re: a\sb
--- s eval: "a-b"



=== TEST 39: re_tests:142
--- re: a\Sb
--- s eval: "a b"



=== TEST 40: re_tests:143
--- re: a\Sb
--- s eval: "a-b"



=== TEST 41: re_tests:144
--- re: \d
--- s eval: "1"



=== TEST 42: re_tests:145
--- re: \d
--- s eval: "-"



=== TEST 43: re_tests:146
--- re: \D
--- s eval: "1"



=== TEST 44: re_tests:147
--- re: \D
--- s eval: "-"



=== TEST 45: re_tests:148
--- re: [\w]
--- s eval: "a"



=== TEST 46: re_tests:149
--- re: [\w]
--- s eval: "-"



=== TEST 47: re_tests:150
--- re: [\W]
--- s eval: "a"



=== TEST 48: re_tests:151
--- re: [\W]
--- s eval: "-"



=== TEST 49: re_tests:152
--- re: a[\s]b
--- s eval: "a b"



=== TEST 50: re_tests:153
--- re: a[\s]b
--- s eval: "a-b"



