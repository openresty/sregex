# vim:set ft= ts=4 sw=4 et fdm=marker:

use t::SRegex 'no_plan';

run_tests();

__DATA__

=== TEST 1: the "possessive" quantifier form not supported
--- re: a?+
--- s: a
--- err
[error] syntax error



=== TEST 2: the "possessive" quantifier form not supported
--- re: a{3}+
--- s: a
--- err
[error] syntax error



=== TEST 3: unmatched ")"
--- re: \(ab)
--- s: hello(ab)
--- err
[error] syntax error



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
--- temp_cap: [(1, -1)(1, -1)] [(1, -1)(1, -1)] [(1, -1)(1, 3)] [(1, -1)(1, 3)] [(1, 5)(1, 3)]

