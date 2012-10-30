# vim:set ft= ts=4 sw=4 et fdm=marker:

use t::SRegex 'no_plan';

run_tests();

__DATA__

=== TEST 1:
--- re: a|ab
--- s: bah



=== TEST 2:
--- re: a|(ab)
--- s: bah



=== TEST 3:
--- re: ab
--- s: abc



=== TEST 4:
--- re: a+
--- s: bhaaaca



=== TEST 5:
--- re: a*
--- s: bhc



=== TEST 6:
--- re: a*
--- s: bhac



=== TEST 7:
--- re: a?
--- s: bhc



=== TEST 8:
--- re: a?
--- s: bhac



=== TEST 9:
--- re: b.+?a
--- s: bhaaaca



=== TEST 10:
--- re: bh.+?a
--- s: bhac



=== TEST 11:
--- re: b.*?a
--- s: bhaaaca



=== TEST 12:
--- re: bh.*?a
--- s: bhac



=== TEST 13: non-greedy ?
--- re: a??
--- s: bhac



=== TEST 14: looping empty pattern (matching none)
re1 and re2 are wrong here
--- re: (a*)*
--- s: bhaac



=== TEST 15: looping empty pattern (matching one char)
perl and pcre are wrong here
--- re: (a*)*
--- s: a
--- cap: (0, 1) (0, 1)



=== TEST 16: looping empty pattern (matching one char, non-greedy)
re1 and re2 are wrong here.
--- re: (a*?)*
--- s: a



=== TEST 17: looping empty pattern
perl and pcre are wrong here.
--- re: (a?)*
--- s: a
--- cap: (0, 1) (0, 1)



=== TEST 18: looping empty pattern
re1 and re2 are wrong here.
--- re: (a??)*
--- s: a



=== TEST 19: looping empty pattern
re1 and re2 are wrong here.
--- re: (a*?)*
--- s: a



=== TEST 20: perl capturing semantics
--- re: (a|bcdef|g|ab|c|d|e|efg|fg)*
--- s: abcdefg



=== TEST 21:
--- re: (a+)(b+)
--- s: aabbbb



=== TEST 22: (?: ... )
--- re: (?:a+)(?:b+)
--- s: aabbbb



=== TEST 23: many captures exceeding $9
--- re eval: "(.)" x 12
--- s eval: "a" x 12



=== TEST 24:
--- re: (a|)
--- s: aabbbb



=== TEST 25:
--- re: (|a)
--- s: aabbbb



=== TEST 26: empty regex
--- re:
--- s: aabbbb



=== TEST 27: empty group
--- re: ()
--- s: aabbbb



=== TEST 28:
--- re: abab|abbb
--- s: abbb



=== TEST 29:
--- re: (a?)(a?)(a?)aaa
--- s: aaa



=== TEST 30: a common pathological regex
--- re: (.*) (.*) (.*) (.*) (.*)
--- s: a  c d ee fff



=== TEST 31: submatch semantics (greedy)
--- re: (.+)(.+)
--- s: abcd



=== TEST 32: submatch semantics (non-greedy)
--- re: (.+?)(.+?)
--- s: abcd



