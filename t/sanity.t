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



=== TEST 13:
--- re: a??
--- s: bhac

