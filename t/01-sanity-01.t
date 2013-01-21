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
--- re: a|(ab)
--- s: a



=== TEST 4:
--- re: a|(ab)
--- s: b



=== TEST 5:
--- re: ab
--- s: abc



=== TEST 6:
--- re: a+
--- s: bhaaaca



=== TEST 7:
--- re: a*
--- s: bhc



=== TEST 8:
--- re: a*
--- s: bhac



=== TEST 9:
--- re: a?
--- s: bhc



=== TEST 10:
--- re: a?
--- s: bhac



=== TEST 11: .+
--- re: .+
--- s:



=== TEST 12:
--- re: b.+?a
--- s: bhaaaca



=== TEST 13:
--- re: bh.+?a
--- s: bhac



=== TEST 14:
--- re: b.*?a
--- s: bhaaaca



=== TEST 15:
--- re: bh.*?a
--- s: bhac



=== TEST 16: non-greedy ?
--- re: a??
--- s: bhac



=== TEST 17: looping empty pattern (matching none)
re1 and re2 are wrong here
--- re: (a*)*
--- s: bhaac



=== TEST 18: looping empty pattern (matching one char)
perl and pcre are wrong here
--- re: (a*)*
--- s: a
--- cap: (0, 1) (0, 1)



=== TEST 19: looping empty pattern (matching one char, non-greedy)
re1 and re2 are wrong here.
--- re: (a*?)*
--- s: a



=== TEST 20: looping empty pattern
perl and pcre are wrong here.
--- re: (a?)*
--- s: a
--- cap: (0, 1) (0, 1)



=== TEST 21: looping empty pattern
re1 and re2 are wrong here.
--- re: (a??)*
--- s: a



=== TEST 22: looping empty pattern
re1 and re2 are wrong here.
--- re: (a*?)*
--- s: a



=== TEST 23: perl capturing semantics
--- re: (a|bcdef|g|ab|c|d|e|efg|fg)*
--- s: abcdefg



=== TEST 24:
--- re: (a+)(b+)
--- s: aabbbb



=== TEST 25: (?: ... )
--- re: (?:a+)(?:b+)
--- s: aabbbb



=== TEST 26: many captures exceeding $9
--- re eval: "(.)" x 12
--- s eval: "a" x 12



=== TEST 27:
--- re: (a|)
--- s: aabbbb



=== TEST 28:
--- re: (|a)
--- s: aabbbb



=== TEST 29: empty regex
--- re:
--- s: aabbbb



=== TEST 30: empty group
--- re: ()
--- s: aabbbb



=== TEST 31:
--- re: abab|abbb
--- s: abbb



=== TEST 32:
--- re: (a?)(a?)(a?)aaa
--- s: aaa



=== TEST 33: a common pathological regex
--- re: (.*) (.*) (.*) (.*) (.*)
--- s: a  c d ee fff



=== TEST 34: submatch semantics (greedy)
--- re: (.+)(.+)
--- s: abcd



=== TEST 35: submatch semantics (non-greedy)
--- re: (.+?)(.+?)
--- s: abcd



=== TEST 36: character class (single char ranges)
--- re: [az]+
--- s: -(aazbc+d



=== TEST 37: character class (single char ranges)
--- re: [az]+
--- s: -(bc+d



=== TEST 38: character class (two char ranges)
--- re: [a-z]+
--- s: -(aazbc+d



=== TEST 39: character class (two char ranges)
--- re: [a-z]+
--- s: -([*y*+



=== TEST 40: character class (two char ranges)
--- re: [a-z]+
--- s: -([*/+



=== TEST 41: character class (two char ranges)
--- re: [^a-z]+
--- s: -(aazbc+d



=== TEST 42: character class (special char -)
--- re: [^-a-z]+
--- s: -aaz-bc+d



=== TEST 43: character class (special char "()")
--- re: [^()a-z]+
--- s: -a(az)-bc+d



=== TEST 44: character class (special char "()")
--- re: [()a-]+
--- s: -a(az)-bc+d



=== TEST 45: character class (special char "()")
--- re: [()a-z-A]+
--- s: -a(az)-bc+d



=== TEST 46: character class (two ranges)
--- re: [0-9A-Za-z]+
--- s: -hello_world1234Blah(+



=== TEST 47: \d
--- re: \d+
--- s: -hello_world1234Blah(+



=== TEST 48: \w
--- re: \w+
--- s: -hello_world1234Blah(+



=== TEST 49: \W
--- re: \W+
--- s: hello_world1234Blah(+-



=== TEST 50: \D
--- re: \D+
--- s: -+(hello)_world1234Blah(+



