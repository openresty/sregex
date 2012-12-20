# vim:set ft= ts=4 sw=4 et fdm=marker:

use t::SRegex 'no_plan';

run_tests();

__DATA__

=== TEST 1: re_tests:1539
--- re: [s\xDF]
--- s eval: "\xDFs"
--- flags: i



=== TEST 2: re_tests:1544
--- re: ff
--- s eval: "\x{FB00}\x{FB01}"
--- flags: i



=== TEST 3: re_tests:1545
--- re: ff
--- s eval: "\x{FB01}\x{FB00}"
--- flags: i



=== TEST 4: re_tests:1546
--- re: fi
--- s eval: "\x{FB01}\x{FB00}"
--- flags: i



=== TEST 5: re_tests:1547
--- re: fi
--- s eval: "\x{FB00}\x{FB01}"
--- flags: i



=== TEST 6: re_tests:1551
--- re: ffiffl
--- s eval: "abcdef\x{FB03}\x{FB04}"
--- flags: i



=== TEST 7: re_tests:1552
--- re: \xdf\xdf
--- s eval: "abcdefssss"
--- flags: i



=== TEST 8: re_tests:1554
--- re: st
--- s eval: "\x{DF}\x{FB05}"
--- flags: i



=== TEST 9: re_tests:1555
--- re: ssst
--- s eval: "\x{DF}\x{FB05}"
--- flags: i



=== TEST 10: re_tests:1563
--- re: s\xDF
--- s eval: "\xDFs"
--- flags: i



=== TEST 11: re_tests:1564
--- re: sst
--- s eval: "s\N{LATIN SMALL LIGATURE ST}"
--- flags: i



=== TEST 12: re_tests:1565
--- re: sst
--- s eval: "s\N{LATIN SMALL LIGATURE LONG S T}"
--- flags: i



=== TEST 13: re_tests:1599
--- re: [\h]
--- s eval: "\x{A0}"



=== TEST 14: re_tests:1600
--- re: [\H]
--- s eval: "\x{BF}"



=== TEST 15: re_tests:1601
--- re: [\H]
--- s eval: "\x{A0}"



=== TEST 16: re_tests:1602
--- re: [\H]
--- s eval: "\x{A1}"

