# vim:set ft= ts=4 sw=4 et fdm=marker:

use t::SRegex 'no_plan';

run_tests();

__DATA__

=== TEST 1: testinput1:1727
--- re: ^(a){1,3}
--- s eval: "abc"



=== TEST 2: testinput1:1728
--- re: ^(a){1,3}
--- s eval: "aab"



=== TEST 3: testinput1:1729
--- re: ^(a){1,3}
--- s eval: "aaa   "



=== TEST 4: testinput1:1732
--- re: ^(a){1,}
--- s eval: "bcd"



=== TEST 5: testinput1:1733
--- re: ^(a){1,}
--- s eval: "abc"



=== TEST 6: testinput1:1734
--- re: ^(a){1,}
--- s eval: "aab"



=== TEST 7: testinput1:1735
--- re: ^(a){1,}
--- s eval: "aaa"



=== TEST 8: testinput1:1736
--- re: ^(a){1,}
--- s eval: "aaaaaaaa    "



=== TEST 9: testinput1:1739
--- re: .*\.gif
--- s eval: "borfle\nbib.gif\nno"



=== TEST 10: testinput1:1742
--- re: .{0,}\.gif
--- s eval: "borfle\nbib.gif\nno"



=== TEST 11: testinput1:1754
--- re: .*$
--- s eval: "borfle\nbib.gif\nno"



=== TEST 12: testinput1:1766
--- re: .*$
--- s eval: "borfle\nbib.gif\nno\n"



=== TEST 13: testinput1:1778
--- re: (.*X|^B)
--- s eval: "abcde\n1234Xyz"



=== TEST 14: testinput1:1779
--- re: (.*X|^B)
--- s eval: "BarFoo "



=== TEST 15: testinput1:1780
--- re: (.*X|^B)
--- s eval: "*** Failers"



=== TEST 16: testinput1:1781
--- re: (.*X|^B)
--- s eval: "abcde\nBar  "



=== TEST 17: testinput1:1812
--- re: ^.*B
--- s eval: "**** Failers"



=== TEST 18: testinput1:1813
--- re: ^.*B
--- s eval: "abc\nB"



=== TEST 19: testinput1:1831
--- re: ^[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]
--- s eval: "123456654321"



=== TEST 20: testinput1:1834
--- re: ^\d\d\d\d\d\d\d\d\d\d\d\d
--- s eval: "123456654321 "



=== TEST 21: testinput1:1837
--- re: ^[\d][\d][\d][\d][\d][\d][\d][\d][\d][\d][\d][\d]
--- s eval: "123456654321"



=== TEST 22: testinput1:1840
--- re: ^[abc]{12}
--- s eval: "abcabcabcabc"



=== TEST 23: testinput1:1843
--- re: ^[a-c]{12}
--- s eval: "abcabcabcabc"



=== TEST 24: testinput1:1846
--- re: ^(a|b|c){12}
--- s eval: "abcabcabcabc "



=== TEST 25: testinput1:1849
--- re: ^[abcdefghijklmnopqrstuvwxy0123456789]
--- s eval: "n"



=== TEST 26: testinput1:1850
--- re: ^[abcdefghijklmnopqrstuvwxy0123456789]
--- s eval: "*** Failers "



=== TEST 27: testinput1:1851
--- re: ^[abcdefghijklmnopqrstuvwxy0123456789]
--- s eval: "z "



=== TEST 28: testinput1:1854
--- re: abcde{0,0}
--- s eval: "abcd"



=== TEST 29: testinput1:1855
--- re: abcde{0,0}
--- s eval: "*** Failers"



=== TEST 30: testinput1:1856
--- re: abcde{0,0}
--- s eval: "abce  "



=== TEST 31: testinput1:1859
--- re: ab[cd]{0,0}e
--- s eval: "abe"



=== TEST 32: testinput1:1860
--- re: ab[cd]{0,0}e
--- s eval: "*** Failers"



=== TEST 33: testinput1:1861
--- re: ab[cd]{0,0}e
--- s eval: "abcde "



=== TEST 34: testinput1:1864
--- re: ab(c){0,0}d
--- s eval: "abd"



=== TEST 35: testinput1:1865
--- re: ab(c){0,0}d
--- s eval: "*** Failers"



=== TEST 36: testinput1:1866
--- re: ab(c){0,0}d
--- s eval: "abcd   "



=== TEST 37: testinput1:1869
--- re: a(b*)
--- s eval: "a"



=== TEST 38: testinput1:1870
--- re: a(b*)
--- s eval: "ab"



=== TEST 39: testinput1:1871
--- re: a(b*)
--- s eval: "abbbb"



=== TEST 40: testinput1:1872
--- re: a(b*)
--- s eval: "*** Failers"



=== TEST 41: testinput1:1873
--- re: a(b*)
--- s eval: "bbbbb    "



=== TEST 42: testinput1:1876
--- re: ab\d{0}e
--- s eval: "abe"



=== TEST 43: testinput1:1877
--- re: ab\d{0}e
--- s eval: "*** Failers"



=== TEST 44: testinput1:1878
--- re: ab\d{0}e
--- s eval: "ab1e   "



=== TEST 45: testinput1:1881
--- re: "([^\\"]+|\\.)*"
--- s eval: "the \"quick\" brown fox"



=== TEST 46: testinput1:1882
--- re: "([^\\"]+|\\.)*"
--- s eval: "\"the \\\"quick\\\" brown fox\" "



=== TEST 47: testinput1:1885
--- re: .*?
--- s eval: "abc"



=== TEST 48: testinput1:1888
--- re: \b
--- s eval: "abc "



=== TEST 49: testinput1:1894
--- re: 
--- s eval: "abc"



=== TEST 50: testinput1:1897
--- re: <tr([\w\W\s\d][^<>]{0,})><TD([\w\W\s\d][^<>]{0,})>([\d]{0,}\.)(.*)((<BR>([\w\W\s\d][^<>]{0,})|[\s]{0,}))<\/a><\/TD><TD([\w\W\s\d][^<>]{0,})>([\w\W\s\d][^<>]{0,})<\/TD><TD([\w\W\s\d][^<>]{0,})>([\w\W\s\d][^<>]{0,})<\/TD><\/TR>
--- s eval: "<TR BGCOLOR='#DBE9E9'><TD align=left valign=top>43.<a href='joblist.cfm?JobID=94 6735&Keyword='>Word Processor<BR>(N-1286)</a></TD><TD align=left valign=top>Lega lstaff.com</TD><TD align=left valign=top>CA - Statewide</TD></TR>"
--- flags: i



