# vim:set ft= ts=4 sw=4 et fdm=marker:

use t::SRegex 'no_plan';

run_tests();

__DATA__

=== TEST 1: re_tests:857
--- re: foo.bart
--- s eval: "foo.bart"



=== TEST 2: re_tests:858
--- re: ^d[x][x][x]
--- s eval: "abcd\ndxxx"



=== TEST 3: re_tests:859
--- re: .X(.+)+X
--- s eval: "bbbbXcXaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"



=== TEST 4: re_tests:860
--- re: .X(.+)+XX
--- s eval: "bbbbXcXXaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"



=== TEST 5: re_tests:861
--- re: .XX(.+)+X
--- s eval: "bbbbXXcXaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"



=== TEST 6: re_tests:862
--- re: .X(.+)+X
--- s eval: "bbbbXXaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"



=== TEST 7: re_tests:863
--- re: .X(.+)+XX
--- s eval: "bbbbXXXaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"



=== TEST 8: re_tests:864
--- re: .XX(.+)+X
--- s eval: "bbbbXXXaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"



=== TEST 9: re_tests:865
--- re: .X(.+)+[X]
--- s eval: "bbbbXcXaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"



=== TEST 10: re_tests:866
--- re: .X(.+)+[X][X]
--- s eval: "bbbbXcXXaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"



=== TEST 11: re_tests:867
--- re: .XX(.+)+[X]
--- s eval: "bbbbXXcXaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"



=== TEST 12: re_tests:868
--- re: .X(.+)+[X]
--- s eval: "bbbbXXaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"



=== TEST 13: re_tests:869
--- re: .X(.+)+[X][X]
--- s eval: "bbbbXXXaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"



=== TEST 14: re_tests:870
--- re: .XX(.+)+[X]
--- s eval: "bbbbXXXaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"



=== TEST 15: re_tests:871
--- re: .[X](.+)+[X]
--- s eval: "bbbbXcXaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"



=== TEST 16: re_tests:872
--- re: .[X](.+)+[X][X]
--- s eval: "bbbbXcXXaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"



=== TEST 17: re_tests:873
--- re: .[X][X](.+)+[X]
--- s eval: "bbbbXXcXaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"



=== TEST 18: re_tests:874
--- re: .[X](.+)+[X]
--- s eval: "bbbbXXaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"



=== TEST 19: re_tests:875
--- re: .[X](.+)+[X][X]
--- s eval: "bbbbXXXaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"



=== TEST 20: re_tests:876
--- re: .[X][X](.+)+[X]
--- s eval: "bbbbXXXaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"



=== TEST 21: re_tests:877
--- re: tt+$
--- s eval: "xxxtt"



=== TEST 22: re_tests:878
--- re: ([a-\d]+)
--- s eval: "za-9z"



=== TEST 23: re_tests:879
--- re: ([\d-z]+)
--- s eval: "a0-za"



=== TEST 24: re_tests:880
--- re: ([\d-\s]+)
--- s eval: "a0- z"



=== TEST 25: re_tests:885
--- re: (\d+\.\d+)
--- s eval: "3.1415926"



=== TEST 26: re_tests:886
--- re: (\ba.{0,10}br)
--- s eval: "have a web browser"



=== TEST 27: re_tests:887
--- re: \.c(pp|xx|c)?$
--- s eval: "Changes"
--- flags: i



=== TEST 28: re_tests:888
--- re: \.c(pp|xx|c)?$
--- s eval: "IO.c"
--- flags: i



=== TEST 29: re_tests:889
--- re: (\.c(pp|xx|c)?$)
--- s eval: "IO.c"
--- flags: i



=== TEST 30: re_tests:890
--- re: ^([a-z]:)
--- s eval: "C:/"



=== TEST 31: re_tests:891
--- re: ^\S\s+aa$
--- s eval: "\nx aa"



=== TEST 32: re_tests:892
--- re: (^|a)b
--- s eval: "ab"



=== TEST 33: re_tests:893
--- re: ^([ab]*?)(b)?(c)$
--- s eval: "abac"



=== TEST 34: re_tests:895
--- re: ^(?:.,){2}c
--- s eval: "a,b,c"



=== TEST 35: re_tests:896
--- re: ^(.,){2}c
--- s eval: "a,b,c"



=== TEST 36: re_tests:897
--- re: ^(?:[^,]*,){2}c
--- s eval: "a,b,c"



=== TEST 37: re_tests:898
--- re: ^([^,]*,){2}c
--- s eval: "a,b,c"



=== TEST 38: re_tests:899
--- re: ^([^,]*,){3}d
--- s eval: "aaa,b,c,d"



=== TEST 39: re_tests:900
--- re: ^([^,]*,){3,}d
--- s eval: "aaa,b,c,d"



=== TEST 40: re_tests:901
--- re: ^([^,]*,){0,3}d
--- s eval: "aaa,b,c,d"



=== TEST 41: re_tests:902
--- re: ^([^,]{1,3},){3}d
--- s eval: "aaa,b,c,d"



=== TEST 42: re_tests:903
--- re: ^([^,]{1,3},){3,}d
--- s eval: "aaa,b,c,d"



=== TEST 43: re_tests:904
--- re: ^([^,]{1,3},){0,3}d
--- s eval: "aaa,b,c,d"



=== TEST 44: re_tests:905
--- re: ^([^,]{1,},){3}d
--- s eval: "aaa,b,c,d"



=== TEST 45: re_tests:906
--- re: ^([^,]{1,},){3,}d
--- s eval: "aaa,b,c,d"



=== TEST 46: re_tests:907
--- re: ^([^,]{1,},){0,3}d
--- s eval: "aaa,b,c,d"



=== TEST 47: re_tests:908
--- re: ^([^,]{0,3},){3}d
--- s eval: "aaa,b,c,d"



=== TEST 48: re_tests:909
--- re: ^([^,]{0,3},){3,}d
--- s eval: "aaa,b,c,d"



=== TEST 49: re_tests:910
--- re: ^([^,]{0,3},){0,3}d
--- s eval: "aaa,b,c,d"



=== TEST 50: re_tests:914
--- re: ^(a(b)?)+$
--- s eval: "aba"
--- cap: (0, 3) (2, 3) (1, 2)



