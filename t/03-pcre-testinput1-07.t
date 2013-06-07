# vim:set ft= ts=4 sw=4 et fdm=marker:

use t::SRegex 'no_plan';

run_tests();

__DATA__

=== TEST 1: testinput1:1350
--- re: ab{1,3}bc
--- s eval: "abc"



=== TEST 2: testinput1:1351
--- re: ab{1,3}bc
--- s eval: "abbbbbc"



=== TEST 3: testinput1:1354
--- re: ([^.]*)\.([^:]*):[T ]+(.*)
--- s eval: "track1.title:TBlah blah blah"



=== TEST 4: testinput1:1357
--- re: ([^.]*)\.([^:]*):[T ]+(.*)
--- s eval: "track1.title:TBlah blah blah"
--- flags: i



=== TEST 5: testinput1:1360
--- re: ([^.]*)\.([^:]*):[t ]+(.*)
--- s eval: "track1.title:TBlah blah blah"
--- flags: i



=== TEST 6: testinput1:1363
--- re: ^[W-c]+$
--- s eval: "WXY_^abc"



=== TEST 7: testinput1:1364
--- re: ^[W-c]+$
--- s eval: "*** Failers"



=== TEST 8: testinput1:1365
--- re: ^[W-c]+$
--- s eval: "wxy"



=== TEST 9: testinput1:1368
--- re: ^[W-c]+$
--- s eval: "WXY_^abc"
--- flags: i



=== TEST 10: testinput1:1369
--- re: ^[W-c]+$
--- s eval: "wxy_^ABC"
--- flags: i



=== TEST 11: testinput1:1372
--- re: ^[\x3f-\x5F]+$
--- s eval: "WXY_^abc"
--- flags: i



=== TEST 12: testinput1:1373
--- re: ^[\x3f-\x5F]+$
--- s eval: "wxy_^ABC"
--- flags: i



=== TEST 13: testinput1:1376
--- re: ^abc$
--- s eval: "abc"



=== TEST 14: testinput1:1377
--- re: ^abc$
--- s eval: "qqq\nabc"



=== TEST 15: testinput1:1378
--- re: ^abc$
--- s eval: "abc\nzzz"



=== TEST 16: testinput1:1379
--- re: ^abc$
--- s eval: "qqq\nabc\nzzz"



=== TEST 17: testinput1:1383
--- re: ^abc$
--- s eval: "*** Failers"



=== TEST 18: testinput1:1404
--- re: (?:b)|(?::+)
--- s eval: "b::c"



=== TEST 19: testinput1:1405
--- re: (?:b)|(?::+)
--- s eval: "c::b"



=== TEST 20: testinput1:1408
--- re: [-az]+
--- s eval: "az-"



=== TEST 21: testinput1:1409
--- re: [-az]+
--- s eval: "*** Failers"



=== TEST 22: testinput1:1410
--- re: [-az]+
--- s eval: "b"



=== TEST 23: testinput1:1413
--- re: [az-]+
--- s eval: "za-"



=== TEST 24: testinput1:1414
--- re: [az-]+
--- s eval: "*** Failers"



=== TEST 25: testinput1:1415
--- re: [az-]+
--- s eval: "b"



=== TEST 26: testinput1:1418
--- re: [a\-z]+
--- s eval: "a-z"



=== TEST 27: testinput1:1419
--- re: [a\-z]+
--- s eval: "*** Failers"



=== TEST 28: testinput1:1420
--- re: [a\-z]+
--- s eval: "b"



=== TEST 29: testinput1:1423
--- re: [a-z]+
--- s eval: "abcdxyz"



=== TEST 30: testinput1:1426
--- re: [\d-]+
--- s eval: "12-34"



=== TEST 31: testinput1:1427
--- re: [\d-]+
--- s eval: "*** Failers"



=== TEST 32: testinput1:1428
--- re: [\d-]+
--- s eval: "aaa"



=== TEST 33: testinput1:1431
--- re: [\d-z]+
--- s eval: "12-34z"



=== TEST 34: testinput1:1432
--- re: [\d-z]+
--- s eval: "*** Failers"



=== TEST 35: testinput1:1433
--- re: [\d-z]+
--- s eval: "aaa"



=== TEST 36: testinput1:1436
--- re: \x5c
--- s eval: "\\"



=== TEST 37: testinput1:1439
--- re: \x20Z
--- s eval: "the Zoo"



=== TEST 38: testinput1:1440
--- re: \x20Z
--- s eval: "*** Failers"



=== TEST 39: testinput1:1441
--- re: \x20Z
--- s eval: "Zulu"



=== TEST 40: testinput1:1449
--- re: ab{3cd
--- s eval: "ab{3cd"



=== TEST 41: testinput1:1452
--- re: ab{3,cd
--- s eval: "ab{3,cd"



=== TEST 42: testinput1:1455
--- re: ab{3,4a}cd
--- s eval: "ab{3,4a}cd"



=== TEST 43: testinput1:1458
--- re: {4,5a}bc
--- s eval: "{4,5a}bc"



=== TEST 44: testinput1:1461
--- re: abc$
--- s eval: "abc"



=== TEST 45: testinput1:1462
--- re: abc$
--- s eval: "abc\n"



=== TEST 46: testinput1:1463
--- re: abc$
--- s eval: "*** Failers"



=== TEST 47: testinput1:1464
--- re: abc$
--- s eval: "abc\ndef"



=== TEST 48: testinput1:1502
--- re: ab\idef
--- s eval: "abidef"



=== TEST 49: testinput1:1505
--- re: a{0}bc
--- s eval: "bc"



=== TEST 50: testinput1:1508
--- re: (a|(bc)){0,0}?xyz
--- s eval: "xyz"
--- cap: (0, 3)



