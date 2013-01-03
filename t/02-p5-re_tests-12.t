# vim:set ft= ts=4 sw=4 et fdm=marker:

use t::SRegex 'no_plan';

run_tests();

__DATA__

=== TEST 1: re_tests:915
--- re: ^(aa(bb)?)+$
--- s eval: "aabbaa"
--- cap: (0, 6) (4, 6) (2, 4)



=== TEST 2: re_tests:916
--- re: ^.{9}abc.*\n
--- s eval: "123\nabcabcabcabc\n"



=== TEST 3: re_tests:917
--- re: ^(a)?a$
--- s eval: "a"



=== TEST 4: re_tests:921
--- re: ^(0+)?(?:x(1))?
--- s eval: "x1"



=== TEST 5: re_tests:922
--- re: ^([0-9a-fA-F]+)(?:x([0-9a-fA-F]+)?)(?:x([0-9a-fA-F]+))?
--- s eval: "012cxx0190"



=== TEST 6: re_tests:923
--- re: ^(b+?|a){1,2}c
--- s eval: "bbbac"



=== TEST 7: re_tests:924
--- re: ^(b+?|a){1,2}c
--- s eval: "bbbbac"



=== TEST 8: re_tests:925
--- re: \((\w\. \w+)\)
--- s eval: "cd. (A. Tw)"



=== TEST 9: re_tests:926
--- re: ((?:aaaa|bbbb)cccc)?
--- s eval: "aaaacccc"



=== TEST 10: re_tests:927
--- re: ((?:aaaa|bbbb)cccc)?
--- s eval: "bbbbcccc"



=== TEST 11: re_tests:928
--- re: (a)?(a)+
--- s eval: "a"



=== TEST 12: re_tests:929
--- re: (ab)?(ab)+
--- s eval: "ab"



=== TEST 13: re_tests:930
--- re: (abc)?(abc)+
--- s eval: "abc"



=== TEST 14: re_tests:931
--- re: b\s^
--- s eval: "a\nb\n"
--- cap: (2, 4)



=== TEST 15: re_tests:932
--- re: \ba
--- s eval: "a"



=== TEST 16: re_tests:943
--- re: (.*)c
--- s eval: "abcd"



=== TEST 17: re_tests:960
--- re: (.*?)c
--- s eval: "abcd"



=== TEST 18: re_tests:979
--- re: a(b)??
--- s eval: "abc"



=== TEST 19: re_tests:980
--- re: (\d{1,3}\.){3,}
--- s eval: "128.134.142.8"



