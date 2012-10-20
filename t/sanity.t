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

