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

