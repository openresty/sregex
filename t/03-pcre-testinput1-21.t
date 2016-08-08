# vim:set ft= ts=4 sw=4 et fdm=marker:

use t::SRegex 'no_plan';

run_tests();

__DATA__

=== TEST 1: testinput1:4930
--- re: \A.*?(?:a|bc|d)
--- s eval: "ba"



=== TEST 2: testinput1:4954
--- re: ^\N+
--- s eval: "abc\ndef"



=== TEST 3: testinput1:5260
--- re: ((?:a?)*)*c
--- s eval: "aac   "
--- cap: (0, 3) (0, 2)

