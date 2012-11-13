# vim:set ft= ts=4 sw=4 et fdm=marker:

use t::SRegex 'no_plan';

run_tests();

__DATA__

=== TEST 1: testinput1:3219
--- re: ^(a+)*ax
--- s eval: "aax"



=== TEST 2: testinput1:3222
--- re: ^((a|b)+)*ax
--- s eval: "aax"



=== TEST 3: testinput1:3225
--- re: ^((a|bc)+)*ax
--- s eval: "aax"



=== TEST 4: testinput1:3228
--- re: (a|x)*ab
--- s eval: "cab"



=== TEST 5: testinput1:3231
--- re: (a)*ab
--- s eval: "cab"



=== TEST 6: testinput1:3344
--- re: (?:c|d)(?:)(?:a(?:)(?:b)(?:b(?:))(?:b(?:)(?:b)))
--- s eval: "cabbbb"



=== TEST 7: testinput1:3347
--- re: (?:c|d)(?:)(?:aaaaaaaa(?:)(?:bbbbbbbb)(?:bbbbbbbb(?:))(?:bbbbbbbb(?:)(?:bbbbbbbb)))
--- s eval: "caaaaaaaabbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb"



=== TEST 8: testinput1:3354
--- re: foo\w*\d{4}baz
--- s eval: "foobar1234baz"



=== TEST 9: testinput1:3357
--- re: x(~~)*(?:(?:F)?)?
--- s eval: "x~~"



=== TEST 10: testinput1:3382
--- re: ^(?:a?b?)*$
--- s eval: ""



=== TEST 11: testinput1:3383
--- re: ^(?:a?b?)*$
--- s eval: "a"



=== TEST 12: testinput1:3384
--- re: ^(?:a?b?)*$
--- s eval: "ab"



=== TEST 13: testinput1:3385
--- re: ^(?:a?b?)*$
--- s eval: "aaa   "



=== TEST 14: testinput1:3386
--- re: ^(?:a?b?)*$
--- s eval: "*** Failers"



=== TEST 15: testinput1:3387
--- re: ^(?:a?b?)*$
--- s eval: "dbcb"



=== TEST 16: testinput1:3388
--- re: ^(?:a?b?)*$
--- s eval: "a--"



=== TEST 17: testinput1:3389
--- re: ^(?:a?b?)*$
--- s eval: "aa-- "



=== TEST 18: testinput1:3420
--- re: ()^b
--- s eval: "*** Failers"



=== TEST 19: testinput1:3421
--- re: ()^b
--- s eval: "a\nb\nc\n"



=== TEST 20: testinput1:3477
--- re: (\w+:)+
--- s eval: "one:"



=== TEST 21: testinput1:3491
--- re: ([\w:]+::)?(\w+)$
--- s eval: "abcd"



=== TEST 22: testinput1:3492
--- re: ([\w:]+::)?(\w+)$
--- s eval: "xy:z:::abcd"



=== TEST 23: testinput1:3495
--- re: ^[^bcd]*(c+)
--- s eval: "aexycd"



=== TEST 24: testinput1:3498
--- re: (a*)b+
--- s eval: "caab"



=== TEST 25: testinput1:3503
--- re: ([\w:]+::)?(\w+)$
--- s eval: "*** Failers"



=== TEST 26: testinput1:3504
--- re: ([\w:]+::)?(\w+)$
--- s eval: "abcd:"



=== TEST 27: testinput1:3516
--- re: ([[:]+)
--- s eval: "a:[b]:"



=== TEST 28: testinput1:3519
--- re: ([[=]+)
--- s eval: "a=[b]="



=== TEST 29: testinput1:3522
--- re: ([[.]+)
--- s eval: "a.[b]."



=== TEST 30: testinput1:3547
--- re: b\z
--- s eval: "a\nb"



=== TEST 31: testinput1:3548
--- re: b\z
--- s eval: "*** Failers"



=== TEST 32: testinput1:3640
--- re: ((Z)+|A)*
--- s eval: "ZABCDEFG"



=== TEST 33: testinput1:3643
--- re: (Z()|A)*
--- s eval: "ZABCDEFG"



=== TEST 34: testinput1:3646
--- re: (Z(())|A)*
--- s eval: "ZABCDEFG"



=== TEST 35: testinput1:3655
--- re: a*
--- s eval: "abbab"



=== TEST 36: testinput1:3658
--- re: ^[a-\d]
--- s eval: "abcde"



=== TEST 37: testinput1:3659
--- re: ^[a-\d]
--- s eval: "-things"



=== TEST 38: testinput1:3660
--- re: ^[a-\d]
--- s eval: "0digit"



=== TEST 39: testinput1:3661
--- re: ^[a-\d]
--- s eval: "*** Failers"



=== TEST 40: testinput1:3662
--- re: ^[a-\d]
--- s eval: "bcdef    "



=== TEST 41: testinput1:3665
--- re: ^[\d-a]
--- s eval: "abcde"



=== TEST 42: testinput1:3666
--- re: ^[\d-a]
--- s eval: "-things"



=== TEST 43: testinput1:3667
--- re: ^[\d-a]
--- s eval: "0digit"



=== TEST 44: testinput1:3668
--- re: ^[\d-a]
--- s eval: "*** Failers"



=== TEST 45: testinput1:3669
--- re: ^[\d-a]
--- s eval: "bcdef    "



=== TEST 46: testinput1:3678
--- re: [\s]+
--- s eval: "> \x09\x0a\x0c\x0d\x0b<"



=== TEST 47: testinput1:3681
--- re: \s+
--- s eval: "> \x09\x0a\x0c\x0d\x0b<"



=== TEST 48: testinput1:3684
--- re: ab
--- s eval: "ab"



=== TEST 49: testinput1:3739
--- re: abc.
--- s eval: "abc1abc2xyzabc3 "



=== TEST 50: testinput1:3815
--- re: [\z\C]
--- s eval: "z"



