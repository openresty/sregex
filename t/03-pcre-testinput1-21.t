# vim:set ft= ts=4 sw=4 et fdm=marker:

use t::SRegex 'no_plan';

run_tests();

__DATA__

=== TEST 1: testinput1:4345
--- re: \h*X\h?\H+Y\H?Z
--- s eval: "** Failers"



=== TEST 2: testinput1:4346
--- re: \h*X\h?\H+Y\H?Z
--- s eval: ">XYZ   "



=== TEST 3: testinput1:4347
--- re: \h*X\h?\H+Y\H?Z
--- s eval: ">  X NY Z"



=== TEST 4: testinput1:4350
--- re: \v*X\v?Y\v+Z\V*\x0a\V+\x0b\V{2,3}\x0c
--- s eval: ">XY\x0aZ\x0aA\x0bNN\x0c"



=== TEST 5: testinput1:4351
--- re: \v*X\v?Y\v+Z\V*\x0a\V+\x0b\V{2,3}\x0c
--- s eval: ">\x0a\x0dX\x0aY\x0a\x0bZZZ\x0aAAA\x0bNNN\x0c"



=== TEST 6: testinput1:4906
--- re: \A.*?(?:a|bc)
--- s eval: "ba"



=== TEST 7: testinput1:4912
--- re: \A.*?(a|bc)
--- s eval: "ba"



=== TEST 8: testinput1:4930
--- re: \A.*?(?:a|bc|d)
--- s eval: "ba"



=== TEST 9: testinput1:4954
--- re: ^\N+
--- s eval: "abc\ndef"



=== TEST 10: testinput1:5260
--- re: ((?:a?)*)*c
--- s eval: "aac   "
--- cap: (0, 3) (0, 2)