=== TEST 20: re_tests:998
--- re: x(?#
--- s eval: "x"
--- err_like: ^\[error\] syntax error at pos \d+$



=== TEST 21: re_tests:999
--- re: x(?#
--- s eval: "x"
--- err_like: ^\[error\] syntax error at pos \d+$



=== TEST 22: re_tests:1000
--- re: (WORDS|WORD)S
--- s eval: "WORDS"



=== TEST 23: re_tests:1001
--- re: (X.|WORDS|X.|WORD)S
--- s eval: "WORDS"



=== TEST 24: re_tests:1002
--- re: (WORDS|WORLD|WORD)S
--- s eval: "WORDS"



=== TEST 25: re_tests:1003
--- re: (X.|WORDS|WORD|Y.)S
--- s eval: "WORDS"



=== TEST 26: re_tests:1004
--- re: (foo|fool|x.|money|parted)$
--- s eval: "fool"



=== TEST 27: re_tests:1005
--- re: (x.|foo|fool|x.|money|parted|y.)$
--- s eval: "fool"



=== TEST 28: re_tests:1006
--- re: (foo|fool|money|parted)$
--- s eval: "fool"



=== TEST 29: re_tests:1007
--- re: (foo|fool|x.|money|parted)$
--- s eval: "fools"



=== TEST 30: re_tests:1008
--- re: (x.|foo|fool|x.|money|parted|y.)$
--- s eval: "fools"



=== TEST 31: re_tests:1009
--- re: (foo|fool|money|parted)$
--- s eval: "fools"



=== TEST 32: re_tests:1010
--- re: (a|aa|aaa||aaaa|aaaaa|aaaaaa)(b|c)
--- s eval: "aaaaaaaaaaaaaaab"



=== TEST 33: re_tests:1016
--- re: (?:r?)*?r|(.{2,4})
--- s eval: "abcde"



=== TEST 34: re_tests:1020
--- re: ^((?:aa)*)(?:X+((?:\d+|-)(?:X+(.+))?))?$
--- s eval: "aaaaX5"



=== TEST 35: re_tests:1021
--- re: X(A|B||C|D)Y
--- s eval: "XXXYYY"



=== TEST 36: re_tests:1023
--- re: ^([a]{1})*$
--- s eval: "aa"



=== TEST 37: re_tests:1028
--- re: ^(XXXXXXXXXX|YYYYYYYYYY|Z.Q*X|Z[TE]Q*P):
--- s eval: "ZEQQQQQQQQQQQQQQQQQQP:"



=== TEST 38: re_tests:1029
--- re: ^(XXXXXXXXXX|YYYYYYYYYY|Z.Q*X|Z[TE]Q*P):
--- s eval: "ZEQQQX:"



=== TEST 39: re_tests:1030
--- re: ^([TUV]+|XXXXXXXXXX|YYYYYYYYYY|Z.Q*X|Z[TE]Q*P):
--- s eval: "ZEQQQQQQQQQQQQQQQQQQP:"



=== TEST 40: re_tests:1031
--- re: ^([TUV]+|XXXXXXXXXX|YYYYYYYYYY|Z.Q*X|Z[TE]Q*P):
--- s eval: "ZEQQQX:"



=== TEST 41: re_tests:1032
--- re: ^([TUV]+|XXXXXXXXXX|YYYYYYYYYY|Z.Q*X|Z[TE]Q*P|[MKJ]):
--- s eval: "ZEQQQQQQQQQQQQQQQQQQP:"



=== TEST 42: re_tests:1033
--- re: ^([TUV]+|XXXXXXXXXX|YYYYYYYYYY|Z.Q*X|Z[TE]Q*P|[MKJ]):
--- s eval: "ZEQQQX:"



=== TEST 43: re_tests:1034
--- re: ^(XXX|YYY|Z.Q*X|Z[TE]Q*P):
--- s eval: "ZEQQQQQQQQQQQQQQQQQQP:"



=== TEST 44: re_tests:1035
--- re: ^(XXX|YYY|Z.Q*X|Z[TE]Q*P):
--- s eval: "ZEQQQX:"



=== TEST 45: re_tests:1036
--- re: ^([TUV]+|XXX|YYY|Z.Q*X|Z[TE]Q*P):
--- s eval: "ZEQQQQQQQQQQQQQQQQQQP:"



=== TEST 46: re_tests:1037
--- re: ^([TUV]+|XXX|YYY|Z.Q*X|Z[TE]Q*P):
--- s eval: "ZEQQQX:"



=== TEST 47: re_tests:1038
--- re: ^([TUV]+|XXX|YYY|Z.Q*X|Z[TE]Q*P|[MKJ]):
--- s eval: "ZEQQQQQQQQQQQQQQQQQQP:"



=== TEST 48: re_tests:1039
--- re: ^([TUV]+|XXX|YYY|Z.Q*X|Z[TE]Q*P|[MKJ]):
--- s eval: "ZEQQQX:"



=== TEST 49: re_tests:1040
--- re: X(?:ABCF[cC]x*|ABCD|ABCF):(?:DIT|DID|DIM)
--- s eval: "XABCFCxxxxxxxxxx:DIM"



=== TEST 50: re_tests:1041
--- re: (((ABCD|ABCE|ABCF)))(A|B|C[xy]*):
--- s eval: "ABCFCxxxxxxxxxx:DIM"



