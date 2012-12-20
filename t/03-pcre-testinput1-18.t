# vim:set ft= ts=4 sw=4 et fdm=marker:

use t::SRegex 'no_plan';

run_tests();

__DATA__

=== TEST 1: testinput1:3159
--- re: a(?:b|c|d){5,6}?(.)
--- s eval: "acdbcdbe"



=== TEST 2: testinput1:3162
--- re: a(?:b|c|d){5,7}(.)
--- s eval: "acdbcdbe"



=== TEST 3: testinput1:3165
--- re: a(?:b|c|d){5,7}?(.)
--- s eval: "acdbcdbe"



=== TEST 4: testinput1:3168
--- re: a(?:b|(c|e){1,2}?|d)+?(.)
--- s eval: "ace"



=== TEST 5: testinput1:3171
--- re: ^(.+)?B
--- s eval: "AB"



=== TEST 6: testinput1:3174
--- re: ^([^a-z])|(\^)$
--- s eval: "."



=== TEST 7: testinput1:3177
--- re: ^[<>]&
--- s eval: "<&OUT"



=== TEST 8: testinput1:3193
--- re: (?:(f)(o)(o)|(b)(a)(r))*
--- s eval: "foobar"



=== TEST 9: testinput1:3207
--- re: (?:..)*a
--- s eval: "aba"



=== TEST 10: testinput1:3210
--- re: (?:..)*?a
--- s eval: "aba"



=== TEST 11: testinput1:3216
--- re: ^(){3,5}
--- s eval: "abc"



=== TEST 12: testinput1:3219
--- re: ^(a+)*ax
--- s eval: "aax"



=== TEST 13: testinput1:3222
--- re: ^((a|b)+)*ax
--- s eval: "aax"



=== TEST 14: testinput1:3225
--- re: ^((a|bc)+)*ax
--- s eval: "aax"



=== TEST 15: testinput1:3228
--- re: (a|x)*ab
--- s eval: "cab"



=== TEST 16: testinput1:3231
--- re: (a)*ab
--- s eval: "cab"



=== TEST 17: testinput1:3344
--- re: (?:c|d)(?:)(?:a(?:)(?:b)(?:b(?:))(?:b(?:)(?:b)))
--- s eval: "cabbbb"



=== TEST 18: testinput1:3347
--- re: (?:c|d)(?:)(?:aaaaaaaa(?:)(?:bbbbbbbb)(?:bbbbbbbb(?:))(?:bbbbbbbb(?:)(?:bbbbbbbb)))
--- s eval: "caaaaaaaabbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb"



=== TEST 19: testinput1:3354
--- re: foo\w*\d{4}baz
--- s eval: "foobar1234baz"



=== TEST 20: testinput1:3357
--- re: x(~~)*(?:(?:F)?)?
--- s eval: "x~~"



=== TEST 21: testinput1:3382
--- re: ^(?:a?b?)*$
--- s eval: ""



=== TEST 22: testinput1:3383
--- re: ^(?:a?b?)*$
--- s eval: "a"



=== TEST 23: testinput1:3384
--- re: ^(?:a?b?)*$
--- s eval: "ab"



=== TEST 24: testinput1:3385
--- re: ^(?:a?b?)*$
--- s eval: "aaa   "



=== TEST 25: testinput1:3386
--- re: ^(?:a?b?)*$
--- s eval: "*** Failers"



=== TEST 26: testinput1:3387
--- re: ^(?:a?b?)*$
--- s eval: "dbcb"



=== TEST 27: testinput1:3388
--- re: ^(?:a?b?)*$
--- s eval: "a--"



=== TEST 28: testinput1:3389
--- re: ^(?:a?b?)*$
--- s eval: "aa-- "



=== TEST 29: testinput1:3420
--- re: ()^b
--- s eval: "*** Failers"



=== TEST 30: testinput1:3421
--- re: ()^b
--- s eval: "a\nb\nc\n"



=== TEST 31: testinput1:3477
--- re: (\w+:)+
--- s eval: "one:"



=== TEST 32: testinput1:3491
--- re: ([\w:]+::)?(\w+)$
--- s eval: "abcd"



=== TEST 33: testinput1:3492
--- re: ([\w:]+::)?(\w+)$
--- s eval: "xy:z:::abcd"



=== TEST 34: testinput1:3495
--- re: ^[^bcd]*(c+)
--- s eval: "aexycd"



=== TEST 35: testinput1:3498
--- re: (a*)b+
--- s eval: "caab"



=== TEST 36: testinput1:3503
--- re: ([\w:]+::)?(\w+)$
--- s eval: "*** Failers"



=== TEST 37: testinput1:3504
--- re: ([\w:]+::)?(\w+)$
--- s eval: "abcd:"



=== TEST 38: testinput1:3516
--- re: ([[:]+)
--- s eval: "a:[b]:"



=== TEST 39: testinput1:3519
--- re: ([[=]+)
--- s eval: "a=[b]="



=== TEST 40: testinput1:3522
--- re: ([[.]+)
--- s eval: "a.[b]."



=== TEST 41: testinput1:3547
--- re: b\z
--- s eval: "a\nb"



=== TEST 42: testinput1:3548
--- re: b\z
--- s eval: "*** Failers"



=== TEST 43: testinput1:3640
--- re: ((Z)+|A)*
--- s eval: "ZABCDEFG"



=== TEST 44: testinput1:3643
--- re: (Z()|A)*
--- s eval: "ZABCDEFG"



=== TEST 45: testinput1:3646
--- re: (Z(())|A)*
--- s eval: "ZABCDEFG"



=== TEST 46: testinput1:3655
--- re: a*
--- s eval: "abbab"



=== TEST 47: testinput1:3658
--- re: ^[a-\d]
--- s eval: "abcde"



=== TEST 48: testinput1:3659
--- re: ^[a-\d]
--- s eval: "-things"



=== TEST 49: testinput1:3660
--- re: ^[a-\d]
--- s eval: "0digit"



=== TEST 50: testinput1:3661
--- re: ^[a-\d]
--- s eval: "*** Failers"



