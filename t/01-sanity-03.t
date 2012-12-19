# vim:set ft= ts=4 sw=4 et fdm=marker:

use t::SRegex 'no_plan';

run_tests();

__DATA__

=== TEST 1: match a form feed in char class
--- re: [\f]
--- s eval: " \f"



=== TEST 2: match an alarm feed
--- re: \a
--- s eval: " \a"



=== TEST 3: match an alarm in char class
--- re: [\a]
--- s eval: " \a"



=== TEST 4: match an escape feed
--- re: \e
--- s eval: " \e"



=== TEST 5: match an escape in char class
--- re: [\e]
--- s eval: " \e"



=== TEST 6: \A
--- re: \Ahello
--- s eval: "hello"



=== TEST 7: \A
--- re: \Ahello
--- s eval: "blah\nhello"



=== TEST 8: ^
--- re: ^hello
--- s eval: "hello"



=== TEST 9: ^
--- re: ^hello
--- s eval: "blah\nhello"



=== TEST 10: ^ not match
--- re: ^ello
--- s eval: "blah\nhello"



=== TEST 11: ^
--- re: (a.*(^hello))
--- s eval: "blah\nhello"



=== TEST 12: ^
--- re: ^
--- s:



=== TEST 13: ^
--- re: (^)+
--- s: "\n\n\n"



=== TEST 14: \z
--- re: hello\z
--- s eval: "blah\nhello"



=== TEST 15: \z
--- re: hello\z
--- s eval: "blah\nhello\n"



=== TEST 16: $
--- re: hello$
--- s eval: "blah\nhello"



=== TEST 17: $
--- re: hello$
--- s eval: "blah\nhello\n"



=== TEST 18: $
--- re: hell$
--- s eval: "blah\nhello\n"



=== TEST 19: $
--- re: \w+$
--- s eval: "blah\nhello"



=== TEST 20: $
--- re: .*(\w+)$
--- s eval: "blah\nhello"



=== TEST 21: $
--- re: .*(\w+)$\n
--- s eval: "blah\nhello"



=== TEST 22: $
--- re: ((\w+)$\n?)+
--- s eval: "a\nb"



=== TEST 23: $
--- re: ((\w+)$\n?)+
--- s eval: "abc\ndef"



=== TEST 24: \b
--- re: ab\b
--- s eval: "ab\ndef"



=== TEST 25: \b
--- re: ab\b
--- s eval: "abdef"



=== TEST 26: \b
--- re: ([+a])\b([-b])
--- s eval: "ab"



=== TEST 27: \b
--- re: ([+a])\b([-b])
--- s eval: "a-"



=== TEST 28: \b
--- re: ([+a])\b([-b])
--- s eval: "+-"



=== TEST 29: \b
--- re: ([+a])\b([-b])
--- s eval: "+b"



=== TEST 30: \b
--- re: ([+a])\b\b([-b])
--- s eval: "+b"



=== TEST 31: \b
--- re: \b([-b])
--- s eval: "b"



=== TEST 32: \b
--- re: \b([-b])
--- s eval: "-"



=== TEST 33: \b\z
--- re: a\b\z
--- s eval: "a\n"



=== TEST 34: \B
--- re: ([+a])\B([-b])
--- s eval: "ab"



=== TEST 35: \B
--- re: ([+a])\B([-b])
--- s eval: "a-"



=== TEST 36: \B
--- re: ([+a])\B([-b])
--- s eval: "+-"



=== TEST 37: \B
--- re: ([+a])\B([-b])
--- s eval: "+b"



=== TEST 38: \B
--- re: ([+a])\B\B([-b])
--- s eval: "+b"



=== TEST 39: \B
--- re: \B([-b])
--- s eval: "b"



=== TEST 40: \B
--- re: \B([-b])
--- s eval: "-"



=== TEST 41: \B\z
--- re: a\B\z
--- s eval: "a\n"



=== TEST 42: \h
--- re: \h+
--- s eval: "\f\r\t "



=== TEST 43: \H
--- re: \H+
--- s eval: "\f\r\t "



=== TEST 44: \v
--- re: \v+
--- s eval: " \t\n\x0b\f\r\x85\x86"



=== TEST 45: \V
--- re: \v+
--- s eval: "\x86 \t\n\x0b\f\r\x85"



=== TEST 46: \h
--- re: [\h]+
--- s eval: "\f\r\t "



=== TEST 47: \H
--- re: [\H]+
--- s eval: "\f\r\t "



=== TEST 48: \v
--- re: [\v]+
--- s eval: " \t\n\x0b\f\r\x85\x86"
--- cap: (2, 7)



=== TEST 49: \V
--- re: [\V]+
--- s eval: "\x86 \t\n\x0b\f\r\x85"
--- cap: (0, 3)



=== TEST 50: [\b]
--- re: [\b]+
--- s eval: "a\b\b"



