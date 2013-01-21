# vim:set ft= ts=4 sw=4 et fdm=marker:

use t::SRegex 'no_plan';

run_tests();

__DATA__

=== TEST 1: \b
--- re: (a\b|a\b)b
--- s eval: "ab"



=== TEST 2: \b
--- re: ([+a])\b([-b])
--- s eval: "ab"



=== TEST 3: \b
--- re: ([+a])\b([-b])
--- s eval: "a-"



=== TEST 4: \b
--- re: ([+a])\b([-b])
--- s eval: "+-"



=== TEST 5: \b
--- re: ([+a])\b([-b])
--- s eval: "+b"



=== TEST 6: \b
--- re: ([+a])\b\b([-b])
--- s eval: "+b"



=== TEST 7: \b
--- re: \bb
--- s eval: "b"



=== TEST 8: \b
--- re: \b([-b])
--- s eval: "b"



=== TEST 9: \b
--- re: \b([-b])
--- s eval: "-"



=== TEST 10: \b\z
--- re: a\b\z
--- s eval: "a\n"



=== TEST 11: testinput1:1641
--- re: .*\b5
--- s eval: "5"



=== TEST 12: testinput1:1641
--- re: .*\b5+$
--- s eval: "55"



=== TEST 13: \B
--- re: ([+a])\B([-b])
--- s eval: "ab"



=== TEST 14: \B
--- re: ([+a])\B([-b])
--- s eval: "a-"



=== TEST 15: \B
--- re: ([+a])\B([-b])
--- s eval: "+-"



=== TEST 16: \B
--- re: ([+a])\B([-b])
--- s eval: "+b"



=== TEST 17: \B
--- re: ([+a])\B\B([-b])
--- s eval: "+b"



=== TEST 18: \B
--- re: \B([-b])
--- s eval: "b"



=== TEST 19: \B
--- re: \B([-b])
--- s eval: "-"



=== TEST 20: \B\z
--- re: a\B\z
--- s eval: "a\n"



=== TEST 21: \h
--- re: \h+
--- s eval: "\f\r\t "



=== TEST 22: \H
--- re: \H+
--- s eval: "\f\r\t "



=== TEST 23: \v
--- re: \v+
--- s eval: " \t\n\x0b\f\r\x85\x86"



=== TEST 24: \V
--- re: \v+
--- s eval: "\x86 \t\n\x0b\f\r\x85"



=== TEST 25: \h
--- re: [\h]+
--- s eval: "\f\r\t "



=== TEST 26: \H
--- re: [\H]+
--- s eval: "\f\r\t "



=== TEST 27: \v
--- re: [\v]+
--- s eval: " \t\n\x0b\f\r\x85\x86"
--- cap: (2, 7)



=== TEST 28: \V
--- re: [\V]+
--- s eval: "\x86 \t\n\x0b\f\r\x85"
--- cap: (0, 3)



=== TEST 29: [\b]
--- re: [\b]+
--- s eval: "a\b\b"



=== TEST 30: [[]]
--- re: [[]]+
--- s eval: "a[[[[]]]]"



=== TEST 31: [][]
--- re: [][]+
--- s eval: "a[[[[]]]]"



=== TEST 32: [][]
--- re: [^][]+
--- s eval: "ab[[[[]]]]"



=== TEST 33: \N
--- re: \N+
--- s eval: "hello!\r\t "



=== TEST 34: \x{DD}
--- re: \x{0a}
--- s eval: "a\nb"



=== TEST 35: \x{DD}
--- re: \x{0a}b
--- s eval: "a\nb"



=== TEST 36: \x{DD}
--- re: \x{0a
--- s eval: "a\nb"
--- err
[error] syntax error at pos 0



=== TEST 37: \x{DD}
--- re: \xa
--- s eval: "a\nb"



=== TEST 38: \xDD
--- re: \x0a
--- s eval: "a\nb"



=== TEST 39: \xDD
--- re: \x0ab
--- s eval: "a\nb"



=== TEST 40: \xDD
--- re: [\x0ab]+
--- s eval: "a\nb"



=== TEST 41: \xD
--- re: [\xa]+
--- s eval: "a\nb"



=== TEST 42: \xDD
--- re: \x0a!
--- s eval: "a\n!"



=== TEST 43: \xDD
--- re: \xa!
--- s eval: "a\n!"



=== TEST 44: \x{DD}
--- re: \x{a}b
--- s eval: "a\nb"



=== TEST 45: \x{DD}
--- re: \x{A}b
--- s eval: "a\nb"



=== TEST 46: \x{DD}
--- re: [\x{A}b]+
--- s eval: "a\nb"



=== TEST 47: \o{dd}
--- re: \o{12}
--- s eval: "a\nb"



=== TEST 48: \o{ddd}
--- re: \o{012}b
--- s eval: "a\nb"



=== TEST 49: \o{ddd}
--- re: [\o{012}b]+
--- s eval: "a\nb"



=== TEST 50: \o{ddd}
--- re: [\o{12}b]+
--- s eval: "a\nb"



