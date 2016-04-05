# vim:set ft= ts=4 sw=4 et fdm=marker:

use t::SRegex 'no_plan';

run_tests();

__DATA__

=== TEST 1: \&
--- re: a\&b
--- s eval: 'a&b'



=== TEST 2: [\&]
--- re: a[\&]b
--- s eval: 'a&b'



=== TEST 3: \# \" \'
--- re: a\#\"\'b
--- s eval: 'a#"\'b'



=== TEST 4: [\#\"\']
--- re: [a\#\"\'b]{4}
--- s eval: 'a#"\'b'
