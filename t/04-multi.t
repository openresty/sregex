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



=== TEST 10: temp captures
--- re eval: ['BLAH', '\s+']
--- s eval: "abc \t\n\f\rd"
--- cap: (3, 8)
--- match_id: 1
--- temp_cap chop
[(1, -1)] [(2, -1)] [(3, -1)] [(3, -1)](3, 4) [(3, -1)](3, 5) [(3, -1)](3, 6) [(3, -1)](3, 7) [(3, -1)](3, 8)



=== TEST 11: syntax error at 2nd regex
--- re eval: ['BLAH', '(ab']
--- s eval: "abc \t\n\f\rd"
--- err
[error] regex 1: syntax error at pos 3



=== TEST 12: syntax error at 1st regex
--- re eval: ['(abc', 'BLAH']
--- s eval: "abc \t\n\f\rd"
--- err
[error] regex 0: syntax error at pos 4



=== TEST 13: ambiguity patterns (1st matched)
--- re eval: ['abcd', 'bc']
--- s eval: "abcd"
--- cap: (0, 4)
--- temp_cap: [(0, -1)] [(0, -1)] [(0, -1)](1, 3)



=== TEST 14: ambiguity patterns (2nd matched)
--- re eval: ['abcd', 'bc']
--- s eval: "abce"
--- cap: (1, 3)
--- temp_cap: [(0, -1)] [(0, -1)] [(0, -1)](1, 3)

