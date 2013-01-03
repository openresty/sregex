# vim:set ft= ts=4 sw=4 et fdm=marker:

use t::SRegex 'no_plan';

run_tests();

__DATA__

=== TEST 1: re_tests:565
--- re: ^b
--- s eval: "a\nb\nc\n"



=== TEST 2: re_tests:566
--- re: ()^b
--- s eval: "a\nb\nc\n"



=== TEST 3: re_tests:595
--- re: (\w+:)+
--- s eval: "one:"



=== TEST 4: re_tests:599
--- re: ([\w:]+::)?(\w+)$
--- s eval: "abcd:"



=== TEST 5: re_tests:600
--- re: ([\w:]+::)?(\w+)$
--- s eval: "abcd"



=== TEST 6: re_tests:601
--- re: ([\w:]+::)?(\w+)$
--- s eval: "xy:z:::abcd"



=== TEST 7: re_tests:602
--- re: ^[^bcd]*(c+)
--- s eval: "aexycd"



=== TEST 8: re_tests:603
--- re: (a*)b+
--- s eval: "caab"



=== TEST 9: re_tests:610
--- re: (>a+)ab
--- s eval: "aaab"



=== TEST 10: re_tests:612
--- re: ([[:]+)
--- s eval: "a:[b]:"



=== TEST 11: re_tests:613
--- re: ([[=]+)
--- s eval: "a=[b]="



=== TEST 12: re_tests:614
--- re: ([[.]+)
--- s eval: "a.[b]."



=== TEST 13: re_tests:615
--- re: [a[:xyz:
--- s eval: "-"
--- err_like: ^\[error\] syntax error at pos \d+$



=== TEST 14: re_tests:617
--- re: [a[:]b[:c]
--- s eval: "abc"



=== TEST 15: re_tests:651
--- re: a{37,17}
--- s eval: "-"
--- err_like: ^\[error\] syntax error at pos \d+$



=== TEST 16: re_tests:652
--- re: a{37,0}
--- s eval: "-"
--- err_like: ^\[error\] syntax error at pos \d+$



=== TEST 17: re_tests:654
--- re: \z
--- s eval: "a\nb\n"



=== TEST 18: re_tests:655
--- re: $
--- s eval: "a\nb\n"



=== TEST 19: re_tests:657
--- re: \z
--- s eval: "b\na\n"



=== TEST 20: re_tests:658
--- re: $
--- s eval: "b\na\n"



=== TEST 21: re_tests:660
--- re: \z
--- s eval: "b\na"



=== TEST 22: re_tests:661
--- re: $
--- s eval: "b\na"



=== TEST 23: re_tests:663
--- re: \z
--- s eval: "a\nb\n"



=== TEST 24: re_tests:664
--- re: $
--- s eval: "a\nb\n"



=== TEST 25: re_tests:666
--- re: \z
--- s eval: "b\na\n"



=== TEST 26: re_tests:667
--- re: $
--- s eval: "b\na\n"



=== TEST 27: re_tests:669
--- re: \z
--- s eval: "b\na"



=== TEST 28: re_tests:670
--- re: $
--- s eval: "b\na"



=== TEST 29: re_tests:672
--- re: a\z
--- s eval: "a\nb\n"



=== TEST 30: re_tests:673
--- re: a$
--- s eval: "a\nb\n"



=== TEST 31: re_tests:675
--- re: a\z
--- s eval: "b\na\n"



=== TEST 32: re_tests:676
--- re: a$
--- s eval: "b\na\n"



=== TEST 33: re_tests:678
--- re: a\z
--- s eval: "b\na"



=== TEST 34: re_tests:679
--- re: a$
--- s eval: "b\na"



=== TEST 35: re_tests:681
--- re: a\z
--- s eval: "a\nb\n"



=== TEST 36: re_tests:682
--- re: a$
--- s eval: "a\nb\n"



=== TEST 37: re_tests:684
--- re: a\z
--- s eval: "b\na\n"



=== TEST 38: re_tests:685
--- re: a$
--- s eval: "b\na\n"



=== TEST 39: re_tests:687
--- re: a\z
--- s eval: "b\na"



=== TEST 40: re_tests:688
--- re: a$
--- s eval: "b\na"



=== TEST 41: re_tests:690
--- re: aa\z
--- s eval: "aa\nb\n"



=== TEST 42: re_tests:691
--- re: aa$
--- s eval: "aa\nb\n"



=== TEST 43: re_tests:693
--- re: aa\z
--- s eval: "b\naa\n"



=== TEST 44: re_tests:694
--- re: aa$
--- s eval: "b\naa\n"



=== TEST 45: re_tests:696
--- re: aa\z
--- s eval: "b\naa"



=== TEST 46: re_tests:697
--- re: aa$
--- s eval: "b\naa"



=== TEST 47: re_tests:699
--- re: aa\z
--- s eval: "aa\nb\n"



=== TEST 48: re_tests:700
--- re: aa$
--- s eval: "aa\nb\n"



=== TEST 49: re_tests:702
--- re: aa\z
--- s eval: "b\naa\n"



=== TEST 50: re_tests:703
--- re: aa$
--- s eval: "b\naa\n"



