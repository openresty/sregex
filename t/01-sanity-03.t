# vim:set ft= ts=4 sw=4 et fdm=marker:

use t::SRegex 'no_plan';

run_tests();

__DATA__

=== TEST 1: to exceeding 100
--- re: {0,100}
--- s eval: 'x' x 16
--- fatal



=== TEST 2:
--- re: x{1}
--- s eval: 'x' x 16



=== TEST 3:
--- re: x{1}?
--- s eval: 'x' x 16



=== TEST 4:
--- re: x{2}
--- s eval: 'x' x 16



=== TEST 5:
--- re: x{2}?
--- s eval: 'x' x 16



=== TEST 6:
--- re: x{11}
--- s eval: 'x' x 16



=== TEST 7:
--- re: x{0,0}
--- s: hab



=== TEST 8: match a tab
--- re: \t
--- s eval: " \t"



=== TEST 9: match a tab in char class
--- re: [\t]
--- s eval: " \t"



=== TEST 10: match a newline
--- re: \n
--- s eval: " \n"



=== TEST 11: match a newline in char class
--- re: [\n]
--- s eval: " \n"



=== TEST 12: match a return
--- re: \r
--- s eval: " \r"



=== TEST 13: match a return in char class
--- re: [\r]
--- s eval: " \r"



=== TEST 14: match a form feed
--- re: \f
--- s eval: " \f"



=== TEST 15: match a form feed in char class
--- re: [\f]
--- s eval: " \f"



=== TEST 16: match an alarm feed
--- re: \a
--- s eval: " \a"



=== TEST 17: match an alarm in char class
--- re: [\a]
--- s eval: " \a"



=== TEST 18: match an escape feed
--- re: \e
--- s eval: " \e"



=== TEST 19: match an escape in char class
--- re: [\e]
--- s eval: " \e"



=== TEST 20: \A
--- re: \Ahello
--- s eval: "hello"



=== TEST 21: \A
--- re: \Ahello
--- s eval: "ahello"



=== TEST 22: \A
--- re: \Ahello
--- s eval: "blah\nhello"



=== TEST 23: ^
--- re: ^h
--- s eval: "h"



=== TEST 24: ^^
--- re: ^^hello
--- s eval: "hello"



=== TEST 25: ^^
--- re: ^h^ello
--- s eval: "hello"



=== TEST 26: ^^
--- re: ^\n^ello
--- s eval: "\nello"



=== TEST 27: ^
--- re: ^hello
--- s eval: "hello"



=== TEST 28: ^
--- re: ^hello
--- s eval: "blah\nhello"



=== TEST 29: ^ not match
--- re: ^ello
--- s eval: "blah\nhello"



=== TEST 30: ^
--- re: (a.*(^hello))
--- s eval: "blah\nhello"



=== TEST 31: ^
--- re: ^
--- s:



=== TEST 32: ^
--- re: (^)+
--- s: "\n\n\n"



=== TEST 33: \z
--- re: o\z
--- s eval: "o"



=== TEST 34: \z & $
--- re: $\z\n
--- s eval: "o\n"



=== TEST 35: \z & $
--- re: \z$\n
--- s eval: "o\n"



=== TEST 36: \z
--- re: l\z
--- s eval: "hello"



=== TEST 37: \z
--- re: hello\z
--- s eval: "blah\nhello"



=== TEST 38: \z
--- re: hello\z
--- s eval: "blah\nhello\n"



=== TEST 39: $
--- re: hello$
--- s eval: "blah\nhello"



=== TEST 40: $
--- re: hello$
--- s eval: "blah\nhello\n"



=== TEST 41: $
--- re: hell$
--- s eval: "blah\nhello\n"



=== TEST 42: $
--- re: \w+$
--- s eval: "blah\nhello"



=== TEST 43: $
--- re: .*(\w+)$
--- s eval: "blah\nhello"



=== TEST 44: $
--- re: .*(\w+)$\n
--- s eval: "blah\nhello"



=== TEST 45: $
--- re: ((\w+)$\n?)+
--- s eval: "a\nb"



=== TEST 46: $
--- re: ((\w+)$\n?)+
--- s eval: "abc\ndef"



=== TEST 47: \b
--- re: a\b
--- s eval: "a\ndef"



=== TEST 48: \b
--- re: ab\b
--- s eval: "ab\ndef"



=== TEST 49: \b
--- re: ab\b
--- s eval: "abdef"



=== TEST 50: \b
--- re: a\bb
--- s eval: "ab"



