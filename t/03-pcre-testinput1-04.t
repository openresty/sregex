# vim:set ft= ts=4 sw=4 et fdm=marker:

use t::SRegex 'no_plan';

run_tests();

__DATA__

=== TEST 1: testinput1:199
--- re: ^.+?[0-9][0-9][0-9]$
--- s eval: "x123"



=== TEST 2: testinput1:200
--- re: ^.+?[0-9][0-9][0-9]$
--- s eval: "xx123"



=== TEST 3: testinput1:201
--- re: ^.+?[0-9][0-9][0-9]$
--- s eval: "123456"



=== TEST 4: testinput1:202
--- re: ^.+?[0-9][0-9][0-9]$
--- s eval: "*** Failers"



=== TEST 5: testinput1:203
--- re: ^.+?[0-9][0-9][0-9]$
--- s eval: "123"



=== TEST 6: testinput1:204
--- re: ^.+?[0-9][0-9][0-9]$
--- s eval: "x1234"



=== TEST 7: testinput1:207
--- re: ^([^!]+)!(.+)=apquxz\.ixr\.zzz\.ac\.uk$
--- s eval: "abc!pqr=apquxz.ixr.zzz.ac.uk"



=== TEST 8: testinput1:208
--- re: ^([^!]+)!(.+)=apquxz\.ixr\.zzz\.ac\.uk$
--- s eval: "*** Failers"



=== TEST 9: testinput1:209
--- re: ^([^!]+)!(.+)=apquxz\.ixr\.zzz\.ac\.uk$
--- s eval: "!pqr=apquxz.ixr.zzz.ac.uk"



=== TEST 10: testinput1:210
--- re: ^([^!]+)!(.+)=apquxz\.ixr\.zzz\.ac\.uk$
--- s eval: "abc!=apquxz.ixr.zzz.ac.uk"



=== TEST 11: testinput1:211
--- re: ^([^!]+)!(.+)=apquxz\.ixr\.zzz\.ac\.uk$
--- s eval: "abc!pqr=apquxz:ixr.zzz.ac.uk"



=== TEST 12: testinput1:212
--- re: ^([^!]+)!(.+)=apquxz\.ixr\.zzz\.ac\.uk$
--- s eval: "abc!pqr=apquxz.ixr.zzz.ac.ukk"



=== TEST 13: testinput1:215
--- re: :
--- s eval: "Well, we need a colon: somewhere"



=== TEST 14: testinput1:216
--- re: :
--- s eval: "*** Fail if we don't"



=== TEST 15: testinput1:219
--- re: ([\da-f:]+)$
--- s eval: "0abc"
--- flags: i



=== TEST 16: testinput1:220
--- re: ([\da-f:]+)$
--- s eval: "abc"
--- flags: i



=== TEST 17: testinput1:221
--- re: ([\da-f:]+)$
--- s eval: "fed"
--- flags: i



=== TEST 18: testinput1:222
--- re: ([\da-f:]+)$
--- s eval: "E"
--- flags: i



=== TEST 19: testinput1:223
--- re: ([\da-f:]+)$
--- s eval: "::"
--- flags: i



=== TEST 20: testinput1:224
--- re: ([\da-f:]+)$
--- s eval: "5f03:12C0::932e"
--- flags: i



=== TEST 21: testinput1:225
--- re: ([\da-f:]+)$
--- s eval: "fed def"
--- flags: i



=== TEST 22: testinput1:226
--- re: ([\da-f:]+)$
--- s eval: "Any old stuff"
--- flags: i



=== TEST 23: testinput1:227
--- re: ([\da-f:]+)$
--- s eval: "*** Failers"
--- flags: i



=== TEST 24: testinput1:228
--- re: ([\da-f:]+)$
--- s eval: "0zzz"
--- flags: i



=== TEST 25: testinput1:229
--- re: ([\da-f:]+)$
--- s eval: "gzzz"
--- flags: i



=== TEST 26: testinput1:230
--- re: ([\da-f:]+)$
--- s eval: "fed\x20"
--- flags: i



=== TEST 27: testinput1:231
--- re: ([\da-f:]+)$
--- s eval: "Any old rubbish"
--- flags: i



=== TEST 28: testinput1:234
--- re: ^.*\.(\d{1,3})\.(\d{1,3})\.(\d{1,3})$
--- s eval: ".1.2.3"



=== TEST 29: testinput1:235
--- re: ^.*\.(\d{1,3})\.(\d{1,3})\.(\d{1,3})$
--- s eval: "A.12.123.0"



