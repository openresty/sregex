# vim:set ft= ts=4 sw=4 et fdm=marker:

use t::SRegex 'no_plan';

run_tests();

__DATA__

=== TEST 1: testinput1:131
--- re: ^[]cde]
--- s eval: "ething"



=== TEST 2: testinput1:132
--- re: ^[]cde]
--- s eval: "*** Failers"



=== TEST 3: testinput1:133
--- re: ^[]cde]
--- s eval: "athing"



=== TEST 4: testinput1:134
--- re: ^[]cde]
--- s eval: "fthing"



=== TEST 5: testinput1:137
--- re: ^[^ab\]cde]
--- s eval: "fthing"



=== TEST 6: testinput1:138
--- re: ^[^ab\]cde]
--- s eval: "[thing"



=== TEST 7: testinput1:139
--- re: ^[^ab\]cde]
--- s eval: "\\thing"



=== TEST 8: testinput1:140
--- re: ^[^ab\]cde]
--- s eval: "*** Failers"



=== TEST 9: testinput1:141
--- re: ^[^ab\]cde]
--- s eval: "athing"



=== TEST 10: testinput1:142
--- re: ^[^ab\]cde]
--- s eval: "bthing"



=== TEST 11: testinput1:143
--- re: ^[^ab\]cde]
--- s eval: "]thing"



=== TEST 12: testinput1:144
--- re: ^[^ab\]cde]
--- s eval: "cthing"



=== TEST 13: testinput1:145
--- re: ^[^ab\]cde]
--- s eval: "dthing"



=== TEST 14: testinput1:146
--- re: ^[^ab\]cde]
--- s eval: "ething"



=== TEST 15: testinput1:149
--- re: ^[^]cde]
--- s eval: "athing"



=== TEST 16: testinput1:150
--- re: ^[^]cde]
--- s eval: "fthing"



=== TEST 17: testinput1:151
--- re: ^[^]cde]
--- s eval: "*** Failers"



=== TEST 18: testinput1:152
--- re: ^[^]cde]
--- s eval: "]thing"



=== TEST 19: testinput1:153
--- re: ^[^]cde]
--- s eval: "cthing"



=== TEST 20: testinput1:154
--- re: ^[^]cde]
--- s eval: "dthing"



=== TEST 21: testinput1:155
--- re: ^[^]cde]
--- s eval: "ething"



=== TEST 22: testinput1:158
--- re: ^\Å
--- s eval: "Å"



=== TEST 23: testinput1:161
--- re: ^ˇ
--- s eval: "ˇ"



=== TEST 24: testinput1:164
--- re: ^[0-9]+$
--- s eval: "0"



=== TEST 25: testinput1:165
--- re: ^[0-9]+$
--- s eval: "1"



=== TEST 26: testinput1:166
--- re: ^[0-9]+$
--- s eval: "2"



=== TEST 27: testinput1:167
--- re: ^[0-9]+$
--- s eval: "3"



=== TEST 28: testinput1:168
--- re: ^[0-9]+$
--- s eval: "4"



=== TEST 29: testinput1:169
--- re: ^[0-9]+$
--- s eval: "5"



=== TEST 30: testinput1:170
--- re: ^[0-9]+$
--- s eval: "6"



=== TEST 31: testinput1:171
--- re: ^[0-9]+$
--- s eval: "7"



=== TEST 32: testinput1:172
--- re: ^[0-9]+$
--- s eval: "8"



=== TEST 33: testinput1:173
--- re: ^[0-9]+$
--- s eval: "9"



=== TEST 34: testinput1:174
--- re: ^[0-9]+$
--- s eval: "10"



=== TEST 35: testinput1:175
--- re: ^[0-9]+$
--- s eval: "100"



=== TEST 36: testinput1:176
--- re: ^[0-9]+$
--- s eval: "*** Failers"



=== TEST 37: testinput1:177
--- re: ^[0-9]+$
--- s eval: "abc"



=== TEST 38: testinput1:180
--- re: ^.*nter
--- s eval: "enter"



=== TEST 39: testinput1:181
--- re: ^.*nter
--- s eval: "inter"



=== TEST 40: testinput1:182
--- re: ^.*nter
--- s eval: "uponter"



=== TEST 41: testinput1:185
--- re: ^xxx[0-9]+$
--- s eval: "xxx0"



=== TEST 42: testinput1:186
--- re: ^xxx[0-9]+$
--- s eval: "xxx1234"



=== TEST 43: testinput1:187
--- re: ^xxx[0-9]+$
--- s eval: "*** Failers"



=== TEST 44: testinput1:188
--- re: ^xxx[0-9]+$
--- s eval: "xxx"



=== TEST 45: testinput1:191
--- re: ^.+[0-9][0-9][0-9]$
--- s eval: "x123"



=== TEST 46: testinput1:192
--- re: ^.+[0-9][0-9][0-9]$
--- s eval: "xx123"



=== TEST 47: testinput1:193
--- re: ^.+[0-9][0-9][0-9]$
--- s eval: "123456"



=== TEST 48: testinput1:194
--- re: ^.+[0-9][0-9][0-9]$
--- s eval: "*** Failers"



=== TEST 49: testinput1:195
--- re: ^.+[0-9][0-9][0-9]$
--- s eval: "123"



=== TEST 50: testinput1:196
--- re: ^.+[0-9][0-9][0-9]$
--- s eval: "x1234"



