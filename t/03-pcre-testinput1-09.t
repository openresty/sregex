# vim:set ft= ts=4 sw=4 et fdm=marker:

use t::SRegex 'no_plan';

run_tests();

__DATA__

=== TEST 1: testinput1:1641
--- re: (.*)\b(\d+)$
--- s eval: "I have 2 numbers: 53147"



=== TEST 2: testinput1:1644
--- re: (.*\D)(\d+)$
--- s eval: "I have 2 numbers: 53147"



=== TEST 3: testinput1:1655
--- re: ^[W-]46]
--- s eval: "W46]789 "



=== TEST 4: testinput1:1656
--- re: ^[W-]46]
--- s eval: "-46]789"



=== TEST 5: testinput1:1657
--- re: ^[W-]46]
--- s eval: "*** Failers"



=== TEST 6: testinput1:1658
--- re: ^[W-]46]
--- s eval: "Wall"



=== TEST 7: testinput1:1659
--- re: ^[W-]46]
--- s eval: "Zebra"



=== TEST 8: testinput1:1660
--- re: ^[W-]46]
--- s eval: "42"



=== TEST 9: testinput1:1661
--- re: ^[W-]46]
--- s eval: "[abcd] "



=== TEST 10: testinput1:1662
--- re: ^[W-]46]
--- s eval: "]abcd["



=== TEST 11: testinput1:1665
--- re: ^[W-\]46]
--- s eval: "W46]789 "



=== TEST 12: testinput1:1666
--- re: ^[W-\]46]
--- s eval: "Wall"



=== TEST 13: testinput1:1667
--- re: ^[W-\]46]
--- s eval: "Zebra"



=== TEST 14: testinput1:1668
--- re: ^[W-\]46]
--- s eval: "Xylophone  "



=== TEST 15: testinput1:1669
--- re: ^[W-\]46]
--- s eval: "42"



=== TEST 16: testinput1:1670
--- re: ^[W-\]46]
--- s eval: "[abcd] "



=== TEST 17: testinput1:1671
--- re: ^[W-\]46]
--- s eval: "]abcd["



=== TEST 18: testinput1:1672
--- re: ^[W-\]46]
--- s eval: "\\backslash "



=== TEST 19: testinput1:1673
--- re: ^[W-\]46]
--- s eval: "*** Failers"



=== TEST 20: testinput1:1674
--- re: ^[W-\]46]
--- s eval: "-46]789"



=== TEST 21: testinput1:1675
--- re: ^[W-\]46]
--- s eval: "well"



=== TEST 22: testinput1:1678
--- re: \d\d\/\d\d\/\d\d\d\d
--- s eval: "01/01/2000"



=== TEST 23: testinput1:1681
--- re: word (?:[a-zA-Z0-9]+ ){0,10}otherword
--- s eval: "word cat dog elephant mussel cow horse canary baboon snake shark otherword"



=== TEST 24: testinput1:1682
--- re: word (?:[a-zA-Z0-9]+ ){0,10}otherword
--- s eval: "word cat dog elephant mussel cow horse canary baboon snake shark"



=== TEST 25: testinput1:1685
--- re: word (?:[a-zA-Z0-9]+ ){0,300}otherword
--- s eval: "word cat dog elephant mussel cow horse canary baboon snake shark the quick brown fox and the lazy dog and several other words getting close to thirty by now I hope"



=== TEST 26: testinput1:1688
--- re: ^(a){0,0}
--- s eval: "bcd"



=== TEST 27: testinput1:1689
--- re: ^(a){0,0}
--- s eval: "abc"



=== TEST 28: testinput1:1690
--- re: ^(a){0,0}
--- s eval: "aab     "



=== TEST 29: testinput1:1693
--- re: ^(a){0,1}
--- s eval: "bcd"



=== TEST 30: testinput1:1694
--- re: ^(a){0,1}
--- s eval: "abc"



=== TEST 31: testinput1:1695
--- re: ^(a){0,1}
--- s eval: "aab  "



=== TEST 32: testinput1:1698
--- re: ^(a){0,2}
--- s eval: "bcd"



=== TEST 33: testinput1:1699
--- re: ^(a){0,2}
--- s eval: "abc"



=== TEST 34: testinput1:1700
--- re: ^(a){0,2}
--- s eval: "aab  "



=== TEST 35: testinput1:1703
--- re: ^(a){0,3}
--- s eval: "bcd"



=== TEST 36: testinput1:1704
--- re: ^(a){0,3}
--- s eval: "abc"



=== TEST 37: testinput1:1705
--- re: ^(a){0,3}
--- s eval: "aab"



=== TEST 38: testinput1:1706
--- re: ^(a){0,3}
--- s eval: "aaa   "



=== TEST 39: testinput1:1709
--- re: ^(a){0,}
--- s eval: "bcd"



=== TEST 40: testinput1:1710
--- re: ^(a){0,}
--- s eval: "abc"



=== TEST 41: testinput1:1711
--- re: ^(a){0,}
--- s eval: "aab"



=== TEST 42: testinput1:1712
--- re: ^(a){0,}
--- s eval: "aaa"



=== TEST 43: testinput1:1713
--- re: ^(a){0,}
--- s eval: "aaaaaaaa    "



=== TEST 44: testinput1:1716
--- re: ^(a){1,1}
--- s eval: "bcd"



=== TEST 45: testinput1:1717
--- re: ^(a){1,1}
--- s eval: "abc"



=== TEST 46: testinput1:1718
--- re: ^(a){1,1}
--- s eval: "aab  "



=== TEST 47: testinput1:1721
--- re: ^(a){1,2}
--- s eval: "bcd"



=== TEST 48: testinput1:1722
--- re: ^(a){1,2}
--- s eval: "abc"



=== TEST 49: testinput1:1723
--- re: ^(a){1,2}
--- s eval: "aab  "



=== TEST 50: testinput1:1726
--- re: ^(a){1,3}
--- s eval: "bcd"



