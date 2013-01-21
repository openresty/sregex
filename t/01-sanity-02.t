# vim:set ft= ts=4 sw=4 et fdm=marker:

use t::SRegex 'no_plan';

run_tests();

__DATA__

=== TEST 1: \s
--- re: \s+
--- s eval: "-+(hello) \t_world1234Blah(+"



=== TEST 2: \S
--- re: \S+
--- s eval: "-+(hello) \t_world1234Blah(+"



=== TEST 3: escaped \ and [
--- re: \\\[\)\(\.
--- s: hello\[)(.a



=== TEST 4: [\d]
--- re: [\d]+
--- s: -hello_world1234Blah(+



=== TEST 5: [B\d]
--- re: [B\d]+
--- s: -hello_world1234Blah(+



=== TEST 6: [\dB]
--- re: [\dB]+
--- s: -hello_world1234Blah(+



=== TEST 7: [^\d]
--- re: [^\d]+
--- s: -hello_world1234Blah(+



=== TEST 8: [^\d]
--- re: [^\d]+
--- s: 0159783



=== TEST 9: [^az\d]
--- re: [^az\d]+
--- s: 0159a783z



=== TEST 10: [^az\d]
--- re: [^az\d]+
--- s: 0159a783zd



=== TEST 11: [az\d]
--- re: [az\d]+
--- s: +-*(byd



=== TEST 12: [az\d]
--- re: [az\d]+
--- s: +-*(byd9



=== TEST 13: [az\d]
--- re: [az\d]+
--- s: +-*(bydz



=== TEST 14: [a-\d]
--- re: [a-\d]+
--- s: -hello_world1234Blah(+



=== TEST 15:
--- re: [(\w]+
--- s: -hello_world1234Blah(+



=== TEST 16:
--- re: [\w(]+
--- s: -hello_world1234Blah(+



=== TEST 17:
--- re: [\s]+
--- s eval: "-+(hello) \t_world1234Blah(+"



=== TEST 18:
--- re: [\S]+
--- s eval: "a"



=== TEST 19:
--- re: [a-\xfe]+
--- s eval: "b"



=== TEST 20:
--- re: [\S]+
--- s eval: "-+(hello) \t_world1234Blah(+"



=== TEST 21: \W
--- re: [\W]+
--- s: hello_world1234Blah(+-



=== TEST 22: \D
--- re: [\D]+
--- s: -+(hello)_world1234Blah(+



=== TEST 23:
--- re: [^\D]+
--- s: -+(hello)_world1234Blah(+



=== TEST 24: escaped metachars
--- re: [\\\[\)\(\.]+
--- s: hello\[)(.a



=== TEST 25: . in []
--- re: [.]+
--- s: hello\[)(.a



=== TEST 26: . in []
--- re: [\.-9]+
--- s: -+(hello)_world.1234Blah(+



=== TEST 27: +-.
--- re: [\+-\.]+
--- s: -.,+(hello)_world.1234Blah(+



=== TEST 28:
--- re: x{1,}
--- s: hxxxxxx



=== TEST 29:
--- re: x{0,}
--- s: hxxxxxx



=== TEST 30:
--- re: x{0,}
--- s: hab



=== TEST 31:
--- re: x{1,}
--- s: hab



=== TEST 32:
--- re: x{0,1}
--- s: hab



=== TEST 33:
--- re: x{0,1}
--- s: haxb



=== TEST 34:
--- re: x{0, 1}
--- s: x{0, 1}



=== TEST 35:
--- re: x{0,1
--- s: x{0,1}



=== TEST 36:
--- re: x{0 ,1}
--- s: x{0 ,1}



=== TEST 37:
--- re: x{,12}
--- s: x{,12}



=== TEST 38:
--- re: x{1,1}
--- s: axxxx



=== TEST 39:
--- re: x{1,1}?
--- s: axxxx



=== TEST 40:
--- re: x{3,3}
--- s: axxxx



=== TEST 41:
--- re: x{1,3}
--- s: axxxx



=== TEST 42:
--- re: x{2,3}
--- s: axxxx



=== TEST 43:
--- re: x{2,3}?
--- s: axxxx



=== TEST 44:
--- re: x{1,3}?
--- s: axxxx



=== TEST 45:
--- re: x{1,}?
--- s: axxxx



=== TEST 46:
--- re: x{1,}
--- s: axxxx



=== TEST 47:
--- re: x{12,15}
--- s eval: 'x' x 16



=== TEST 48:
--- re: x{12,15}
--- s eval: 'x' x 16



=== TEST 49:
--- re: x{100,}
--- s eval: 'x' x 16
--- fatal



=== TEST 50: from exceeding 100
--- re: x{0,100}
--- s eval: 'x' x 16
--- fatal



