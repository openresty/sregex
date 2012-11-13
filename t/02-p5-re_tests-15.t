# vim:set ft= ts=4 sw=4 et fdm=marker:

use t::SRegex 'no_plan';

run_tests();

__DATA__

=== TEST 1: re_tests:1539
--- re: [s\xDF]
--- s eval: "\xDFs"



=== TEST 2: re_tests:1544
--- re: ff
--- s eval: "\x{FB00}\x{FB01}"



=== TEST 3: re_tests:1545
--- re: ff
--- s eval: "\x{FB01}\x{FB00}"



=== TEST 4: re_tests:1546
--- re: fi
--- s eval: "\x{FB01}\x{FB00}"



=== TEST 5: re_tests:1547
--- re: fi
--- s eval: "\x{FB00}\x{FB01}"



=== TEST 6: re_tests:1551
--- re: ffiffl
--- s eval: "abcdef\x{FB03}\x{FB04}"



=== TEST 7: re_tests:1552
--- re: \xdf\xdf
--- s eval: "abcdefssss"



=== TEST 8: re_tests:1554
--- re: st
--- s eval: "\x{DF}\x{FB05}"



=== TEST 9: re_tests:1555
--- re: ssst
--- s eval: "\x{DF}\x{FB05}"



=== TEST 10: re_tests:1563
--- re: s\xDF
--- s eval: "\xDFs"



=== TEST 11: re_tests:1564
--- re: sst
--- s eval: "s\N{LATIN SMALL LIGATURE ST}"



=== TEST 12: re_tests:1565
--- re: sst
--- s eval: "s\N{LATIN SMALL LIGATURE LONG S T}"

