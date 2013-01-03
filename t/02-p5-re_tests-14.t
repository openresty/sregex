# vim:set ft= ts=4 sw=4 et fdm=marker:

use t::SRegex 'no_plan';

run_tests();

__DATA__

=== TEST 1: re_tests:1377
--- re: (\h+)(\H)
--- s eval: "foo\t\x{A0}bar"



=== TEST 2: re_tests:1378
--- re: foo(\h)bar
--- s eval: "foo\x{A0}bar"



=== TEST 3: re_tests:1379
--- re: (\H)(\h)
--- s eval: "foo\x{A0}bar"



=== TEST 4: re_tests:1380
--- re: (\h)(\H)
--- s eval: "foo\x{A0}bar"



=== TEST 5: re_tests:1381
--- re: foo(\h)bar
--- s eval: "foo\tbar"



=== TEST 6: re_tests:1382
--- re: (\H)(\h)
--- s eval: "foo\tbar"



=== TEST 7: re_tests:1383
--- re: (\h)(\H)
--- s eval: "foo\tbar"



=== TEST 8: re_tests:1385
--- re: .*\z
--- s eval: "foo\n"



=== TEST 9: re_tests:1386
--- re: \N*\z
--- s eval: "foo\n"



=== TEST 10: re_tests:1389
--- re: ^(?:(\d)x)?\d$
--- s eval: "1"



=== TEST 11: re_tests:1390
--- re: .*?(?:(\w)|(\w))x
--- s eval: "abx"



=== TEST 12: re_tests:1392
--- re: 0{50}
--- s eval: "000000000000000000000000000000000000000000000000000"



=== TEST 13: re_tests:1395
--- re: >\d+$ \n
--- s eval: ">10\n"
--- flags: i



=== TEST 14: re_tests:1396
--- re: >\d+$ \n
--- s eval: ">1\n"
--- flags: i



=== TEST 15: re_tests:1397
--- re: \d+$ \n
--- s eval: ">10\n"
--- flags: i



=== TEST 16: re_tests:1398
--- re: >\d\d$ \n
--- s eval: ">10\n"
--- flags: i



=== TEST 17: re_tests:1399
--- re: >\d+$ \n
--- s eval: ">10\n"



=== TEST 18: re_tests:1403
--- re: ^\s*i.*?o\s*$
--- s eval: "io\n io"



=== TEST 19: re_tests:1416
--- re: [\s][\S]
--- s eval: "\x{a0}\x{a0}"



=== TEST 20: re_tests:1424
--- re: abc\N\{U+BEEF}
--- s eval: "abc\n{UBEEF}"



=== TEST 21: re_tests:1425
--- re: abc\N\{U+BEEF}
--- s eval: "abc.{UBEEF}"



=== TEST 22: re_tests:1426
--- re: [abc\N\{U+BEEF}]
--- s eval: "-"
--- err_like: ^\[error\] syntax error at pos \d+$



=== TEST 23: re_tests:1429
--- re: abc\N
--- s eval: "abcd"



=== TEST 24: re_tests:1430
--- re: abc\N
--- s eval: "abc\n"



=== TEST 25: re_tests:1437
--- re: abc\N{def
--- s eval: "-"
--- err_like: ^\[error\] syntax error at pos \d+$
--- SKIP



=== TEST 26: re_tests:1447
--- re: abc\N{def
--- s eval: "-"
--- err_like: ^\[error\] syntax error at pos \d+$
--- SKIP



=== TEST 27: re_tests:1450
--- re: abc\N {U+41}
--- s eval: "-"



=== TEST 28: re_tests:1451
--- re: abc\N {SPACE}
--- s eval: "-"



=== TEST 29: re_tests:1460
--- re: \c`
--- s eval: "-"



=== TEST 30: re_tests:1461
--- re: \c1
--- s eval: "-"



=== TEST 31: re_tests:1462
--- re: \cA
--- s eval: "\001"



=== TEST 32: re_tests:1470
--- re: \o{120}
--- s eval: "\x{50}"



=== TEST 33: re_tests:1473
--- re: [a\o{120}]
--- s eval: "\x{50}"



=== TEST 34: re_tests:1483
--- re: [\0]
--- s eval: "\000"



=== TEST 35: re_tests:1484
--- re: [\07]
--- s eval: "\007"



=== TEST 36: re_tests:1485
--- re: [\07]
--- s eval: "7\000"



=== TEST 37: re_tests:1486
--- re: [\006]
--- s eval: "\006"



=== TEST 38: re_tests:1487
--- re: [\006]
--- s eval: "6\000"



=== TEST 39: re_tests:1488
--- re: [\0005]
--- s eval: "\0005"



=== TEST 40: re_tests:1489
--- re: [\0005]
--- s eval: "5\000"



=== TEST 41: re_tests:1490
--- re: [\_]
--- s eval: "_"



=== TEST 42: re_tests:1493
--- re: (q1|.)*(q2|.)*(x(a|bc)*y){2,}
--- s eval: "xayxay"



=== TEST 43: re_tests:1494
--- re: (q1|.)*(q2|.)*(x(a|bc)*y){2,3}
--- s eval: "xayxay"



=== TEST 44: re_tests:1495
--- re: (q1|z)*(q2|z)*z{15}-.*?(x(a|bc)*y){2,3}Z
--- s eval: "zzzzzzzzzzzzzzzz-xayxayxayxayZ"



=== TEST 45: re_tests:1497
--- re: (?:(?:)foo|bar|zot|rt78356)
--- s eval: "foo"



=== TEST 46: re_tests:1518
--- re: s
--- s eval: "\x{17F}"
--- flags: i



=== TEST 47: re_tests:1519
--- re: s
--- s eval: "\x{17F}"
--- flags: i



=== TEST 48: re_tests:1520
--- re: s
--- s eval: "S"
--- flags: i



=== TEST 49: re_tests:1530
--- re: ^.*\d\H
--- s eval: "X1"



=== TEST 50: re_tests:1531
--- re: ^.*\d\V
--- s eval: "X1"



