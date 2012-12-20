# vim:set ft= ts=4 sw=4 et fdm=marker:

use t::SRegex 'no_plan';

run_tests();

__DATA__

=== TEST 1: testinput1:4033
--- re: [[:abcd:xyz]]
--- s eval: ":] "



=== TEST 2: testinput1:4036
--- re: [abc[:x\]pqr]
--- s eval: "a"



=== TEST 3: testinput1:4037
--- re: [abc[:x\]pqr]
--- s eval: "["



=== TEST 4: testinput1:4038
--- re: [abc[:x\]pqr]
--- s eval: ":"



=== TEST 5: testinput1:4039
--- re: [abc[:x\]pqr]
--- s eval: "]"



=== TEST 6: testinput1:4040
--- re: [abc[:x\]pqr]
--- s eval: "p    "



=== TEST 7: testinput1:4043
--- re: .*[op][xyz]
--- s eval: "fooabcfoo"



=== TEST 8: testinput1:4078
--- re: [\x00-\xff\s]+
--- s eval: "\x0a\x0b\x0c\x0d"



=== TEST 9: testinput1:4081
--- re: ^\c
--- s eval: "?"



=== TEST 10: testinput1:4090
--- re: [^a]*
--- s eval: "12abc"
--- flags: i



=== TEST 11: testinput1:4091
--- re: [^a]*
--- s eval: "12ABC"
--- flags: i



=== TEST 12: testinput1:4098
--- re: [^a]*?X
--- s eval: "** Failers"
--- flags: i



=== TEST 13: testinput1:4099
--- re: [^a]*?X
--- s eval: "12abc"
--- flags: i



=== TEST 14: testinput1:4100
--- re: [^a]*?X
--- s eval: "12ABC"
--- flags: i



=== TEST 15: testinput1:4103
--- re: [^a]+?X
--- s eval: "** Failers"
--- flags: i



=== TEST 16: testinput1:4104
--- re: [^a]+?X
--- s eval: "12abc"
--- flags: i



=== TEST 17: testinput1:4105
--- re: [^a]+?X
--- s eval: "12ABC"
--- flags: i



=== TEST 18: testinput1:4108
--- re: [^a]?X
--- s eval: "12aXbcX"
--- flags: i



=== TEST 19: testinput1:4109
--- re: [^a]?X
--- s eval: "12AXBCX"
--- flags: i



=== TEST 20: testinput1:4110
--- re: [^a]?X
--- s eval: "BCX "
--- flags: i



=== TEST 21: testinput1:4113
--- re: [^a]??X
--- s eval: "12aXbcX"
--- flags: i



=== TEST 22: testinput1:4114
--- re: [^a]??X
--- s eval: "12AXBCX"
--- flags: i



=== TEST 23: testinput1:4115
--- re: [^a]??X
--- s eval: "BCX"
--- flags: i



=== TEST 24: testinput1:4123
--- re: [^a]{2,3}
--- s eval: "abcdef"
--- flags: i



=== TEST 25: testinput1:4124
--- re: [^a]{2,3}
--- s eval: "ABCDEF  "
--- flags: i



=== TEST 26: testinput1:4127
--- re: [^a]{2,3}?
--- s eval: "abcdef"
--- flags: i



=== TEST 27: testinput1:4128
--- re: [^a]{2,3}?
--- s eval: "ABCDEF  "
--- flags: i



=== TEST 28: testinput1:4135
--- re: ((a|)+)+Z
--- s eval: "Z"



=== TEST 29: testinput1:4138
--- re: (a)b|(a)c
--- s eval: "ac"



=== TEST 30: testinput1:4177
--- re: (?:a+|ab)+c
--- s eval: "aabc"



=== TEST 31: testinput1:4192
--- re: ^(?:a|ab)+c
--- s eval: "aaaabc"



=== TEST 32: testinput1:4253
--- re: [:a]xxx[b:]
--- s eval: ":xxx:"



=== TEST 33: testinput1:4310
--- re: ab\Cde
--- s eval: "abXde"



=== TEST 34: testinput1:4316
--- re: a[\CD]b
--- s eval: "aCb"



=== TEST 35: testinput1:4317
--- re: a[\CD]b
--- s eval: "aDb "



=== TEST 36: testinput1:4320
--- re: a[\C-X]b
--- s eval: "aJb"



=== TEST 37: testinput1:4323
--- re: \H\h\V\v
--- s eval: "X X\x0a"



=== TEST 38: testinput1:4324
--- re: \H\h\V\v
--- s eval: "X\x09X\x0b"



=== TEST 39: testinput1:4325
--- re: \H\h\V\v
--- s eval: "** Failers"



=== TEST 40: testinput1:4326
--- re: \H\h\V\v
--- s eval: "\xa0 X\x0a   "



=== TEST 41: testinput1:4329
--- re: \H*\h+\V?\v{3,4}
--- s eval: "\x09\x20\xa0X\x0a\x0b\x0c\x0d\x0a"



=== TEST 42: testinput1:4330
--- re: \H*\h+\V?\v{3,4}
--- s eval: "\x09\x20\xa0\x0a\x0b\x0c\x0d\x0a"



=== TEST 43: testinput1:4331
--- re: \H*\h+\V?\v{3,4}
--- s eval: "\x09\x20\xa0\x0a\x0b\x0c"



=== TEST 44: testinput1:4332
--- re: \H*\h+\V?\v{3,4}
--- s eval: "** Failers "



=== TEST 45: testinput1:4333
--- re: \H*\h+\V?\v{3,4}
--- s eval: "\x09\x20\xa0\x0a\x0b"



=== TEST 46: testinput1:4336
--- re: \H{3,4}
--- s eval: "XY  ABCDE"



=== TEST 47: testinput1:4337
--- re: \H{3,4}
--- s eval: "XY  PQR ST "



=== TEST 48: testinput1:4340
--- re: .\h{3,4}.
--- s eval: "XY  AB    PQRS"



=== TEST 49: testinput1:4343
--- re: \h*X\h?\H+Y\H?Z
--- s eval: ">XNNNYZ"



=== TEST 50: testinput1:4344
--- re: \h*X\h?\H+Y\H?Z
--- s eval: ">  X NYQZ"