=== TEST 30: testinput1:236
--- re: ^.*\.(\d{1,3})\.(\d{1,3})\.(\d{1,3})$
--- s eval: "*** Failers"



=== TEST 31: testinput1:237
--- re: ^.*\.(\d{1,3})\.(\d{1,3})\.(\d{1,3})$
--- s eval: ".1.2.3333"



=== TEST 32: testinput1:238
--- re: ^.*\.(\d{1,3})\.(\d{1,3})\.(\d{1,3})$
--- s eval: "1.2.3"



=== TEST 33: testinput1:239
--- re: ^.*\.(\d{1,3})\.(\d{1,3})\.(\d{1,3})$
--- s eval: "1234.2.3"



=== TEST 34: testinput1:242
--- re: ^(\d+)\s+IN\s+SOA\s+(\S+)\s+(\S+)\s*\(\s*$
--- s eval: "1 IN SOA non-sp1 non-sp2("



=== TEST 35: testinput1:243
--- re: ^(\d+)\s+IN\s+SOA\s+(\S+)\s+(\S+)\s*\(\s*$
--- s eval: "1    IN    SOA    non-sp1    non-sp2   ("



=== TEST 36: testinput1:244
--- re: ^(\d+)\s+IN\s+SOA\s+(\S+)\s+(\S+)\s*\(\s*$
--- s eval: "*** Failers"



=== TEST 37: testinput1:245
--- re: ^(\d+)\s+IN\s+SOA\s+(\S+)\s+(\S+)\s*\(\s*$
--- s eval: "1IN SOA non-sp1 non-sp2("



=== TEST 38: testinput1:248
--- re: ^[a-zA-Z\d][a-zA-Z\d\-]*(\.[a-zA-Z\d][a-zA-z\d\-]*)*\.$
--- s eval: "a."



=== TEST 39: testinput1:249
--- re: ^[a-zA-Z\d][a-zA-Z\d\-]*(\.[a-zA-Z\d][a-zA-z\d\-]*)*\.$
--- s eval: "Z."



=== TEST 40: testinput1:250
--- re: ^[a-zA-Z\d][a-zA-Z\d\-]*(\.[a-zA-Z\d][a-zA-z\d\-]*)*\.$
--- s eval: "2."



=== TEST 41: testinput1:251
--- re: ^[a-zA-Z\d][a-zA-Z\d\-]*(\.[a-zA-Z\d][a-zA-z\d\-]*)*\.$
--- s eval: "ab-c.pq-r."



=== TEST 42: testinput1:252
--- re: ^[a-zA-Z\d][a-zA-Z\d\-]*(\.[a-zA-Z\d][a-zA-z\d\-]*)*\.$
--- s eval: "sxk.zzz.ac.uk."



=== TEST 43: testinput1:253
--- re: ^[a-zA-Z\d][a-zA-Z\d\-]*(\.[a-zA-Z\d][a-zA-z\d\-]*)*\.$
--- s eval: "x-.y-."



=== TEST 44: testinput1:254
--- re: ^[a-zA-Z\d][a-zA-Z\d\-]*(\.[a-zA-Z\d][a-zA-z\d\-]*)*\.$
--- s eval: "*** Failers"



=== TEST 45: testinput1:255
--- re: ^[a-zA-Z\d][a-zA-Z\d\-]*(\.[a-zA-Z\d][a-zA-z\d\-]*)*\.$
--- s eval: "-abc.peq."



=== TEST 46: testinput1:258
--- re: ^\*\.[a-z]([a-z\-\d]*[a-z\d]+)?(\.[a-z]([a-z\-\d]*[a-z\d]+)?)*$
--- s eval: "*.a"



=== TEST 47: testinput1:259
--- re: ^\*\.[a-z]([a-z\-\d]*[a-z\d]+)?(\.[a-z]([a-z\-\d]*[a-z\d]+)?)*$
--- s eval: "*.b0-a"



=== TEST 48: testinput1:260
--- re: ^\*\.[a-z]([a-z\-\d]*[a-z\d]+)?(\.[a-z]([a-z\-\d]*[a-z\d]+)?)*$
--- s eval: "*.c3-b.c"



=== TEST 49: testinput1:261
--- re: ^\*\.[a-z]([a-z\-\d]*[a-z\d]+)?(\.[a-z]([a-z\-\d]*[a-z\d]+)?)*$
--- s eval: "*.c-a.b-c"



=== TEST 50: testinput1:262
--- re: ^\*\.[a-z]([a-z\-\d]*[a-z\d]+)?(\.[a-z]([a-z\-\d]*[a-z\d]+)?)*$
--- s eval: "*** Failers"



