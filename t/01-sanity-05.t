# vim:set ft= ts=4 sw=4 et fdm=marker:

use t::SRegex 'no_plan';

run_tests();

__DATA__

=== TEST 1: the "possessive" quantifier form not supported
--- re: a?+
--- s: a
--- err
[error] syntax error at pos 2



=== TEST 2: the "possessive" quantifier form not supported
--- re: a{3}+
--- s: a
--- err
[error] syntax error at pos 4



=== TEST 3: unmatched ")"
--- re: \(ab)
--- s: hello(ab)
--- err
[error] syntax error at pos 4



=== TEST 4: unmatched "]"
--- re: \[ab]
--- s: hello[ab]



=== TEST 5: escaped !, @, \, /, %, and ","
--- re: [\!\,\@\\\/\%]+
--- s: hello,!@\/%



=== TEST 6: escaped !, @, \, /, %, and ,
--- re: \!\,\@\\\/\%
--- s: hello,!@\/%



=== TEST 7: \c\X
--- re: \c\X
--- s eval: "\034X"



=== TEST 8: \c\.
--- re: \c\.
--- s eval: "\034X"



=== TEST 9: \c\
--- re: \c\
--- s eval: "\034X"



=== TEST 10: \C
--- re: \C+
--- s eval: "hello world!\n\r"



=== TEST 11: a{0,n}
--- re: a{0,3}
--- s:



=== TEST 12: a{0,n}
--- re: a{0,3}
--- s: aaaa



=== TEST 13: \0 in target string
--- re: a
--- s eval: "\0aaaa"



=== TEST 14: temporary captures
--- re: (?:a|(ab))cd
--- s: babcd
--- temp_cap: [(1, -1)(1, -1)] [(1, -1)(1, -1)] [(1, -1)(1, 3)] [(1, -1)(1, 3)]



=== TEST 15: /i - in
--- re: [abd-f]+
--- s: bFEBADaC
--- flags: i



=== TEST 16: /i - not in
--- re: [^abd-f]+
--- s: bFEBADaCz-
--- flags: i



=== TEST 17: /i - testinput1:1685
--- re: word (?:[a-zA-Z0-9]+ ){0,300}otherword
--- s eval: "word cat dog elephant mussel cow horse canary baboon snake shark the quick brown fox and the lazy dog and several other words getting close to thirty by now I hope"
--- flags: i



=== TEST 18: /i - char
--- re: hello
--- s: ZAhHElLO
--- flags: i



=== TEST 19: /i - char
--- re: hello
--- s: ZAHhello
--- flags: i



=== TEST 20: match early
--- re: \s+
--- s eval: "abc \t\n\f\rd"
--- temp_cap chop
[(1, -1)] [(2, -1)] [(3, -1)] [(3, -1)](3, 4) [(3, -1)](3, 5) [(3, -1)](3, 6) [(3, -1)](3, 7) [(3, -1)](3, 8)



=== TEST 21: pending match
--- re: abcde|bc
--- s eval: "abcdf"
--- temp_cap chop
[(0, -1)] [(0, -1)] [(0, -1)](1, 3) [(0, -1)](1, 3)