=== TEST 33: character class (single char ranges)
--- re: [az]+
--- s: -(aazbc+d



=== TEST 34: character class (two char ranges)
--- re: [a-z]+
--- s: -(aazbc+d



=== TEST 35: character class (two char ranges)
--- re: [^a-z]+
--- s: -(aazbc+d



=== TEST 36: character class (special char -)
--- re: [^-a-z]+
--- s: -aaz-bc+d



=== TEST 37: character class (special char "()")
--- re: [^()a-z]+
--- s: -a(az)-bc+d



=== TEST 38: character class (special char "()")
--- re: [()a-]+
--- s: -a(az)-bc+d



=== TEST 39: character class (special char "()")
--- re: [()a-z-A]+
--- s: -a(az)-bc+d



=== TEST 40: character class (two ranges)
--- re: [0-9A-Za-z]+
--- s: -hello_world1234Blah(+



=== TEST 41: \d
--- re: \d+
--- s: -hello_world1234Blah(+



=== TEST 42: \w
--- re: \w+
--- s: -hello_world1234Blah(+



=== TEST 43: \W
--- re: \W+
--- s: hello_world1234Blah(+-



=== TEST 44: \D
--- re: \D+
--- s: -+(hello)_world1234Blah(+



=== TEST 45: \s
--- re: \s+
--- s eval: "-+(hello) \t_world1234Blah(+"



=== TEST 46: \S
--- re: \S+
--- s eval: "-+(hello) \t_world1234Blah(+"



=== TEST 47: escaped \ and [
--- re: \\\[\)\(\.
--- s: hello\[)(.a



=== TEST 48: [\d]
--- re: [\d]+
--- s: -hello_world1234Blah(+



=== TEST 49: [B\d]
--- re: [B\d]+
--- s: -hello_world1234Blah(+



=== TEST 50: [\dB]
--- re: [\dB]+
--- s: -hello_world1234Blah(+



=== TEST 51: [^\d]
--- re: [^\d]+
--- s: -hello_world1234Blah(+



=== TEST 52: [a-\d]
--- re: [a-\d]+
--- s: -hello_world1234Blah(+



=== TEST 53:
--- re: [(\w]+
--- s: -hello_world1234Blah(+



=== TEST 54:
--- re: [\w(]+
--- s: -hello_world1234Blah(+



=== TEST 55:
--- re: [\s]+
--- s eval: "-+(hello) \t_world1234Blah(+"



=== TEST 56:
--- re: [\S]+
--- s eval: "-+(hello) \t_world1234Blah(+"



=== TEST 57: \W
--- re: [\W]+
--- s: hello_world1234Blah(+-



=== TEST 58: \D
--- re: [\D]+
--- s: -+(hello)_world1234Blah(+



=== TEST 59:
--- re: [^\D]+
--- s: -+(hello)_world1234Blah(+



=== TEST 60: escaped metachars
--- re: [\\\[\)\(\.]+
--- s: hello\[)(.a



=== TEST 61: . in []
--- re: [.]+
--- s: hello\[)(.a



=== TEST 62: . in []
--- re: [\.-9]+
--- s: -+(hello)_world.1234Blah(+



=== TEST 63: +-.
--- re: [\+-\.]+
--- s: -.,+(hello)_world.1234Blah(+



=== TEST 64:
--- re: x{1,}
--- s: hxxxxxx



=== TEST 65:
--- re: x{0,}
--- s: hxxxxxx



=== TEST 66:
--- re: x{0,}
--- s: hab



=== TEST 67:
--- re: x{1,}
--- s: hab



=== TEST 68:
--- re: x{0,1}
--- s: hab



=== TEST 69:
--- re: x{0,1}
--- s: haxb



=== TEST 70:
--- re: x{0, 1}
--- s: x{0, 1}



=== TEST 71:
--- re: x{0,1
--- s: x{0,1}



=== TEST 72:
--- re: x{0 ,1}
--- s: x{0 ,1}



=== TEST 73:
--- re: x{,12}
--- s: x{,12}



=== TEST 74:
--- re: x{1,1}
--- s: axxxx



=== TEST 75:
--- re: x{1,1}?
--- s: axxxx



=== TEST 76:
--- re: x{3,3}
--- s: axxxx



=== TEST 77:
--- re: x{1,3}
--- s: axxxx



=== TEST 78:
--- re: x{2,3}
--- s: axxxx



=== TEST 79:
--- re: x{2,3}?
--- s: axxxx



=== TEST 80:
--- re: x{1,3}?
--- s: axxxx



=== TEST 81:
--- re: x{1,}?
--- s: axxxx



=== TEST 82:
--- re: x{1,}
--- s: axxxx



=== TEST 83:
--- re: x{12,15}
--- s eval: 'x' x 16



=== TEST 84:
--- re: x{12,15}
--- s eval: 'x' x 16



=== TEST 85:
--- re: x{100,}
--- s eval: 'x' x 16
--- fatal



=== TEST 86: from exceeding 100
--- re: x{0,100}
--- s eval: 'x' x 16
--- fatal



=== TEST 87: to exceeding 100
--- re: {0,100}
--- s eval: 'x' x 16
--- fatal



=== TEST 88:
--- re: x{1}
--- s eval: 'x' x 16



=== TEST 89:
--- re: x{1}?
--- s eval: 'x' x 16



=== TEST 90:
--- re: x{2}
--- s eval: 'x' x 16



=== TEST 91:
--- re: x{2}?
--- s eval: 'x' x 16



=== TEST 92:
--- re: x{11}
--- s eval: 'x' x 16



=== TEST 93:
--- re: x{0,0}
--- s: hab



=== TEST 94: match a tab
--- re: \t
--- s eval: " \t"



=== TEST 95: match a tab in char class
--- re: [\t]
--- s eval: " \t"



=== TEST 96: match a newline
--- re: \n
--- s eval: " \n"



=== TEST 97: match a newline in char class
--- re: [\n]
--- s eval: " \n"



=== TEST 98: match a return
--- re: \r
--- s eval: " \r"



=== TEST 99: match a return in char class
--- re: [\r]
--- s eval: " \r"



=== TEST 100: match a form feed
--- re: \f
--- s eval: " \f"



=== TEST 101: match a form feed in char class
--- re: [\f]
--- s eval: " \f"



=== TEST 102: match an alarm feed
--- re: \a
--- s eval: " \a"



=== TEST 103: match an alarm in char class
--- re: [\a]
--- s eval: " \a"



=== TEST 104: match an escape feed
--- re: \e
--- s eval: " \e"



=== TEST 105: match an escape in char class
--- re: [\e]
--- s eval: " \e"



=== TEST 106: \A
--- re: \Ahello
--- s eval: "hello"



=== TEST 107: \A
--- re: \Ahello
--- s eval: "blah\nhello"



=== TEST 108: ^
--- re: ^hello
--- s eval: "hello"



=== TEST 109: ^
--- re: ^hello
--- s eval: "blah\nhello"



=== TEST 110: ^ not match
--- re: ^ello
--- s eval: "blah\nhello"



=== TEST 111: ^
--- re: (a.*(^hello))
--- s eval: "blah\nhello"



=== TEST 112: ^
--- re: ^
--- s:



=== TEST 113: ^
--- re: (^)+
--- s: "\n\n\n"



=== TEST 114: \z
--- re: hello\z
--- s eval: "blah\nhello"



=== TEST 115: \z
--- re: hello\z
--- s eval: "blah\nhello\n"



=== TEST 116: $
--- re: hello$
--- s eval: "blah\nhello"



=== TEST 117: $
--- re: hello$
--- s eval: "blah\nhello\n"



=== TEST 118: $
--- re: hell$
--- s eval: "blah\nhello\n"



=== TEST 119: $
--- re: \w+$
--- s eval: "blah\nhello"



=== TEST 120: $
--- re: .*(\w+)$
--- s eval: "blah\nhello"



=== TEST 121: $
--- re: .*(\w+)$\n
--- s eval: "blah\nhello"



=== TEST 122: $
--- re: ((\w+)$\n?)+
--- s eval: "a\nb"



=== TEST 123: $
--- re: ((\w+)$\n?)+
--- s eval: "abc\ndef"



=== TEST 124: \b
--- re: ab\b
--- s eval: "ab\ndef"



=== TEST 125: \b
--- re: ab\b
--- s eval: "abdef"



=== TEST 126: \b
--- re: ([+a])\b([-b])
--- s eval: "ab"



=== TEST 127: \b
--- re: ([+a])\b([-b])
--- s eval: "a-"



=== TEST 128: \b
--- re: ([+a])\b([-b])
--- s eval: "+-"



=== TEST 129: \b
--- re: ([+a])\b([-b])
--- s eval: "+b"



=== TEST 130: \b
--- re: ([+a])\b\b([-b])
--- s eval: "+b"



=== TEST 131: \b
--- re: \b([-b])
--- s eval: "b"



=== TEST 132: \b
--- re: \b([-b])
--- s eval: "-"



=== TEST 133: \b\z
--- re: a\b\z
--- s eval: "a\n"



=== TEST 134: \B
--- re: ([+a])\B([-b])
--- s eval: "ab"



=== TEST 135: \B
--- re: ([+a])\B([-b])
--- s eval: "a-"



=== TEST 136: \B
--- re: ([+a])\B([-b])
--- s eval: "+-"



=== TEST 137: \B
--- re: ([+a])\B([-b])
--- s eval: "+b"



=== TEST 138: \B
--- re: ([+a])\B\B([-b])
--- s eval: "+b"



=== TEST 139: \B
--- re: \B([-b])
--- s eval: "b"



=== TEST 140: \B
--- re: \B([-b])
--- s eval: "-"



=== TEST 141: \B\z
--- re: a\B\z
--- s eval: "a\n"



=== TEST 142: \h
--- re: \h+
--- s eval: "\f\r\t "



=== TEST 143: \H
--- re: \H+
--- s eval: "\f\r\t "



=== TEST 144: \v
--- re: \v+
--- s eval: " \t\n\x0b\f\r\x85\x86"



=== TEST 145: \V
--- re: \v+
--- s eval: "\x86 \t\n\x0b\f\r\x85"



=== TEST 146: \h
--- re: [\h]+
--- s eval: "\f\r\t "



=== TEST 147: \H
--- re: [\H]+
--- s eval: "\f\r\t "



=== TEST 148: \v
--- re: [\v]+
--- s eval: " \t\n\x0b\f\r\x85\x86"



=== TEST 149: \V
--- re: [\v]+
--- s eval: "\x86 \t\n\x0b\f\r\x85"



=== TEST 150: [\b]
--- re: [\b]+
--- s eval: "a\b\b"



=== TEST 151: [[]]
--- re: [[]]+
--- s eval: "a[[[[]]]]"



=== TEST 152: [][]
--- re: [][]+
--- s eval: "a[[[[]]]]"



=== TEST 153: [][]
--- re: [^][]+
--- s eval: "ab[[[[]]]]"



=== TEST 154: \N
--- re: \N+
--- s eval: "hello!\r\t "

