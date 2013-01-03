# vim:set ft= ts=4 sw=4 et fdm=marker:

use t::SRegex 'no_plan';

run_tests();

__DATA__

=== TEST 1: [[]]
--- re: [[]]+
--- s eval: "a[[[[]]]]"



=== TEST 2: [][]
--- re: [][]+
--- s eval: "a[[[[]]]]"



=== TEST 3: [][]
--- re: [^][]+
--- s eval: "ab[[[[]]]]"



=== TEST 4: \N
--- re: \N+
--- s eval: "hello!\r\t "



=== TEST 5: \x{DD}
--- re: \x{0a}
--- s eval: "a\nb"



=== TEST 6: \x{DD}
--- re: \x{0a}b
--- s eval: "a\nb"



=== TEST 7: \x{DD}
--- re: \x{0a
--- s eval: "a\nb"
--- err
[error] syntax error at pos 0



=== TEST 8: \x{DD}
--- re: \xa
--- s eval: "a\nb"



=== TEST 9: \xDD
--- re: \x0a
--- s eval: "a\nb"



=== TEST 10: \xDD
--- re: \x0ab
--- s eval: "a\nb"



=== TEST 11: \xDD
--- re: [\x0ab]+
--- s eval: "a\nb"



=== TEST 12: \xD
--- re: [\xa]+
--- s eval: "a\nb"



=== TEST 13: \xDD
--- re: \x0a!
--- s eval: "a\n!"



=== TEST 14: \xDD
--- re: \xa!
--- s eval: "a\n!"



=== TEST 15: \x{DD}
--- re: \x{a}b
--- s eval: "a\nb"



=== TEST 16: \x{DD}
--- re: \x{A}b
--- s eval: "a\nb"



=== TEST 17: \x{DD}
--- re: [\x{A}b]+
--- s eval: "a\nb"



=== TEST 18: \o{dd}
--- re: \o{12}
--- s eval: "a\nb"



=== TEST 19: \o{ddd}
--- re: \o{012}b
--- s eval: "a\nb"



=== TEST 20: \o{ddd}
--- re: [\o{012}b]+
--- s eval: "a\nb"



=== TEST 21: \o{ddd}
--- re: [\o{12}b]+
--- s eval: "a\nb"



=== TEST 22: \o{ddd}
--- re: [\o{1}b]+
--- s eval: "a\1b"



=== TEST 23: \o{ddd}
--- re: [\o{1
--- s eval: "a\1b"
--- err
[error] syntax error at pos 0



=== TEST 24: \oDD
--- re: \o12
--- s eval: "a\nb"
--- err
[error] syntax error at pos 0



=== TEST 25: \oDD
--- re: \o{12
--- s eval: "a\nb"
--- err
[error] syntax error at pos 0



=== TEST 26: [\02]
--- re: [\02]
--- s eval: "a\2b"



=== TEST 27: [\12]
--- re: [\12]
--- s eval: "a\nb"



=== TEST 28:
--- re: [\012]
--- s eval: "a\nb"



=== TEST 29:
--- re: [\0123]
--- s eval: "a\n3"



=== TEST 30:
--- re: [\0123]+
--- s eval: "a\n3"



=== TEST 31:
--- re: [\0123]+
--- s eval: "a\n23"



=== TEST 32: [\012]
--- re: [\018]
--- s eval: "a\n8"



=== TEST 33:
--- re: \02
--- s eval: "a\2b"



=== TEST 34:
--- re: \12
--- s eval: "a\nb"



=== TEST 35:
--- re: \012
--- s eval: "a\nb"



=== TEST 36:
--- re: \0123
--- s eval: "a\n3"



=== TEST 37: [\012]
--- re: \018
--- s eval: "a\n8"



=== TEST 38: \cb
--- re: \cb
--- s eval: "a\0028"



=== TEST 39: \cB
--- re: \cB
--- s eval: "a\0028"



=== TEST 40: \c
--- re: \c
--- s eval: "a\0028"
--- err
[error] syntax error at pos 0



=== TEST 41: [\cb]
--- re: [\cb]+
--- s eval: "a\0028"



=== TEST 42: \cB
--- re: [\cB]+
--- s eval: "a\0028"



=== TEST 43: \c
--- re: [\c]
--- s eval: "a\0028"
--- err
[error] syntax error at pos 0



=== TEST 44: \cB8
--- re: [\cB8]+
--- s eval: "a\0028"



=== TEST 45: literal :
--- re: a:\w+
--- s eval: "a:hello"



=== TEST 46: from > to and to == 0
--- re: a{1,0}
--- s: a
--- err
[error] syntax error at pos 1



=== TEST 47: trailing \
--- re: \
--- s: a
--- err
[error] syntax error at pos 0



=== TEST 48: from > to
--- re: [D-C]
--- s: a
--- err
[error] syntax error at pos 0



=== TEST 49: the "possessive" quantifier form not supported
--- re: a++
--- s: a
--- err
[error] syntax error at pos 2



=== TEST 50: the "possessive" quantifier form not supported
--- re: a*+
--- s: a
--- err
[error] syntax error at pos 2



