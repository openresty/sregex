# vim:set ft= ts=4 sw=4 et fdm=marker:

use t::SRegex 'no_plan';

run_tests();

__DATA__

=== TEST 1:
--- re eval: ["a", "ab"]
--- s: bah
--- cap: (1, 2)
--- match_id: 0



=== TEST 2:
--- re eval: ["a", "ab"]
--- s: bab
--- cap: (1, 2)
--- match_id: 0



=== TEST 3:
--- re eval: ["c", "ab"]
--- s: babc
--- cap: (1, 3)
--- match_id: 1



=== TEST 4: submatches
--- re eval: ["a(bc)", "e(f)"]
--- s: babc
--- cap: (1, 4) (2, 4)
--- match_id: 0



=== TEST 5: submatches
--- re eval: ["a(bc)", "e(f)", "gh"]
--- s: bef
--- cap: (1, 3) (2, 3)
--- match_id: 1



=== TEST 6: submatches
--- re eval: ["a(bc)", "e(f)", "gh"]
--- s: gh
--- cap eval: qr/^\(0, 2\)/
--- match_id: 2



=== TEST 7: submatches
--- re eval: ["A", "A"]
--- s: ga
--- cap: (1, 2)
--- flags eval: " i"
--- match_id: 1



=== TEST 8: submatches
--- re eval: ["A", "A"]
--- s: ga
--- cap: (1, 2)
--- flags eval: "i i"
--- match_id: 0



=== TEST 9: not matched
--- re eval: ["a", "b"]
--- s: cde
--- flags eval: "i i"
--- no_match

