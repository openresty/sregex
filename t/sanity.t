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

