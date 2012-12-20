# vim:set ft= ts=4 sw=4 et fdm=marker:

use t::SRegex 'no_plan';

run_tests();

__DATA__

=== TEST 1: testinput1:1523
--- re: ^([^a])([^\b])([^c]*)([^d]{3,4})
--- s eval: "baNOTccccd"



=== TEST 2: testinput1:1524
--- re: ^([^a])([^\b])([^c]*)([^d]{3,4})
--- s eval: "baNOTcccd"



=== TEST 3: testinput1:1525
--- re: ^([^a])([^\b])([^c]*)([^d]{3,4})
--- s eval: "baNOTccd"



=== TEST 4: testinput1:1526
--- re: ^([^a])([^\b])([^c]*)([^d]{3,4})
--- s eval: "bacccd"



=== TEST 5: testinput1:1527
--- re: ^([^a])([^\b])([^c]*)([^d]{3,4})
--- s eval: "*** Failers"



=== TEST 6: testinput1:1528
--- re: ^([^a])([^\b])([^c]*)([^d]{3,4})
--- s eval: "anything"



=== TEST 7: testinput1:1529
--- re: ^([^a])([^\b])([^c]*)([^d]{3,4})
--- s eval: "b\bc   "



=== TEST 8: testinput1:1530
--- re: ^([^a])([^\b])([^c]*)([^d]{3,4})
--- s eval: "baccd"



=== TEST 9: testinput1:1533
--- re: [^a]
--- s eval: "Abc"



=== TEST 10: testinput1:1536
--- re: [^a]
--- s eval: "Abc "
--- flags: i



=== TEST 11: testinput1:1539
--- re: [^a]+
--- s eval: "AAAaAbc"



=== TEST 12: testinput1:1542
--- re: [^a]+
--- s eval: "AAAaAbc "
--- flags: i



=== TEST 13: testinput1:1545
--- re: [^a]+
--- s eval: "bbb\nccc"



=== TEST 14: testinput1:1548
--- re: [^k]$
--- s eval: "abc"



=== TEST 15: testinput1:1549
--- re: [^k]$
--- s eval: "*** Failers"



=== TEST 16: testinput1:1550
--- re: [^k]$
--- s eval: "abk   "



=== TEST 17: testinput1:1553
--- re: [^k]{2,3}$
--- s eval: "abc"



=== TEST 18: testinput1:1554
--- re: [^k]{2,3}$
--- s eval: "kbc"



=== TEST 19: testinput1:1555
--- re: [^k]{2,3}$
--- s eval: "kabc "



=== TEST 20: testinput1:1556
--- re: [^k]{2,3}$
--- s eval: "*** Failers"



=== TEST 21: testinput1:1557
--- re: [^k]{2,3}$
--- s eval: "abk"



=== TEST 22: testinput1:1558
--- re: [^k]{2,3}$
--- s eval: "akb"



=== TEST 23: testinput1:1559
--- re: [^k]{2,3}$
--- s eval: "akk "



=== TEST 24: testinput1:1562
--- re: ^\d{8,}\@.+[^k]$
--- s eval: "12345678\@a.b.c.d"



=== TEST 25: testinput1:1563
--- re: ^\d{8,}\@.+[^k]$
--- s eval: "123456789\@x.y.z"



=== TEST 26: testinput1:1564
--- re: ^\d{8,}\@.+[^k]$
--- s eval: "*** Failers"



=== TEST 27: testinput1:1565
--- re: ^\d{8,}\@.+[^k]$
--- s eval: "12345678\@x.y.uk"



=== TEST 28: testinput1:1566
--- re: ^\d{8,}\@.+[^k]$
--- s eval: "1234567\@a.b.c.d       "



=== TEST 29: testinput1:1575
--- re: [^a]
--- s eval: "aaaabcd"



=== TEST 30: testinput1:1576
--- re: [^a]
--- s eval: "aaAabcd "



=== TEST 31: testinput1:1579
--- re: [^a]
--- s eval: "aaaabcd"
--- flags: i



=== TEST 32: testinput1:1580
--- re: [^a]
--- s eval: "aaAabcd "
--- flags: i



=== TEST 33: testinput1:1583
--- re: [^az]
--- s eval: "aaaabcd"



=== TEST 34: testinput1:1584
--- re: [^az]
--- s eval: "aaAabcd "



=== TEST 35: testinput1:1587
--- re: [^az]
--- s eval: "aaaabcd"
--- flags: i



=== TEST 36: testinput1:1588
--- re: [^az]
--- s eval: "aaAabcd "
--- flags: i



=== TEST 37: testinput1:1594
--- re: P[^*]TAIRE[^*]{1,6}?LL
--- s eval: "xxxxxxxxxxxPSTAIREISLLxxxxxxxxx"



=== TEST 38: testinput1:1597
--- re: P[^*]TAIRE[^*]{1,}?LL
--- s eval: "xxxxxxxxxxxPSTAIREISLLxxxxxxxxx"



=== TEST 39: testinput1:1600
--- re: (\.\d\d[1-9]?)\d+
--- s eval: "1.230003938"



=== TEST 40: testinput1:1601
--- re: (\.\d\d[1-9]?)\d+
--- s eval: "1.875000282   "



=== TEST 41: testinput1:1602
--- re: (\.\d\d[1-9]?)\d+
--- s eval: "1.235  "



=== TEST 42: testinput1:1614
--- re: \b(foo)\s+(\w+)
--- s eval: "Food is on the foo table"
--- flags: i



=== TEST 43: testinput1:1617
--- re: foo(.*)bar
--- s eval: "The food is under the bar in the barn."



=== TEST 44: testinput1:1620
--- re: foo(.*?)bar
--- s eval: "The food is under the bar in the barn."



=== TEST 45: testinput1:1623
--- re: (.*)(\d*)
--- s eval: "I have 2 numbers: 53147"



=== TEST 46: testinput1:1626
--- re: (.*)(\d+)
--- s eval: "I have 2 numbers: 53147"



=== TEST 47: testinput1:1629
--- re: (.*?)(\d*)
--- s eval: "I have 2 numbers: 53147"



=== TEST 48: testinput1:1632
--- re: (.*?)(\d+)
--- s eval: "I have 2 numbers: 53147"



=== TEST 49: testinput1:1635
--- re: (.*)(\d+)$
--- s eval: "I have 2 numbers: 53147"



=== TEST 50: testinput1:1638
--- re: (.*?)(\d+)$
--- s eval: "I have 2 numbers: 53147"



