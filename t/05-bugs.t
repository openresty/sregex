# vim:set ft= ts=4 sw=4 et fdm=marker:

use t::SRegex 'no_plan';

run_tests();

__DATA__

=== TEST 1: integer overflow in \ddd
--- re: \777
--- s eval: "\377"
--- err
[error] syntax error at pos 0



=== TEST 2: integer overflow in \ddd (char class)
--- re: [\777]
--- s eval: "\377"
--- err
[error] syntax error at pos 0



=== TEST 3: integer overflow in \o{ddd}
--- re: \o{777}
--- s eval: "\377"
--- err
[error] syntax error at pos 0



=== TEST 4: integer overflow in \o{ddd} (char class)
--- re: [\o{777}]
--- s eval: "\377"
--- err
[error] syntax error at pos 0



=== TEST 5: integer overflow in \x{ddd}
--- re: \x{100}
--- s eval: "\377"
--- err
[error] syntax error at pos 0

