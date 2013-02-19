# vim:set ft= ts=4 sw=4 et fdm=marker:

use t::SRegex 'no_plan';

run_tests();

__DATA__

=== TEST 1: \o{ddd}
--- re: [\o{1}b]+
--- s eval: "a\1b"



=== TEST 2: \o{ddd}
--- re: [\o{1
--- s eval: "a\1b"
--- err
[error] syntax error at pos 0



=== TEST 3: \oDD
--- re: \o12
--- s eval: "a\nb"
--- err
[error] syntax error at pos 0



=== TEST 4: \oDD
--- re: \o{12
--- s eval: "a\nb"
--- err
[error] syntax error at pos 0



=== TEST 5: [\02]
--- re: [\02]
--- s eval: "a\2b"



=== TEST 6: [\12]
--- re: [\12]
--- s eval: "a\nb"



=== TEST 7:
--- re: [\012]
--- s eval: "a\nb"



=== TEST 8:
--- re: [\0123]
--- s eval: "a\n3"



=== TEST 9:
--- re: [\0123]+
--- s eval: "a\n3"



=== TEST 10:
--- re: [\0123]+
--- s eval: "a\n23"



=== TEST 11: [\012]
--- re: [\018]
--- s eval: "a\n8"



=== TEST 12:
--- re: \02
--- s eval: "a\2b"



=== TEST 13:
--- re: \12
--- s eval: "a\nb"



=== TEST 14:
--- re: \012
--- s eval: "a\nb"



=== TEST 15:
--- re: \0123
--- s eval: "a\n3"



=== TEST 16: [\012]
--- re: \018
--- s eval: "a\n8"



=== TEST 17: \cb
--- re: \cb
--- s eval: "a\0028"



=== TEST 18: \cB
--- re: \cB
--- s eval: "a\0028"



=== TEST 19: \c
--- re: \c
--- s eval: "a\0028"
--- err
[error] syntax error at pos 0



=== TEST 20: [\cb]
--- re: [\cb]+
--- s eval: "a\0028"



=== TEST 21: \cB
--- re: [\cB]+
--- s eval: "a\0028"



=== TEST 22: \c
--- re: [\c]
--- s eval: "a\0028"
--- err
[error] syntax error at pos 0



=== TEST 23: \cB8
--- re: [\cB8]+
--- s eval: "a\0028"



=== TEST 24: literal :
--- re: a:\w+
--- s eval: "a:hello"



=== TEST 25: from > to and to == 0
--- re: a{1,0}
--- s: a
--- err
[error] syntax error at pos 1



=== TEST 26: trailing \
--- re: \
--- s: a
--- err
[error] syntax error at pos 0



=== TEST 27: from > to
--- re: [D-C]
--- s: a
--- err
[error] syntax error at pos 0



=== TEST 28: the "possessive" quantifier form not supported
--- re: a++
--- s: a
--- err
[error] syntax error at pos 2



=== TEST 29: the "possessive" quantifier form not supported
--- re: a*+
--- s: a
--- err
[error] syntax error at pos 2



=== TEST 30: the "possessive" quantifier form not supported
--- re: a?+
--- s: a
--- err
[error] syntax error at pos 2



=== TEST 31: the "possessive" quantifier form not supported
--- re: a{3}+
--- s: a
--- err
[error] syntax error at pos 4



=== TEST 32: unmatched ")"
--- re: \(ab)
--- s: hello(ab)
--- err
[error] syntax error at pos 4



=== TEST 33: unmatched "]"
--- re: \[ab]
--- s: hello[ab]



=== TEST 34: escaped !, @, \, /, %, and ","
--- re: [\!\,\@\\\/\%]+
--- s: hello,!@\/%



=== TEST 35: escaped !, @, \, /, %, and ,
--- re: \!\,\@\\\/\%
--- s: hello,!@\/%



=== TEST 36: \c\X
--- re: \c\X
--- s eval: "\034X"



=== TEST 37: \c\.
--- re: \c\.
--- s eval: "\034X"



=== TEST 38: \c\
--- re: \c\
--- s eval: "\034X"



=== TEST 39: \C
--- re: \C+
--- s eval: "hello world!\n\r"



=== TEST 40: a{0,n}
--- re: a{0,3}
--- s:



=== TEST 41: a{0,n}
--- re: a{0,3}
--- s: aaaa



=== TEST 42: \0 in target string
--- re: a
--- s eval: "\0aaaa"



=== TEST 43: temporary captures
--- re: (?:a|(ab))cd
--- s: babcd
--- temp_cap: [(1, -1)] [(1, -1)] [(1, -1)] [(1, -1)]



=== TEST 44: /i - in
--- re: [abd-f]+
--- s: bFEBADaC
--- flags: i



=== TEST 45: /i - not in
--- re: [^abd-f]+
--- s: bFEBADaCz-
--- flags: i



=== TEST 46: /i - testinput1:1685
--- re: word (?:[a-zA-Z0-9]+ ){0,300}otherword
--- s eval: "word cat dog elephant mussel cow horse canary baboon snake shark the quick brown fox and the lazy dog and several other words getting close to thirty by now I hope"
--- flags: i



=== TEST 47: /i - char
--- re: hello
--- s: ZAhHElLO
--- flags: i



=== TEST 48: /i - char
--- re: hello
--- s: ZAHhello
--- flags: i



=== TEST 49: match early
--- re: \s+
--- s eval: "abc \t\n\f\rd"
--- temp_cap chop
[(1, -1)] [(2, -1)] [(3, -1)] [(3, -1)](3, 4) [(3, -1)](3, 5) [(3, -1)](3, 6) [(3, -1)](3, 7) [(3, -1)](3, 8)



=== TEST 50: pending match
--- re: abcde|bc
--- s eval: "abcdf"
--- temp_cap chop
[(0, -1)] [(0, -1)] [(0, -1)](1, 3) [(0, -1)](1, 3)

