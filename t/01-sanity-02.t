# vim:set ft= ts=4 sw=4 et fdm=marker:

use t::SRegex 'no_plan';

run_tests();

__DATA__

=== TEST 1: [^\d]
--- re: [^\d]+
--- s: -hello_world1234Blah(+



=== TEST 2: [a-\d]
--- re: [a-\d]+
--- s: -hello_world1234Blah(+



=== TEST 3:
--- re: [(\w]+
--- s: -hello_world1234Blah(+



=== TEST 4:
--- re: [\w(]+
--- s: -hello_world1234Blah(+



=== TEST 5:
--- re: [\s]+
--- s eval: "-+(hello) \t_world1234Blah(+"



=== TEST 6:
--- re: [\S]+
--- s eval: "-+(hello) \t_world1234Blah(+"



=== TEST 7: \W
--- re: [\W]+
--- s: hello_world1234Blah(+-



=== TEST 8: \D
--- re: [\D]+
--- s: -+(hello)_world1234Blah(+



=== TEST 9:
--- re: [^\D]+
--- s: -+(hello)_world1234Blah(+



=== TEST 10: escaped metachars
--- re: [\\\[\)\(\.]+
--- s: hello\[)(.a



=== TEST 11: . in []
--- re: [.]+
--- s: hello\[)(.a



=== TEST 12: . in []
--- re: [\.-9]+
--- s: -+(hello)_world.1234Blah(+



=== TEST 13: +-.
--- re: [\+-\.]+
--- s: -.,+(hello)_world.1234Blah(+



=== TEST 14:
--- re: x{1,}
--- s: hxxxxxx



=== TEST 15:
--- re: x{0,}
--- s: hxxxxxx



=== TEST 16:
--- re: x{0,}
--- s: hab



=== TEST 17:
--- re: x{1,}
--- s: hab



=== TEST 18:
--- re: x{0,1}
--- s: hab



=== TEST 19:
--- re: x{0,1}
--- s: haxb



=== TEST 20:
--- re: x{0, 1}
--- s: x{0, 1}



=== TEST 21:
--- re: x{0,1
--- s: x{0,1}



=== TEST 22:
--- re: x{0 ,1}
--- s: x{0 ,1}



=== TEST 23:
--- re: x{,12}
--- s: x{,12}



=== TEST 24:
--- re: x{1,1}
--- s: axxxx



=== TEST 25:
--- re: x{1,1}?
--- s: axxxx



=== TEST 26:
--- re: x{3,3}
--- s: axxxx



=== TEST 27:
--- re: x{1,3}
--- s: axxxx



=== TEST 28:
--- re: x{2,3}
--- s: axxxx



=== TEST 29:
--- re: x{2,3}?
--- s: axxxx



=== TEST 30:
--- re: x{1,3}?
--- s: axxxx



=== TEST 31:
--- re: x{1,}?
--- s: axxxx



=== TEST 32:
--- re: x{1,}
--- s: axxxx



=== TEST 33:
--- re: x{12,15}
--- s eval: 'x' x 16



=== TEST 34:
--- re: x{12,15}
--- s eval: 'x' x 16



=== TEST 35:
--- re: x{100,}
--- s eval: 'x' x 16
--- fatal



=== TEST 36: from exceeding 100
--- re: x{0,100}
--- s eval: 'x' x 16
--- fatal



=== TEST 37: to exceeding 100
--- re: {0,100}
--- s eval: 'x' x 16
--- fatal



=== TEST 38:
--- re: x{1}
--- s eval: 'x' x 16



=== TEST 39:
--- re: x{1}?
--- s eval: 'x' x 16



=== TEST 40:
--- re: x{2}
--- s eval: 'x' x 16



=== TEST 41:
--- re: x{2}?
--- s eval: 'x' x 16



=== TEST 42:
--- re: x{11}
--- s eval: 'x' x 16



=== TEST 43:
--- re: x{0,0}
--- s: hab



=== TEST 44: match a tab
--- re: \t
--- s eval: " \t"



=== TEST 45: match a tab in char class
--- re: [\t]
--- s eval: " \t"



=== TEST 46: match a newline
--- re: \n
--- s eval: " \n"



=== TEST 47: match a newline in char class
--- re: [\n]
--- s eval: " \n"



=== TEST 48: match a return
--- re: \r
--- s eval: " \r"



=== TEST 49: match a return in char class
--- re: [\r]
--- s eval: " \r"



=== TEST 50: match a form feed
--- re: \f
--- s eval: " \f"



