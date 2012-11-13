# vim:set ft= ts=4 sw=4 et fdm=marker:

use t::SRegex 'no_plan';

run_tests();

__DATA__

=== TEST 1: re_tests:705
--- re: aa\z
--- s eval: "b\naa"



=== TEST 2: re_tests:706
--- re: aa$
--- s eval: "b\naa"



=== TEST 3: re_tests:708
--- re: aa\z
--- s eval: "ac\nb\n"



=== TEST 4: re_tests:709
--- re: aa$
--- s eval: "ac\nb\n"



=== TEST 5: re_tests:711
--- re: aa\z
--- s eval: "b\nac\n"



=== TEST 6: re_tests:712
--- re: aa$
--- s eval: "b\nac\n"



=== TEST 7: re_tests:714
--- re: aa\z
--- s eval: "b\nac"



=== TEST 8: re_tests:715
--- re: aa$
--- s eval: "b\nac"



=== TEST 9: re_tests:717
--- re: aa\z
--- s eval: "ac\nb\n"



=== TEST 10: re_tests:718
--- re: aa$
--- s eval: "ac\nb\n"



=== TEST 11: re_tests:720
--- re: aa\z
--- s eval: "b\nac\n"



=== TEST 12: re_tests:721
--- re: aa$
--- s eval: "b\nac\n"



=== TEST 13: re_tests:723
--- re: aa\z
--- s eval: "b\nac"



=== TEST 14: re_tests:724
--- re: aa$
--- s eval: "b\nac"



=== TEST 15: re_tests:726
--- re: aa\z
--- s eval: "ca\nb\n"



=== TEST 16: re_tests:727
--- re: aa$
--- s eval: "ca\nb\n"



=== TEST 17: re_tests:729
--- re: aa\z
--- s eval: "b\nca\n"



=== TEST 18: re_tests:730
--- re: aa$
--- s eval: "b\nca\n"



=== TEST 19: re_tests:732
--- re: aa\z
--- s eval: "b\nca"



=== TEST 20: re_tests:733
--- re: aa$
--- s eval: "b\nca"



=== TEST 21: re_tests:735
--- re: aa\z
--- s eval: "ca\nb\n"



=== TEST 22: re_tests:736
--- re: aa$
--- s eval: "ca\nb\n"



=== TEST 23: re_tests:738
--- re: aa\z
--- s eval: "b\nca\n"



=== TEST 24: re_tests:739
--- re: aa$
--- s eval: "b\nca\n"



=== TEST 25: re_tests:741
--- re: aa\z
--- s eval: "b\nca"



=== TEST 26: re_tests:742
--- re: aa$
--- s eval: "b\nca"



=== TEST 27: re_tests:744
--- re: ab\z
--- s eval: "ab\nb\n"



=== TEST 28: re_tests:745
--- re: ab$
--- s eval: "ab\nb\n"



=== TEST 29: re_tests:747
--- re: ab\z
--- s eval: "b\nab\n"



=== TEST 30: re_tests:748
--- re: ab$
--- s eval: "b\nab\n"



=== TEST 31: re_tests:750
--- re: ab\z
--- s eval: "b\nab"



=== TEST 32: re_tests:751
--- re: ab$
--- s eval: "b\nab"



=== TEST 33: re_tests:753
--- re: ab\z
--- s eval: "ab\nb\n"



=== TEST 34: re_tests:754
--- re: ab$
--- s eval: "ab\nb\n"



=== TEST 35: re_tests:756
--- re: ab\z
--- s eval: "b\nab\n"



=== TEST 36: re_tests:757
--- re: ab$
--- s eval: "b\nab\n"



=== TEST 37: re_tests:759
--- re: ab\z
--- s eval: "b\nab"



=== TEST 38: re_tests:760
--- re: ab$
--- s eval: "b\nab"



=== TEST 39: re_tests:762
--- re: ab\z
--- s eval: "ac\nb\n"



=== TEST 40: re_tests:763
--- re: ab$
--- s eval: "ac\nb\n"



=== TEST 41: re_tests:765
--- re: ab\z
--- s eval: "b\nac\n"



=== TEST 42: re_tests:766
--- re: ab$
--- s eval: "b\nac\n"



=== TEST 43: re_tests:768
--- re: ab\z
--- s eval: "b\nac"



=== TEST 44: re_tests:769
--- re: ab$
--- s eval: "b\nac"



=== TEST 45: re_tests:771
--- re: ab\z
--- s eval: "ac\nb\n"



=== TEST 46: re_tests:772
--- re: ab$
--- s eval: "ac\nb\n"



=== TEST 47: re_tests:774
--- re: ab\z
--- s eval: "b\nac\n"



=== TEST 48: re_tests:775
--- re: ab$
--- s eval: "b\nac\n"



=== TEST 49: re_tests:777
--- re: ab\z
--- s eval: "b\nac"



=== TEST 50: re_tests:778
--- re: ab$
--- s eval: "b\nac"



