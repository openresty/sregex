# vim:set ft= ts=4 sw=4 et fdm=marker:

use t::SRegex 'no_plan';

run_tests();

__DATA__

=== TEST 1: testinput1:6
--- re: the quick brown fox
--- s: the quick brown fox



=== TEST 2: testinput1:7
--- re: the quick brown fox
--- s: The quick brown FOX



=== TEST 3: testinput1:8
--- re: the quick brown fox
--- s: What do you know about the quick brown fox?



=== TEST 4: testinput1:9
--- re: the quick brown fox
--- s: What do you know about THE QUICK BROWN FOX?



=== TEST 5: testinput1:12
--- re: The quick brown fox
--- s: the quick brown fox



=== TEST 6: testinput1:13
--- re: The quick brown fox
--- s: The quick brown FOX



=== TEST 7: testinput1:14
--- re: The quick brown fox
--- s: What do you know about the quick brown fox?



=== TEST 8: testinput1:15
--- re: The quick brown fox
--- s: What do you know about THE QUICK BROWN FOX?



=== TEST 9: testinput1:18
--- re: abcd\t\n\r\f\a\e\071\x3b\$\\\?caxyz
--- s: abcd\t\n\r\f\a\e9;\$\\?caxyz



=== TEST 10: testinput1:21
--- re: a*abc?xyz+pqr{3}ab{2,}xy{4,5}pq{0,6}AB{0,}zz
--- s: abxyzpqrrrabbxyyyypqAzz



=== TEST 11: testinput1:23
--- re: a*abc?xyz+pqr{3}ab{2,}xy{4,5}pq{0,6}AB{0,}zz
--- s: aabxyzpqrrrabbxyyyypqAzz



=== TEST 12: testinput1:24
--- re: a*abc?xyz+pqr{3}ab{2,}xy{4,5}pq{0,6}AB{0,}zz
--- s: aaabxyzpqrrrabbxyyyypqAzz



=== TEST 13: testinput1:25
--- re: a*abc?xyz+pqr{3}ab{2,}xy{4,5}pq{0,6}AB{0,}zz
--- s: aaaabxyzpqrrrabbxyyyypqAzz



=== TEST 14: testinput1:26
--- re: a*abc?xyz+pqr{3}ab{2,}xy{4,5}pq{0,6}AB{0,}zz
--- s: abcxyzpqrrrabbxyyyypqAzz



=== TEST 15: testinput1:27
--- re: a*abc?xyz+pqr{3}ab{2,}xy{4,5}pq{0,6}AB{0,}zz
--- s: aabcxyzpqrrrabbxyyyypqAzz



=== TEST 16: testinput1:28
--- re: a*abc?xyz+pqr{3}ab{2,}xy{4,5}pq{0,6}AB{0,}zz
--- s: aaabcxyzpqrrrabbxyyyypAzz



=== TEST 17: testinput1:29
--- re: a*abc?xyz+pqr{3}ab{2,}xy{4,5}pq{0,6}AB{0,}zz
--- s: aaabcxyzpqrrrabbxyyyypqAzz



=== TEST 18: testinput1:30
--- re: a*abc?xyz+pqr{3}ab{2,}xy{4,5}pq{0,6}AB{0,}zz
--- s: aaabcxyzpqrrrabbxyyyypqqAzz



=== TEST 19: testinput1:31
--- re: a*abc?xyz+pqr{3}ab{2,}xy{4,5}pq{0,6}AB{0,}zz
--- s: aaabcxyzpqrrrabbxyyyypqqqAzz



=== TEST 20: testinput1:32
--- re: a*abc?xyz+pqr{3}ab{2,}xy{4,5}pq{0,6}AB{0,}zz
--- s: aaabcxyzpqrrrabbxyyyypqqqqAzz



=== TEST 21: testinput1:33
--- re: a*abc?xyz+pqr{3}ab{2,}xy{4,5}pq{0,6}AB{0,}zz
--- s: aaabcxyzpqrrrabbxyyyypqqqqqAzz



=== TEST 22: testinput1:34
--- re: a*abc?xyz+pqr{3}ab{2,}xy{4,5}pq{0,6}AB{0,}zz
--- s: aaabcxyzpqrrrabbxyyyypqqqqqqAzz



=== TEST 23: testinput1:35
--- re: a*abc?xyz+pqr{3}ab{2,}xy{4,5}pq{0,6}AB{0,}zz
--- s: aaaabcxyzpqrrrabbxyyyypqAzz



=== TEST 24: testinput1:36
--- re: a*abc?xyz+pqr{3}ab{2,}xy{4,5}pq{0,6}AB{0,}zz
--- s: abxyzzpqrrrabbxyyyypqAzz



=== TEST 25: testinput1:37
--- re: a*abc?xyz+pqr{3}ab{2,}xy{4,5}pq{0,6}AB{0,}zz
--- s: aabxyzzzpqrrrabbxyyyypqAzz



=== TEST 26: testinput1:38
--- re: a*abc?xyz+pqr{3}ab{2,}xy{4,5}pq{0,6}AB{0,}zz
--- s: aaabxyzzzzpqrrrabbxyyyypqAzz



=== TEST 27: testinput1:39
--- re: a*abc?xyz+pqr{3}ab{2,}xy{4,5}pq{0,6}AB{0,}zz
--- s: aaaabxyzzzzpqrrrabbxyyyypqAzz



=== TEST 28: testinput1:40
--- re: a*abc?xyz+pqr{3}ab{2,}xy{4,5}pq{0,6}AB{0,}zz
--- s: abcxyzzpqrrrabbxyyyypqAzz



=== TEST 29: testinput1:41
--- re: a*abc?xyz+pqr{3}ab{2,}xy{4,5}pq{0,6}AB{0,}zz
--- s: aabcxyzzzpqrrrabbxyyyypqAzz



=== TEST 30: testinput1:42
--- re: a*abc?xyz+pqr{3}ab{2,}xy{4,5}pq{0,6}AB{0,}zz
--- s: aaabcxyzzzzpqrrrabbxyyyypqAzz



=== TEST 31: testinput1:43
--- re: a*abc?xyz+pqr{3}ab{2,}xy{4,5}pq{0,6}AB{0,}zz
--- s: aaaabcxyzzzzpqrrrabbxyyyypqAzz



=== TEST 32: testinput1:44
--- re: a*abc?xyz+pqr{3}ab{2,}xy{4,5}pq{0,6}AB{0,}zz
--- s: aaaabcxyzzzzpqrrrabbbxyyyypqAzz



=== TEST 33: testinput1:45
--- re: a*abc?xyz+pqr{3}ab{2,}xy{4,5}pq{0,6}AB{0,}zz
--- s: aaaabcxyzzzzpqrrrabbbxyyyyypqAzz



=== TEST 34: testinput1:46
--- re: a*abc?xyz+pqr{3}ab{2,}xy{4,5}pq{0,6}AB{0,}zz
--- s: aaabcxyzpqrrrabbxyyyypABzz



=== TEST 35: testinput1:47
--- re: a*abc?xyz+pqr{3}ab{2,}xy{4,5}pq{0,6}AB{0,}zz
--- s: aaabcxyzpqrrrabbxyyyypABBzz



=== TEST 36: testinput1:48
--- re: a*abc?xyz+pqr{3}ab{2,}xy{4,5}pq{0,6}AB{0,}zz
--- s: >>>aaabxyzpqrrrabbxyyyypqAzz



=== TEST 37: testinput1:49
--- re: a*abc?xyz+pqr{3}ab{2,}xy{4,5}pq{0,6}AB{0,}zz
--- s: >aaaabxyzpqrrrabbxyyyypqAzz



=== TEST 38: testinput1:50
--- re: a*abc?xyz+pqr{3}ab{2,}xy{4,5}pq{0,6}AB{0,}zz
--- s: >>>>abcxyzpqrrrabbxyyyypqAzz



=== TEST 39: testinput1:51
--- re: a*abc?xyz+pqr{3}ab{2,}xy{4,5}pq{0,6}AB{0,}zz
--- s: *** Failers



=== TEST 40: testinput1:52
--- re: a*abc?xyz+pqr{3}ab{2,}xy{4,5}pq{0,6}AB{0,}zz
--- s: abxyzpqrrabbxyyyypqAzz



=== TEST 41: testinput1:53
--- re: a*abc?xyz+pqr{3}ab{2,}xy{4,5}pq{0,6}AB{0,}zz
--- s: abxyzpqrrrrabbxyyyypqAzz



=== TEST 42: testinput1:54
--- re: a*abc?xyz+pqr{3}ab{2,}xy{4,5}pq{0,6}AB{0,}zz
--- s: abxyzpqrrrabxyyyypqAzz



=== TEST 43: testinput1:55
--- re: a*abc?xyz+pqr{3}ab{2,}xy{4,5}pq{0,6}AB{0,}zz
--- s: aaaabcxyzzzzpqrrrabbbxyyyyyypqAzz



=== TEST 44: testinput1:56
--- re: a*abc?xyz+pqr{3}ab{2,}xy{4,5}pq{0,6}AB{0,}zz
--- s: aaaabcxyzzzzpqrrrabbbxyyypqAzz



=== TEST 45: testinput1:57
--- re: a*abc?xyz+pqr{3}ab{2,}xy{4,5}pq{0,6}AB{0,}zz
--- s: aaabcxyzpqrrrabbxyyyypqqqqqqqAzz



=== TEST 46: testinput1:60
--- re: ^(abc){1,2}zz
--- s: abczz



=== TEST 47: testinput1:61
--- re: ^(abc){1,2}zz
--- s: abcabczz



=== TEST 48: testinput1:62
--- re: ^(abc){1,2}zz
--- s: *** Failers



=== TEST 49: testinput1:63
--- re: ^(abc){1,2}zz
--- s: zz



=== TEST 50: testinput1:64
--- re: ^(abc){1,2}zz
--- s: abcabcabczz



=== TEST 51: testinput1:65
--- re: ^(abc){1,2}zz
--- s: >>abczz



=== TEST 52: testinput1:68
--- re: ^(b+?|a){1,2}?c
--- s: bc



=== TEST 53: testinput1:69
--- re: ^(b+?|a){1,2}?c
--- s: bbc



=== TEST 54: testinput1:70
--- re: ^(b+?|a){1,2}?c
--- s: bbbc



=== TEST 55: testinput1:71
--- re: ^(b+?|a){1,2}?c
--- s: bac



=== TEST 56: testinput1:72
--- re: ^(b+?|a){1,2}?c
--- s: bbac



=== TEST 57: testinput1:73
--- re: ^(b+?|a){1,2}?c
--- s: aac



=== TEST 58: testinput1:74
--- re: ^(b+?|a){1,2}?c
--- s: abbbbbbbbbbbc



=== TEST 59: testinput1:75
--- re: ^(b+?|a){1,2}?c
--- s: bbbbbbbbbbbac



=== TEST 60: testinput1:76
--- re: ^(b+?|a){1,2}?c
--- s: *** Failers



=== TEST 61: testinput1:77
--- re: ^(b+?|a){1,2}?c
--- s: aaac



=== TEST 62: testinput1:78
--- re: ^(b+?|a){1,2}?c
--- s: abbbbbbbbbbbac



=== TEST 63: testinput1:81
--- re: ^(b+|a){1,2}c
--- s: bc



=== TEST 64: testinput1:82
--- re: ^(b+|a){1,2}c
--- s: bbc



=== TEST 65: testinput1:83
--- re: ^(b+|a){1,2}c
--- s: bbbc



=== TEST 66: testinput1:84
--- re: ^(b+|a){1,2}c
--- s: bac



=== TEST 67: testinput1:85
--- re: ^(b+|a){1,2}c
--- s: bbac



=== TEST 68: testinput1:86
--- re: ^(b+|a){1,2}c
--- s: aac



=== TEST 69: testinput1:87
--- re: ^(b+|a){1,2}c
--- s: abbbbbbbbbbbc



=== TEST 70: testinput1:88
--- re: ^(b+|a){1,2}c
--- s: bbbbbbbbbbbac



=== TEST 71: testinput1:89
--- re: ^(b+|a){1,2}c
--- s: *** Failers



=== TEST 72: testinput1:90
--- re: ^(b+|a){1,2}c
--- s: aaac



=== TEST 73: testinput1:91
--- re: ^(b+|a){1,2}c
--- s: abbbbbbbbbbbac



=== TEST 74: testinput1:94
--- re: ^(b+|a){1,2}?bc
--- s: bbc



=== TEST 75: testinput1:97
--- re: ^(b*|ba){1,2}?bc
--- s: babc



=== TEST 76: testinput1:98
--- re: ^(b*|ba){1,2}?bc
--- s: bbabc



=== TEST 77: testinput1:99
--- re: ^(b*|ba){1,2}?bc
--- s: bababc



=== TEST 78: testinput1:100
--- re: ^(b*|ba){1,2}?bc
--- s: *** Failers



=== TEST 79: testinput1:101
--- re: ^(b*|ba){1,2}?bc
--- s: bababbc



=== TEST 80: testinput1:102
--- re: ^(b*|ba){1,2}?bc
--- s: babababc



=== TEST 81: testinput1:105
--- re: ^(ba|b*){1,2}?bc
--- s: babc



=== TEST 82: testinput1:106
--- re: ^(ba|b*){1,2}?bc
--- s: bbabc



=== TEST 83: testinput1:107
--- re: ^(ba|b*){1,2}?bc
--- s: bababc



=== TEST 84: testinput1:108
--- re: ^(ba|b*){1,2}?bc
--- s: *** Failers



=== TEST 85: testinput1:109
--- re: ^(ba|b*){1,2}?bc
--- s: bababbc



=== TEST 86: testinput1:110
--- re: ^(ba|b*){1,2}?bc
--- s: babababc



=== TEST 87: testinput1:113
--- re: ^\ca\cA\c[\c{\c:
--- s: \x01\x01\e;z



=== TEST 88: testinput1:116
--- re: ^[ab\]cde]
--- s: athing



=== TEST 89: testinput1:117
--- re: ^[ab\]cde]
--- s: bthing



=== TEST 90: testinput1:118
--- re: ^[ab\]cde]
--- s: ]thing



=== TEST 91: testinput1:119
--- re: ^[ab\]cde]
--- s: cthing



=== TEST 92: testinput1:120
--- re: ^[ab\]cde]
--- s: dthing



=== TEST 93: testinput1:121
--- re: ^[ab\]cde]
--- s: ething



=== TEST 94: testinput1:122
--- re: ^[ab\]cde]
--- s: *** Failers



=== TEST 95: testinput1:123
--- re: ^[ab\]cde]
--- s: fthing



=== TEST 96: testinput1:124
--- re: ^[ab\]cde]
--- s: [thing



=== TEST 97: testinput1:125
--- re: ^[ab\]cde]
--- s: \\thing



=== TEST 98: testinput1:128
--- re: ^[]cde]
--- s: ]thing



=== TEST 99: testinput1:129
--- re: ^[]cde]
--- s: cthing



=== TEST 100: testinput1:130
--- re: ^[]cde]
--- s: dthing



=== TEST 101: testinput1:131
--- re: ^[]cde]
--- s: ething



=== TEST 102: testinput1:132
--- re: ^[]cde]
--- s: *** Failers



=== TEST 103: testinput1:133
--- re: ^[]cde]
--- s: athing



=== TEST 104: testinput1:134
--- re: ^[]cde]
--- s: fthing



=== TEST 105: testinput1:137
--- re: ^[^ab\]cde]
--- s: fthing



=== TEST 106: testinput1:138
--- re: ^[^ab\]cde]
--- s: [thing



=== TEST 107: testinput1:139
--- re: ^[^ab\]cde]
--- s: \\thing



=== TEST 108: testinput1:140
--- re: ^[^ab\]cde]
--- s: *** Failers



=== TEST 109: testinput1:141
--- re: ^[^ab\]cde]
--- s: athing



=== TEST 110: testinput1:142
--- re: ^[^ab\]cde]
--- s: bthing



=== TEST 111: testinput1:143
--- re: ^[^ab\]cde]
--- s: ]thing



=== TEST 112: testinput1:144
--- re: ^[^ab\]cde]
--- s: cthing



=== TEST 113: testinput1:145
--- re: ^[^ab\]cde]
--- s: dthing



=== TEST 114: testinput1:146
--- re: ^[^ab\]cde]
--- s: ething



=== TEST 115: testinput1:149
--- re: ^[^]cde]
--- s: athing



=== TEST 116: testinput1:150
--- re: ^[^]cde]
--- s: fthing



=== TEST 117: testinput1:151
--- re: ^[^]cde]
--- s: *** Failers



=== TEST 118: testinput1:152
--- re: ^[^]cde]
--- s: ]thing



=== TEST 119: testinput1:153
--- re: ^[^]cde]
--- s: cthing



=== TEST 120: testinput1:154
--- re: ^[^]cde]
--- s: dthing



=== TEST 121: testinput1:155
--- re: ^[^]cde]
--- s: ething



=== TEST 122: testinput1:158
--- re: ^\Б
--- s: Б



=== TEST 123: testinput1:161
--- re: ^€
--- s: €



=== TEST 124: testinput1:164
--- re: ^[0-9]+$
--- s: 0



=== TEST 125: testinput1:165
--- re: ^[0-9]+$
--- s: 1



=== TEST 126: testinput1:166
--- re: ^[0-9]+$
--- s: 2



=== TEST 127: testinput1:167
--- re: ^[0-9]+$
--- s: 3



=== TEST 128: testinput1:168
--- re: ^[0-9]+$
--- s: 4



=== TEST 129: testinput1:169
--- re: ^[0-9]+$
--- s: 5



=== TEST 130: testinput1:170
--- re: ^[0-9]+$
--- s: 6



=== TEST 131: testinput1:171
--- re: ^[0-9]+$
--- s: 7



=== TEST 132: testinput1:172
--- re: ^[0-9]+$
--- s: 8



=== TEST 133: testinput1:173
--- re: ^[0-9]+$
--- s: 9



=== TEST 134: testinput1:174
--- re: ^[0-9]+$
--- s: 10



=== TEST 135: testinput1:175
--- re: ^[0-9]+$
--- s: 100



=== TEST 136: testinput1:176
--- re: ^[0-9]+$
--- s: *** Failers



=== TEST 137: testinput1:177
--- re: ^[0-9]+$
--- s: abc



=== TEST 138: testinput1:180
--- re: ^.*nter
--- s: enter



=== TEST 139: testinput1:181
--- re: ^.*nter
--- s: inter



=== TEST 140: testinput1:182
--- re: ^.*nter
--- s: uponter



=== TEST 141: testinput1:185
--- re: ^xxx[0-9]+$
--- s: xxx0



=== TEST 142: testinput1:186
--- re: ^xxx[0-9]+$
--- s: xxx1234



=== TEST 143: testinput1:187
--- re: ^xxx[0-9]+$
--- s: *** Failers



=== TEST 144: testinput1:188
--- re: ^xxx[0-9]+$
--- s: xxx



=== TEST 145: testinput1:191
--- re: ^.+[0-9][0-9][0-9]$
--- s: x123



=== TEST 146: testinput1:192
--- re: ^.+[0-9][0-9][0-9]$
--- s: xx123



=== TEST 147: testinput1:193
--- re: ^.+[0-9][0-9][0-9]$
--- s: 123456



=== TEST 148: testinput1:194
--- re: ^.+[0-9][0-9][0-9]$
--- s: *** Failers



=== TEST 149: testinput1:195
--- re: ^.+[0-9][0-9][0-9]$
--- s: 123



=== TEST 150: testinput1:196
--- re: ^.+[0-9][0-9][0-9]$
--- s: x1234



=== TEST 151: testinput1:199
--- re: ^.+?[0-9][0-9][0-9]$
--- s: x123



=== TEST 152: testinput1:200
--- re: ^.+?[0-9][0-9][0-9]$
--- s: xx123



=== TEST 153: testinput1:201
--- re: ^.+?[0-9][0-9][0-9]$
--- s: 123456



=== TEST 154: testinput1:202
--- re: ^.+?[0-9][0-9][0-9]$
--- s: *** Failers



=== TEST 155: testinput1:203
--- re: ^.+?[0-9][0-9][0-9]$
--- s: 123



=== TEST 156: testinput1:204
--- re: ^.+?[0-9][0-9][0-9]$
--- s: x1234



=== TEST 157: testinput1:207
--- re: ^([^!]+)!(.+)=apquxz\.ixr\.zzz\.ac\.uk$
--- s: abc!pqr=apquxz.ixr.zzz.ac.uk



=== TEST 158: testinput1:208
--- re: ^([^!]+)!(.+)=apquxz\.ixr\.zzz\.ac\.uk$
--- s: *** Failers



=== TEST 159: testinput1:209
--- re: ^([^!]+)!(.+)=apquxz\.ixr\.zzz\.ac\.uk$
--- s: !pqr=apquxz.ixr.zzz.ac.uk



=== TEST 160: testinput1:210
--- re: ^([^!]+)!(.+)=apquxz\.ixr\.zzz\.ac\.uk$
--- s: abc!=apquxz.ixr.zzz.ac.uk



=== TEST 161: testinput1:211
--- re: ^([^!]+)!(.+)=apquxz\.ixr\.zzz\.ac\.uk$
--- s: abc!pqr=apquxz:ixr.zzz.ac.uk



=== TEST 162: testinput1:212
--- re: ^([^!]+)!(.+)=apquxz\.ixr\.zzz\.ac\.uk$
--- s: abc!pqr=apquxz.ixr.zzz.ac.ukk



=== TEST 163: testinput1:215
--- re: :
--- s: Well, we need a colon: somewhere



=== TEST 164: testinput1:216
--- re: :
--- s: *** Fail if we don't



=== TEST 165: testinput1:219
--- re: ([\da-f:]+)$
--- s: 0abc



=== TEST 166: testinput1:220
--- re: ([\da-f:]+)$
--- s: abc



=== TEST 167: testinput1:221
--- re: ([\da-f:]+)$
--- s: fed



=== TEST 168: testinput1:222
--- re: ([\da-f:]+)$
--- s: E



=== TEST 169: testinput1:223
--- re: ([\da-f:]+)$
--- s: ::



=== TEST 170: testinput1:224
--- re: ([\da-f:]+)$
--- s: 5f03:12C0::932e



=== TEST 171: testinput1:225
--- re: ([\da-f:]+)$
--- s: fed def



=== TEST 172: testinput1:226
--- re: ([\da-f:]+)$
--- s: Any old stuff



=== TEST 173: testinput1:227
--- re: ([\da-f:]+)$
--- s: *** Failers



=== TEST 174: testinput1:228
--- re: ([\da-f:]+)$
--- s: 0zzz



=== TEST 175: testinput1:229
--- re: ([\da-f:]+)$
--- s: gzzz



=== TEST 176: testinput1:230
--- re: ([\da-f:]+)$
--- s: fed\x20



=== TEST 177: testinput1:231
--- re: ([\da-f:]+)$
--- s: Any old rubbish



=== TEST 178: testinput1:234
--- re: ^.*\.(\d{1,3})\.(\d{1,3})\.(\d{1,3})$
--- s: .1.2.3



=== TEST 179: testinput1:235
--- re: ^.*\.(\d{1,3})\.(\d{1,3})\.(\d{1,3})$
--- s: A.12.123.0



=== TEST 180: testinput1:236
--- re: ^.*\.(\d{1,3})\.(\d{1,3})\.(\d{1,3})$
--- s: *** Failers



=== TEST 181: testinput1:237
--- re: ^.*\.(\d{1,3})\.(\d{1,3})\.(\d{1,3})$
--- s: .1.2.3333



=== TEST 182: testinput1:238
--- re: ^.*\.(\d{1,3})\.(\d{1,3})\.(\d{1,3})$
--- s: 1.2.3



=== TEST 183: testinput1:239
--- re: ^.*\.(\d{1,3})\.(\d{1,3})\.(\d{1,3})$
--- s: 1234.2.3



=== TEST 184: testinput1:242
--- re: ^(\d+)\s+IN\s+SOA\s+(\S+)\s+(\S+)\s*\(\s*$
--- s: 1 IN SOA non-sp1 non-sp2(



=== TEST 185: testinput1:243
--- re: ^(\d+)\s+IN\s+SOA\s+(\S+)\s+(\S+)\s*\(\s*$
--- s: 1    IN    SOA    non-sp1    non-sp2   (



=== TEST 186: testinput1:244
--- re: ^(\d+)\s+IN\s+SOA\s+(\S+)\s+(\S+)\s*\(\s*$
--- s: *** Failers



=== TEST 187: testinput1:245
--- re: ^(\d+)\s+IN\s+SOA\s+(\S+)\s+(\S+)\s*\(\s*$
--- s: 1IN SOA non-sp1 non-sp2(



=== TEST 188: testinput1:248
--- re: ^[a-zA-Z\d][a-zA-Z\d\-]*(\.[a-zA-Z\d][a-zA-z\d\-]*)*\.$
--- s: a.



=== TEST 189: testinput1:249
--- re: ^[a-zA-Z\d][a-zA-Z\d\-]*(\.[a-zA-Z\d][a-zA-z\d\-]*)*\.$
--- s: Z.



=== TEST 190: testinput1:250
--- re: ^[a-zA-Z\d][a-zA-Z\d\-]*(\.[a-zA-Z\d][a-zA-z\d\-]*)*\.$
--- s: 2.



=== TEST 191: testinput1:251
--- re: ^[a-zA-Z\d][a-zA-Z\d\-]*(\.[a-zA-Z\d][a-zA-z\d\-]*)*\.$
--- s: ab-c.pq-r.



=== TEST 192: testinput1:252
--- re: ^[a-zA-Z\d][a-zA-Z\d\-]*(\.[a-zA-Z\d][a-zA-z\d\-]*)*\.$
--- s: sxk.zzz.ac.uk.



=== TEST 193: testinput1:253
--- re: ^[a-zA-Z\d][a-zA-Z\d\-]*(\.[a-zA-Z\d][a-zA-z\d\-]*)*\.$
--- s: x-.y-.



=== TEST 194: testinput1:254
--- re: ^[a-zA-Z\d][a-zA-Z\d\-]*(\.[a-zA-Z\d][a-zA-z\d\-]*)*\.$
--- s: *** Failers



=== TEST 195: testinput1:255
--- re: ^[a-zA-Z\d][a-zA-Z\d\-]*(\.[a-zA-Z\d][a-zA-z\d\-]*)*\.$
--- s: -abc.peq.



=== TEST 196: testinput1:258
--- re: ^\*\.[a-z]([a-z\-\d]*[a-z\d]+)?(\.[a-z]([a-z\-\d]*[a-z\d]+)?)*$
--- s: *.a



=== TEST 197: testinput1:259
--- re: ^\*\.[a-z]([a-z\-\d]*[a-z\d]+)?(\.[a-z]([a-z\-\d]*[a-z\d]+)?)*$
--- s: *.b0-a



=== TEST 198: testinput1:260
--- re: ^\*\.[a-z]([a-z\-\d]*[a-z\d]+)?(\.[a-z]([a-z\-\d]*[a-z\d]+)?)*$
--- s: *.c3-b.c



=== TEST 199: testinput1:261
--- re: ^\*\.[a-z]([a-z\-\d]*[a-z\d]+)?(\.[a-z]([a-z\-\d]*[a-z\d]+)?)*$
--- s: *.c-a.b-c



=== TEST 200: testinput1:262
--- re: ^\*\.[a-z]([a-z\-\d]*[a-z\d]+)?(\.[a-z]([a-z\-\d]*[a-z\d]+)?)*$
--- s: *** Failers



=== TEST 201: testinput1:263
--- re: ^\*\.[a-z]([a-z\-\d]*[a-z\d]+)?(\.[a-z]([a-z\-\d]*[a-z\d]+)?)*$
--- s: *.0



=== TEST 202: testinput1:264
--- re: ^\*\.[a-z]([a-z\-\d]*[a-z\d]+)?(\.[a-z]([a-z\-\d]*[a-z\d]+)?)*$
--- s: *.a-



=== TEST 203: testinput1:265
--- re: ^\*\.[a-z]([a-z\-\d]*[a-z\d]+)?(\.[a-z]([a-z\-\d]*[a-z\d]+)?)*$
--- s: *.a-b.c-



=== TEST 204: testinput1:266
--- re: ^\*\.[a-z]([a-z\-\d]*[a-z\d]+)?(\.[a-z]([a-z\-\d]*[a-z\d]+)?)*$
--- s: *.c-a.0-c



=== TEST 205: testinput1:278
--- re: ^[\da-f](\.[\da-f])*$
--- s: a.b.c.d



=== TEST 206: testinput1:279
--- re: ^[\da-f](\.[\da-f])*$
--- s: A.B.C.D



=== TEST 207: testinput1:280
--- re: ^[\da-f](\.[\da-f])*$
--- s: a.b.c.1.2.3.C



=== TEST 208: testinput1:283
--- re: ^\".*\"\s*(;.*)?$
--- s: \"1234\"



=== TEST 209: testinput1:284
--- re: ^\".*\"\s*(;.*)?$
--- s: \"abcd\" ;



=== TEST 210: testinput1:285
--- re: ^\".*\"\s*(;.*)?$
--- s: \"\" ; rhubarb



=== TEST 211: testinput1:286
--- re: ^\".*\"\s*(;.*)?$
--- s: *** Failers



=== TEST 212: testinput1:287
--- re: ^\".*\"\s*(;.*)?$
--- s: \"1234\" : things



=== TEST 213: testinput1:290
--- re: ^$
--- s: \



=== TEST 214: testinput1:291
--- re: ^$
--- s: *** Failers



=== TEST 215: testinput1:306
--- re: ^   a\ b[c ]d       $
--- s: a bcd



=== TEST 216: testinput1:307
--- re: ^   a\ b[c ]d       $
--- s: a b d



=== TEST 217: testinput1:308
--- re: ^   a\ b[c ]d       $
--- s: *** Failers



=== TEST 218: testinput1:309
--- re: ^   a\ b[c ]d       $
--- s: abcd



=== TEST 219: testinput1:310
--- re: ^   a\ b[c ]d       $
--- s: ab d



=== TEST 220: testinput1:313
--- re: ^(a(b(c)))(d(e(f)))(h(i(j)))(k(l(m)))$
--- s: abcdefhijklm



=== TEST 221: testinput1:316
--- re: ^(?:a(b(c)))(?:d(e(f)))(?:h(i(j)))(?:k(l(m)))$
--- s: abcdefhijklm



=== TEST 222: testinput1:319
--- re: ^[\w][\W][\s][\S][\d][\D][\b][\n][\c]][\022]
--- s: a+ Z0+\x08\n\x1d\x12



=== TEST 223: testinput1:325
--- re: ^a*\w
--- s: z



=== TEST 224: testinput1:326
--- re: ^a*\w
--- s: az



=== TEST 225: testinput1:327
--- re: ^a*\w
--- s: aaaz



=== TEST 226: testinput1:328
--- re: ^a*\w
--- s: a



=== TEST 227: testinput1:329
--- re: ^a*\w
--- s: aa



=== TEST 228: testinput1:330
--- re: ^a*\w
--- s: aaaa



=== TEST 229: testinput1:331
--- re: ^a*\w
--- s: a+



=== TEST 230: testinput1:332
--- re: ^a*\w
--- s: aa+



=== TEST 231: testinput1:335
--- re: ^a*?\w
--- s: z



=== TEST 232: testinput1:336
--- re: ^a*?\w
--- s: az



=== TEST 233: testinput1:337
--- re: ^a*?\w
--- s: aaaz



=== TEST 234: testinput1:338
--- re: ^a*?\w
--- s: a



=== TEST 235: testinput1:339
--- re: ^a*?\w
--- s: aa



=== TEST 236: testinput1:340
--- re: ^a*?\w
--- s: aaaa



=== TEST 237: testinput1:341
--- re: ^a*?\w
--- s: a+



=== TEST 238: testinput1:342
--- re: ^a*?\w
--- s: aa+



=== TEST 239: testinput1:345
--- re: ^a+\w
--- s: az



=== TEST 240: testinput1:346
--- re: ^a+\w
--- s: aaaz



=== TEST 241: testinput1:347
--- re: ^a+\w
--- s: aa



=== TEST 242: testinput1:348
--- re: ^a+\w
--- s: aaaa



=== TEST 243: testinput1:349
--- re: ^a+\w
--- s: aa+



=== TEST 244: testinput1:352
--- re: ^a+?\w
--- s: az



=== TEST 245: testinput1:353
--- re: ^a+?\w
--- s: aaaz



=== TEST 246: testinput1:354
--- re: ^a+?\w
--- s: aa



=== TEST 247: testinput1:355
--- re: ^a+?\w
--- s: aaaa



=== TEST 248: testinput1:356
--- re: ^a+?\w
--- s: aa+



=== TEST 249: testinput1:359
--- re: ^\d{8}\w{2,}
--- s: 1234567890



=== TEST 250: testinput1:360
--- re: ^\d{8}\w{2,}
--- s: 12345678ab



=== TEST 251: testinput1:361
--- re: ^\d{8}\w{2,}
--- s: 12345678__



=== TEST 252: testinput1:362
--- re: ^\d{8}\w{2,}
--- s: *** Failers



=== TEST 253: testinput1:363
--- re: ^\d{8}\w{2,}
--- s: 1234567



=== TEST 254: testinput1:366
--- re: ^[aeiou\d]{4,5}$
--- s: uoie



=== TEST 255: testinput1:367
--- re: ^[aeiou\d]{4,5}$
--- s: 1234



=== TEST 256: testinput1:368
--- re: ^[aeiou\d]{4,5}$
--- s: 12345



=== TEST 257: testinput1:369
--- re: ^[aeiou\d]{4,5}$
--- s: aaaaa



=== TEST 258: testinput1:370
--- re: ^[aeiou\d]{4,5}$
--- s: *** Failers



=== TEST 259: testinput1:371
--- re: ^[aeiou\d]{4,5}$
--- s: 123456



=== TEST 260: testinput1:374
--- re: ^[aeiou\d]{4,5}?
--- s: uoie



=== TEST 261: testinput1:375
--- re: ^[aeiou\d]{4,5}?
--- s: 1234



=== TEST 262: testinput1:376
--- re: ^[aeiou\d]{4,5}?
--- s: 12345



=== TEST 263: testinput1:377
--- re: ^[aeiou\d]{4,5}?
--- s: aaaaa



=== TEST 264: testinput1:378
--- re: ^[aeiou\d]{4,5}?
--- s: 123456



=== TEST 265: testinput1:397
--- re: ^From +([^ ]+) +[a-zA-Z][a-zA-Z][a-zA-Z] +[a-zA-Z][a-zA-Z][a-zA-Z] +[0-9]?[0-9] +[0-9][0-9]:[0-9][0-9]
--- s: From abcd  Mon Sep 01 12:33:02 1997



=== TEST 266: testinput1:400
--- re: ^From\s+\S+\s+([a-zA-Z]{3}\s+){2}\d{1,2}\s+\d\d:\d\d
--- s: From abcd  Mon Sep 01 12:33:02 1997



=== TEST 267: testinput1:401
--- re: ^From\s+\S+\s+([a-zA-Z]{3}\s+){2}\d{1,2}\s+\d\d:\d\d
--- s: From abcd  Mon Sep  1 12:33:02 1997



=== TEST 268: testinput1:402
--- re: ^From\s+\S+\s+([a-zA-Z]{3}\s+){2}\d{1,2}\s+\d\d:\d\d
--- s: *** Failers



=== TEST 269: testinput1:403
--- re: ^From\s+\S+\s+([a-zA-Z]{3}\s+){2}\d{1,2}\s+\d\d:\d\d
--- s: From abcd  Sep 01 12:33:02 1997



=== TEST 270: testinput1:406
--- re: ^12.34
--- s: 12\n34



=== TEST 271: testinput1:407
--- re: ^12.34
--- s: 12\r34



=== TEST 272: testinput1:439
--- re: ^abcd#rhubarb
--- s: abcd



=== TEST 273: testinput1:458
--- re: ^[ab]{1,3}(ab*|b)
--- s: aabbbbb



=== TEST 274: testinput1:461
--- re: ^[ab]{1,3}?(ab*|b)
--- s: aabbbbb



=== TEST 275: testinput1:464
--- re: ^[ab]{1,3}?(ab*?|b)
--- s: aabbbbb



=== TEST 276: testinput1:467
--- re: ^[ab]{1,3}(ab*?|b)
--- s: aabbbbb



=== TEST 277: testinput1:663
--- re: ^[ab]{1,3}(ab*?|b)
--- s: Alan Other <user\@dom.ain>



=== TEST 278: testinput1:664
--- re: ^[ab]{1,3}(ab*?|b)
--- s: <user\@dom.ain>



=== TEST 279: testinput1:665
--- re: ^[ab]{1,3}(ab*?|b)
--- s: user\@dom.ain



=== TEST 280: testinput1:666
--- re: ^[ab]{1,3}(ab*?|b)
--- s: \"A. Other\" <user.1234\@dom.ain> (a comment)



=== TEST 281: testinput1:667
--- re: ^[ab]{1,3}(ab*?|b)
--- s: A. Other <user.1234\@dom.ain> (a comment)



=== TEST 282: testinput1:668
--- re: ^[ab]{1,3}(ab*?|b)
--- s: \"/s=user/ou=host/o=place/prmd=uu.yy/admd= /c=gb/\"\@x400-re.lay



=== TEST 283: testinput1:669
--- re: ^[ab]{1,3}(ab*?|b)
--- s: A missing angle <user\@some.where



=== TEST 284: testinput1:670
--- re: ^[ab]{1,3}(ab*?|b)
--- s: *** Failers



=== TEST 285: testinput1:671
--- re: ^[ab]{1,3}(ab*?|b)
--- s: The quick brown fox



=== TEST 286: testinput1:1270
--- re: abc\x0def\x00pqr\x000xyz\x0000AB
--- s: abc\x0def\x00pqr\x000xyz\x0000AB



=== TEST 287: testinput1:1271
--- re: abc\x0def\x00pqr\x000xyz\x0000AB
--- s: abc456 abc\x0def\x00pqr\x000xyz\x0000ABCDE



=== TEST 288: testinput1:1282
--- re: A\x0{2,3}Z
--- s: The A\x0\x0Z



=== TEST 289: testinput1:1283
--- re: A\x0{2,3}Z
--- s: An A\0\x0\0Z



=== TEST 290: testinput1:1284
--- re: A\x0{2,3}Z
--- s: *** Failers



=== TEST 291: testinput1:1285
--- re: A\x0{2,3}Z
--- s: A\0Z



=== TEST 292: testinput1:1286
--- re: A\x0{2,3}Z
--- s: A\0\x0\0\x0Z



=== TEST 293: testinput1:1295
--- re: ^\s
--- s: \040abc



=== TEST 294: testinput1:1296
--- re: ^\s
--- s: \x0cabc



=== TEST 295: testinput1:1297
--- re: ^\s
--- s: \nabc



=== TEST 296: testinput1:1298
--- re: ^\s
--- s: \rabc



=== TEST 297: testinput1:1299
--- re: ^\s
--- s: \tabc



=== TEST 298: testinput1:1300
--- re: ^\s
--- s: *** Failers



=== TEST 299: testinput1:1301
--- re: ^\s
--- s: abc



=== TEST 300: testinput1:1304
--- re: ^\s
--- s:   c/x



=== TEST 301: testinput1:1346
--- re: ab{1,3}bc
--- s: abbbbc



=== TEST 302: testinput1:1347
--- re: ab{1,3}bc
--- s: abbbc



=== TEST 303: testinput1:1348
--- re: ab{1,3}bc
--- s: abbc



=== TEST 304: testinput1:1349
--- re: ab{1,3}bc
--- s: *** Failers



=== TEST 305: testinput1:1350
--- re: ab{1,3}bc
--- s: abc



=== TEST 306: testinput1:1351
--- re: ab{1,3}bc
--- s: abbbbbc



=== TEST 307: testinput1:1354
--- re: ([^.]*)\.([^:]*):[T ]+(.*)
--- s: track1.title:TBlah blah blah



=== TEST 308: testinput1:1360
--- re: ([^.]*)\.([^:]*):[t ]+(.*)
--- s: track1.title:TBlah blah blah



=== TEST 309: testinput1:1363
--- re: ^[W-c]+$
--- s: WXY_^abc



=== TEST 310: testinput1:1364
--- re: ^[W-c]+$
--- s: *** Failers



=== TEST 311: testinput1:1365
--- re: ^[W-c]+$
--- s: wxy



=== TEST 312: testinput1:1369
--- re: ^[W-c]+$
--- s: wxy_^ABC



=== TEST 313: testinput1:1372
--- re: ^[\x3f-\x5F]+$
--- s: WXY_^abc



=== TEST 314: testinput1:1373
--- re: ^[\x3f-\x5F]+$
--- s: wxy_^ABC



=== TEST 315: testinput1:1376
--- re: ^abc$
--- s: abc



=== TEST 316: testinput1:1377
--- re: ^abc$
--- s: qqq\nabc



=== TEST 317: testinput1:1378
--- re: ^abc$
--- s: abc\nzzz



=== TEST 318: testinput1:1379
--- re: ^abc$
--- s: qqq\nabc\nzzz



=== TEST 319: testinput1:1383
--- re: ^abc$
--- s: *** Failers



=== TEST 320: testinput1:1404
--- re: (?:b)|(?::+)
--- s: b::c



=== TEST 321: testinput1:1405
--- re: (?:b)|(?::+)
--- s: c::b



=== TEST 322: testinput1:1408
--- re: [-az]+
--- s: az-



=== TEST 323: testinput1:1409
--- re: [-az]+
--- s: *** Failers



=== TEST 324: testinput1:1410
--- re: [-az]+
--- s: b



=== TEST 325: testinput1:1413
--- re: [az-]+
--- s: za-



=== TEST 326: testinput1:1414
--- re: [az-]+
--- s: *** Failers



=== TEST 327: testinput1:1415
--- re: [az-]+
--- s: b



=== TEST 328: testinput1:1418
--- re: [a\-z]+
--- s: a-z



=== TEST 329: testinput1:1419
--- re: [a\-z]+
--- s: *** Failers



=== TEST 330: testinput1:1420
--- re: [a\-z]+
--- s: b



=== TEST 331: testinput1:1423
--- re: [a-z]+
--- s: abcdxyz



=== TEST 332: testinput1:1426
--- re: [\d-]+
--- s: 12-34



=== TEST 333: testinput1:1427
--- re: [\d-]+
--- s: *** Failers



=== TEST 334: testinput1:1428
--- re: [\d-]+
--- s: aaa



=== TEST 335: testinput1:1431
--- re: [\d-z]+
--- s: 12-34z



=== TEST 336: testinput1:1432
--- re: [\d-z]+
--- s: *** Failers



=== TEST 337: testinput1:1433
--- re: [\d-z]+
--- s: aaa



=== TEST 338: testinput1:1436
--- re: \x5c
--- s: \\



=== TEST 339: testinput1:1439
--- re: \x20Z
--- s: the Zoo



=== TEST 340: testinput1:1440
--- re: \x20Z
--- s: *** Failers



=== TEST 341: testinput1:1441
--- re: \x20Z
--- s: Zulu



=== TEST 342: testinput1:1449
--- re: ab{3cd
--- s: ab{3cd



=== TEST 343: testinput1:1452
--- re: ab{3,cd
--- s: ab{3,cd



=== TEST 344: testinput1:1455
--- re: ab{3,4a}cd
--- s: ab{3,4a}cd



=== TEST 345: testinput1:1458
--- re: {4,5a}bc
--- s: {4,5a}bc



=== TEST 346: testinput1:1461
--- re: abc$
--- s: abc



=== TEST 347: testinput1:1462
--- re: abc$
--- s: abc\n



=== TEST 348: testinput1:1463
--- re: abc$
--- s: *** Failers



=== TEST 349: testinput1:1464
--- re: abc$
--- s: abc\ndef



=== TEST 350: testinput1:1502
--- re: ab\idef
--- s: abidef



=== TEST 351: testinput1:1505
--- re: a{0}bc
--- s: bc



=== TEST 352: testinput1:1508
--- re: (a|(bc)){0,0}?xyz
--- s: xyz



=== TEST 353: testinput1:1523
--- re: ^([^a])([^\b])([^c]*)([^d]{3,4})
--- s: baNOTccccd



=== TEST 354: testinput1:1524
--- re: ^([^a])([^\b])([^c]*)([^d]{3,4})
--- s: baNOTcccd



=== TEST 355: testinput1:1525
--- re: ^([^a])([^\b])([^c]*)([^d]{3,4})
--- s: baNOTccd



=== TEST 356: testinput1:1526
--- re: ^([^a])([^\b])([^c]*)([^d]{3,4})
--- s: bacccd



=== TEST 357: testinput1:1527
--- re: ^([^a])([^\b])([^c]*)([^d]{3,4})
--- s: *** Failers



=== TEST 358: testinput1:1528
--- re: ^([^a])([^\b])([^c]*)([^d]{3,4})
--- s: anything



=== TEST 359: testinput1:1529
--- re: ^([^a])([^\b])([^c]*)([^d]{3,4})
--- s: b\bc   



=== TEST 360: testinput1:1530
--- re: ^([^a])([^\b])([^c]*)([^d]{3,4})
--- s: baccd



=== TEST 361: testinput1:1533
--- re: [^a]
--- s: Abc



=== TEST 362: testinput1:1536
--- re: [^a]
--- s: Abc 



=== TEST 363: testinput1:1539
--- re: [^a]+
--- s: AAAaAbc



=== TEST 364: testinput1:1542
--- re: [^a]+
--- s: AAAaAbc 



=== TEST 365: testinput1:1545
--- re: [^a]+
--- s: bbb\nccc



=== TEST 366: testinput1:1548
--- re: [^k]$
--- s: abc



=== TEST 367: testinput1:1549
--- re: [^k]$
--- s: *** Failers



=== TEST 368: testinput1:1550
--- re: [^k]$
--- s: abk   



=== TEST 369: testinput1:1553
--- re: [^k]{2,3}$
--- s: abc



=== TEST 370: testinput1:1554
--- re: [^k]{2,3}$
--- s: kbc



=== TEST 371: testinput1:1555
--- re: [^k]{2,3}$
--- s: kabc 



=== TEST 372: testinput1:1556
--- re: [^k]{2,3}$
--- s: *** Failers



=== TEST 373: testinput1:1557
--- re: [^k]{2,3}$
--- s: abk



=== TEST 374: testinput1:1558
--- re: [^k]{2,3}$
--- s: akb



=== TEST 375: testinput1:1559
--- re: [^k]{2,3}$
--- s: akk 



=== TEST 376: testinput1:1562
--- re: ^\d{8,}\@.+[^k]$
--- s: 12345678\@a.b.c.d



=== TEST 377: testinput1:1563
--- re: ^\d{8,}\@.+[^k]$
--- s: 123456789\@x.y.z



=== TEST 378: testinput1:1564
--- re: ^\d{8,}\@.+[^k]$
--- s: *** Failers



=== TEST 379: testinput1:1565
--- re: ^\d{8,}\@.+[^k]$
--- s: 12345678\@x.y.uk



=== TEST 380: testinput1:1566
--- re: ^\d{8,}\@.+[^k]$
--- s: 1234567\@a.b.c.d       



=== TEST 381: testinput1:1575
--- re: [^a]
--- s: aaaabcd



=== TEST 382: testinput1:1576
--- re: [^a]
--- s: aaAabcd 



=== TEST 383: testinput1:1583
--- re: [^az]
--- s: aaaabcd



=== TEST 384: testinput1:1584
--- re: [^az]
--- s: aaAabcd 



=== TEST 385: testinput1:1594
--- re: P[^*]TAIRE[^*]{1,6}?LL
--- s: xxxxxxxxxxxPSTAIREISLLxxxxxxxxx



=== TEST 386: testinput1:1597
--- re: P[^*]TAIRE[^*]{1,}?LL
--- s: xxxxxxxxxxxPSTAIREISLLxxxxxxxxx



=== TEST 387: testinput1:1600
--- re: (\.\d\d[1-9]?)\d+
--- s: 1.230003938



=== TEST 388: testinput1:1601
--- re: (\.\d\d[1-9]?)\d+
--- s: 1.875000282   



=== TEST 389: testinput1:1602
--- re: (\.\d\d[1-9]?)\d+
--- s: 1.235  



=== TEST 390: testinput1:1614
--- re: \b(foo)\s+(\w+)
--- s: Food is on the foo table



=== TEST 391: testinput1:1617
--- re: foo(.*)bar
--- s: The food is under the bar in the barn.



=== TEST 392: testinput1:1620
--- re: foo(.*?)bar
--- s: The food is under the bar in the barn.



=== TEST 393: testinput1:1623
--- re: (.*)(\d*)
--- s: I have 2 numbers: 53147



=== TEST 394: testinput1:1626
--- re: (.*)(\d+)
--- s: I have 2 numbers: 53147



=== TEST 395: testinput1:1629
--- re: (.*?)(\d*)
--- s: I have 2 numbers: 53147



=== TEST 396: testinput1:1632
--- re: (.*?)(\d+)
--- s: I have 2 numbers: 53147



=== TEST 397: testinput1:1635
--- re: (.*)(\d+)$
--- s: I have 2 numbers: 53147



=== TEST 398: testinput1:1638
--- re: (.*?)(\d+)$
--- s: I have 2 numbers: 53147



=== TEST 399: testinput1:1641
--- re: (.*)\b(\d+)$
--- s: I have 2 numbers: 53147



=== TEST 400: testinput1:1644
--- re: (.*\D)(\d+)$
--- s: I have 2 numbers: 53147



=== TEST 401: testinput1:1655
--- re: ^[W-]46]
--- s: W46]789 



=== TEST 402: testinput1:1656
--- re: ^[W-]46]
--- s: -46]789



=== TEST 403: testinput1:1657
--- re: ^[W-]46]
--- s: *** Failers



=== TEST 404: testinput1:1658
--- re: ^[W-]46]
--- s: Wall



=== TEST 405: testinput1:1659
--- re: ^[W-]46]
--- s: Zebra



=== TEST 406: testinput1:1660
--- re: ^[W-]46]
--- s: 42



=== TEST 407: testinput1:1661
--- re: ^[W-]46]
--- s: [abcd] 



=== TEST 408: testinput1:1662
--- re: ^[W-]46]
--- s: ]abcd[



=== TEST 409: testinput1:1665
--- re: ^[W-\]46]
--- s: W46]789 



=== TEST 410: testinput1:1666
--- re: ^[W-\]46]
--- s: Wall



=== TEST 411: testinput1:1667
--- re: ^[W-\]46]
--- s: Zebra



=== TEST 412: testinput1:1668
--- re: ^[W-\]46]
--- s: Xylophone  



=== TEST 413: testinput1:1669
--- re: ^[W-\]46]
--- s: 42



=== TEST 414: testinput1:1670
--- re: ^[W-\]46]
--- s: [abcd] 



=== TEST 415: testinput1:1671
--- re: ^[W-\]46]
--- s: ]abcd[



=== TEST 416: testinput1:1672
--- re: ^[W-\]46]
--- s: \\backslash 



=== TEST 417: testinput1:1673
--- re: ^[W-\]46]
--- s: *** Failers



=== TEST 418: testinput1:1674
--- re: ^[W-\]46]
--- s: -46]789



=== TEST 419: testinput1:1675
--- re: ^[W-\]46]
--- s: well



=== TEST 420: testinput1:1678
--- re: \d\d\/\d\d\/\d\d\d\d
--- s: 01/01/2000



=== TEST 421: testinput1:1681
--- re: word (?:[a-zA-Z0-9]+ ){0,10}otherword
--- s: word cat dog elephant mussel cow horse canary baboon snake shark otherword



=== TEST 422: testinput1:1682
--- re: word (?:[a-zA-Z0-9]+ ){0,10}otherword
--- s: word cat dog elephant mussel cow horse canary baboon snake shark



=== TEST 423: testinput1:1685
--- re: word (?:[a-zA-Z0-9]+ ){0,300}otherword
--- s: word cat dog elephant mussel cow horse canary baboon snake shark the quick brown fox and the lazy dog and several other words getting close to thirty by now I hope



=== TEST 424: testinput1:1688
--- re: ^(a){0,0}
--- s: bcd



=== TEST 425: testinput1:1689
--- re: ^(a){0,0}
--- s: abc



=== TEST 426: testinput1:1690
--- re: ^(a){0,0}
--- s: aab     



=== TEST 427: testinput1:1693
--- re: ^(a){0,1}
--- s: bcd



=== TEST 428: testinput1:1694
--- re: ^(a){0,1}
--- s: abc



=== TEST 429: testinput1:1695
--- re: ^(a){0,1}
--- s: aab  



=== TEST 430: testinput1:1698
--- re: ^(a){0,2}
--- s: bcd



=== TEST 431: testinput1:1699
--- re: ^(a){0,2}
--- s: abc



=== TEST 432: testinput1:1700
--- re: ^(a){0,2}
--- s: aab  



=== TEST 433: testinput1:1703
--- re: ^(a){0,3}
--- s: bcd



=== TEST 434: testinput1:1704
--- re: ^(a){0,3}
--- s: abc



=== TEST 435: testinput1:1705
--- re: ^(a){0,3}
--- s: aab



=== TEST 436: testinput1:1706
--- re: ^(a){0,3}
--- s: aaa   



=== TEST 437: testinput1:1709
--- re: ^(a){0,}
--- s: bcd



=== TEST 438: testinput1:1710
--- re: ^(a){0,}
--- s: abc



=== TEST 439: testinput1:1711
--- re: ^(a){0,}
--- s: aab



=== TEST 440: testinput1:1712
--- re: ^(a){0,}
--- s: aaa



=== TEST 441: testinput1:1713
--- re: ^(a){0,}
--- s: aaaaaaaa    



=== TEST 442: testinput1:1716
--- re: ^(a){1,1}
--- s: bcd



=== TEST 443: testinput1:1717
--- re: ^(a){1,1}
--- s: abc



=== TEST 444: testinput1:1718
--- re: ^(a){1,1}
--- s: aab  



=== TEST 445: testinput1:1721
--- re: ^(a){1,2}
--- s: bcd



=== TEST 446: testinput1:1722
--- re: ^(a){1,2}
--- s: abc



=== TEST 447: testinput1:1723
--- re: ^(a){1,2}
--- s: aab  



=== TEST 448: testinput1:1726
--- re: ^(a){1,3}
--- s: bcd



=== TEST 449: testinput1:1727
--- re: ^(a){1,3}
--- s: abc



=== TEST 450: testinput1:1728
--- re: ^(a){1,3}
--- s: aab



=== TEST 451: testinput1:1729
--- re: ^(a){1,3}
--- s: aaa   



=== TEST 452: testinput1:1732
--- re: ^(a){1,}
--- s: bcd



=== TEST 453: testinput1:1733
--- re: ^(a){1,}
--- s: abc



=== TEST 454: testinput1:1734
--- re: ^(a){1,}
--- s: aab



=== TEST 455: testinput1:1735
--- re: ^(a){1,}
--- s: aaa



=== TEST 456: testinput1:1736
--- re: ^(a){1,}
--- s: aaaaaaaa    



=== TEST 457: testinput1:1739
--- re: .*\.gif
--- s: borfle\nbib.gif\nno



=== TEST 458: testinput1:1742
--- re: .{0,}\.gif
--- s: borfle\nbib.gif\nno



=== TEST 459: testinput1:1754
--- re: .*$
--- s: borfle\nbib.gif\nno



=== TEST 460: testinput1:1766
--- re: .*$
--- s: borfle\nbib.gif\nno\n



=== TEST 461: testinput1:1778
--- re: (.*X|^B)
--- s: abcde\n1234Xyz



=== TEST 462: testinput1:1779
--- re: (.*X|^B)
--- s: BarFoo 



=== TEST 463: testinput1:1780
--- re: (.*X|^B)
--- s: *** Failers



=== TEST 464: testinput1:1781
--- re: (.*X|^B)
--- s: abcde\nBar  



=== TEST 465: testinput1:1812
--- re: ^.*B
--- s: **** Failers



=== TEST 466: testinput1:1813
--- re: ^.*B
--- s: abc\nB



=== TEST 467: testinput1:1831
--- re: ^[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]
--- s: 123456654321



=== TEST 468: testinput1:1834
--- re: ^\d\d\d\d\d\d\d\d\d\d\d\d
--- s: 123456654321 



=== TEST 469: testinput1:1837
--- re: ^[\d][\d][\d][\d][\d][\d][\d][\d][\d][\d][\d][\d]
--- s: 123456654321



=== TEST 470: testinput1:1840
--- re: ^[abc]{12}
--- s: abcabcabcabc



=== TEST 471: testinput1:1843
--- re: ^[a-c]{12}
--- s: abcabcabcabc



=== TEST 472: testinput1:1846
--- re: ^(a|b|c){12}
--- s: abcabcabcabc 



=== TEST 473: testinput1:1849
--- re: ^[abcdefghijklmnopqrstuvwxy0123456789]
--- s: n



=== TEST 474: testinput1:1850
--- re: ^[abcdefghijklmnopqrstuvwxy0123456789]
--- s: *** Failers 



=== TEST 475: testinput1:1851
--- re: ^[abcdefghijklmnopqrstuvwxy0123456789]
--- s: z 



=== TEST 476: testinput1:1854
--- re: abcde{0,0}
--- s: abcd



=== TEST 477: testinput1:1855
--- re: abcde{0,0}
--- s: *** Failers



=== TEST 478: testinput1:1856
--- re: abcde{0,0}
--- s: abce  



=== TEST 479: testinput1:1859
--- re: ab[cd]{0,0}e
--- s: abe



=== TEST 480: testinput1:1860
--- re: ab[cd]{0,0}e
--- s: *** Failers



=== TEST 481: testinput1:1861
--- re: ab[cd]{0,0}e
--- s: abcde 



=== TEST 482: testinput1:1864
--- re: ab(c){0,0}d
--- s: abd



=== TEST 483: testinput1:1865
--- re: ab(c){0,0}d
--- s: *** Failers



=== TEST 484: testinput1:1866
--- re: ab(c){0,0}d
--- s: abcd   



=== TEST 485: testinput1:1869
--- re: a(b*)
--- s: a



=== TEST 486: testinput1:1870
--- re: a(b*)
--- s: ab



=== TEST 487: testinput1:1871
--- re: a(b*)
--- s: abbbb



=== TEST 488: testinput1:1872
--- re: a(b*)
--- s: *** Failers



=== TEST 489: testinput1:1873
--- re: a(b*)
--- s: bbbbb    



=== TEST 490: testinput1:1876
--- re: ab\d{0}e
--- s: abe



=== TEST 491: testinput1:1877
--- re: ab\d{0}e
--- s: *** Failers



=== TEST 492: testinput1:1878
--- re: ab\d{0}e
--- s: ab1e   



=== TEST 493: testinput1:1881
--- re: "([^\\"]+|\\.)*"
--- s: the \"quick\" brown fox



=== TEST 494: testinput1:1882
--- re: "([^\\"]+|\\.)*"
--- s: \"the \\\"quick\\\" brown fox\" 



=== TEST 495: testinput1:1885
--- re: .*?
--- s: abc



=== TEST 496: testinput1:1888
--- re: \b
--- s: abc 



=== TEST 497: testinput1:1894
--- re: 
--- s: abc



=== TEST 498: testinput1:1897
--- re: <tr([\w\W\s\d][^<>]{0,})><TD([\w\W\s\d][^<>]{0,})>([\d]{0,}\.)(.*)((<BR>([\w\W\s\d][^<>]{0,})|[\s]{0,}))<\/a><\/TD><TD([\w\W\s\d][^<>]{0,})>([\w\W\s\d][^<>]{0,})<\/TD><TD([\w\W\s\d][^<>]{0,})>([\w\W\s\d][^<>]{0,})<\/TD><\/TR>
--- s: <TR BGCOLOR='#DBE9E9'><TD align=left valign=top>43.<a href='joblist.cfm?JobID=94 6735&Keyword='>Word Processor<BR>(N-1286)</a></TD><TD align=left valign=top>Lega lstaff.com</TD><TD align=left valign=top>CA - Statewide</TD></TR>



=== TEST 499: testinput1:1900
--- re: a[^a]b
--- s: acb



=== TEST 500: testinput1:1901
--- re: a[^a]b
--- s: a\nb



=== TEST 501: testinput1:1904
--- re: a.b
--- s: acb



=== TEST 502: testinput1:1905
--- re: a.b
--- s: *** Failers 



=== TEST 503: testinput1:1906
--- re: a.b
--- s: a\nb   



=== TEST 504: testinput1:1910
--- re: a[^a]b
--- s: a\nb  



=== TEST 505: testinput1:1914
--- re: a.b
--- s: a\nb  



=== TEST 506: testinput1:1919
--- re: ^(b+?|a){1,2}?c
--- s: bbbac



=== TEST 507: testinput1:1920
--- re: ^(b+?|a){1,2}?c
--- s: bbbbac



=== TEST 508: testinput1:1921
--- re: ^(b+?|a){1,2}?c
--- s: bbbbbac 



=== TEST 509: testinput1:1924
--- re: ^(b+|a){1,2}?c
--- s: bac



=== TEST 510: testinput1:1925
--- re: ^(b+|a){1,2}?c
--- s: bbac



=== TEST 511: testinput1:1926
--- re: ^(b+|a){1,2}?c
--- s: bbbac



=== TEST 512: testinput1:1927
--- re: ^(b+|a){1,2}?c
--- s: bbbbac



=== TEST 513: testinput1:1928
--- re: ^(b+|a){1,2}?c
--- s: bbbbbac 



=== TEST 514: testinput1:1935
--- re: \x0{ab}
--- s: \0{ab} 



=== TEST 515: testinput1:1938
--- re: (A|B)*?CD
--- s: CD 



=== TEST 516: testinput1:1941
--- re: (A|B)*CD
--- s: CD 



=== TEST 517: testinput1:1972
--- re: \Aabc\z
--- s: abc



=== TEST 518: testinput1:1973
--- re: \Aabc\z
--- s: *** Failers



=== TEST 519: testinput1:1974
--- re: \Aabc\z
--- s: abc\n   



=== TEST 520: testinput1:1975
--- re: \Aabc\z
--- s: qqq\nabc



=== TEST 521: testinput1:1976
--- re: \Aabc\z
--- s: abc\nzzz



=== TEST 522: testinput1:1977
--- re: \Aabc\z
--- s: qqq\nabc\nzzz



=== TEST 523: testinput1:1980
--- re: \Aabc\z
--- s: /this/is/a/very/long/line/in/deed/with/very/many/slashes/in/it/you/see/



=== TEST 524: testinput1:1983
--- re: \Aabc\z
--- s: /this/is/a/very/long/line/in/deed/with/very/many/slashes/in/and/foo



=== TEST 525: testinput1:1997
--- re: (\d+)(\w)
--- s: 12345a



=== TEST 526: testinput1:1998
--- re: (\d+)(\w)
--- s: 12345+ 



=== TEST 527: testinput1:2210
--- re: (abc|)+
--- s: abc
--- cap: (0, 3) (0, 3)



=== TEST 528: testinput1:2211
--- re: (abc|)+
--- s: abcabc
--- cap: (0, 6) (3, 6)



=== TEST 529: testinput1:2212
--- re: (abc|)+
--- s: abcabcabc
--- cap: (0, 9) (6, 9)



=== TEST 530: testinput1:2213
--- re: (abc|)+
--- s: xyz      



=== TEST 531: testinput1:2216
--- re: ([a]*)*
--- s: a
--- cap: (0, 1) (0, 1)



=== TEST 532: testinput1:2217
--- re: ([a]*)*
--- s: aaaaa 
--- cap: (0, 5) (0, 5)



=== TEST 533: testinput1:2220
--- re: ([ab]*)*
--- s: a
--- cap: (0, 1) (0, 1)



=== TEST 534: testinput1:2221
--- re: ([ab]*)*
--- s: b
--- cap: (0, 1) (0, 1)



=== TEST 535: testinput1:2222
--- re: ([ab]*)*
--- s: ababab
--- cap: (0, 6) (0, 6)



=== TEST 536: testinput1:2223
--- re: ([ab]*)*
--- s: aaaabcde
--- cap: (0, 5) (0, 5)



=== TEST 537: testinput1:2224
--- re: ([ab]*)*
--- s: bbbb    
--- cap: (0, 4) (0, 4)



=== TEST 538: testinput1:2227
--- re: ([^a]*)*
--- s: b
--- cap: (0, 1) (0, 1)



=== TEST 539: testinput1:2228
--- re: ([^a]*)*
--- s: bbbb
--- cap: (0, 4) (0, 4)



=== TEST 540: testinput1:2229
--- re: ([^a]*)*
--- s: aaa   



=== TEST 541: testinput1:2232
--- re: ([^ab]*)*
--- s: cccc
--- cap: (0, 4) (0, 4)



=== TEST 542: testinput1:2233
--- re: ([^ab]*)*
--- s: abab  



=== TEST 543: testinput1:2236
--- re: ([a]*?)*
--- s: a



=== TEST 544: testinput1:2237
--- re: ([a]*?)*
--- s: aaaa 



=== TEST 545: testinput1:2240
--- re: ([ab]*?)*
--- s: a



=== TEST 546: testinput1:2241
--- re: ([ab]*?)*
--- s: b



=== TEST 547: testinput1:2242
--- re: ([ab]*?)*
--- s: abab



=== TEST 548: testinput1:2243
--- re: ([ab]*?)*
--- s: baba   



=== TEST 549: testinput1:2246
--- re: ([^a]*?)*
--- s: b



=== TEST 550: testinput1:2247
--- re: ([^a]*?)*
--- s: bbbb



=== TEST 551: testinput1:2248
--- re: ([^a]*?)*
--- s: aaa   



=== TEST 552: testinput1:2251
--- re: ([^ab]*?)*
--- s: c



=== TEST 553: testinput1:2252
--- re: ([^ab]*?)*
--- s: cccc



=== TEST 554: testinput1:2253
--- re: ([^ab]*?)*
--- s: baba   



=== TEST 555: testinput1:2378
--- re: abc
--- s: abc



=== TEST 556: testinput1:2379
--- re: abc
--- s: xabcy



=== TEST 557: testinput1:2380
--- re: abc
--- s: ababc



=== TEST 558: testinput1:2381
--- re: abc
--- s: *** Failers



=== TEST 559: testinput1:2382
--- re: abc
--- s: xbc



=== TEST 560: testinput1:2383
--- re: abc
--- s: axc



=== TEST 561: testinput1:2384
--- re: abc
--- s: abx



=== TEST 562: testinput1:2387
--- re: ab*c
--- s: abc



=== TEST 563: testinput1:2390
--- re: ab*bc
--- s: abc



=== TEST 564: testinput1:2391
--- re: ab*bc
--- s: abbc



=== TEST 565: testinput1:2392
--- re: ab*bc
--- s: abbbbc



=== TEST 566: testinput1:2395
--- re: .{1}
--- s: abbbbc



=== TEST 567: testinput1:2398
--- re: .{3,4}
--- s: abbbbc



=== TEST 568: testinput1:2401
--- re: ab{0,}bc
--- s: abbbbc



=== TEST 569: testinput1:2404
--- re: ab+bc
--- s: abbc



=== TEST 570: testinput1:2405
--- re: ab+bc
--- s: *** Failers



=== TEST 571: testinput1:2406
--- re: ab+bc
--- s: abc



=== TEST 572: testinput1:2407
--- re: ab+bc
--- s: abq



=== TEST 573: testinput1:2412
--- re: ab+bc
--- s: abbbbc



=== TEST 574: testinput1:2415
--- re: ab{1,}bc
--- s: abbbbc



=== TEST 575: testinput1:2421
--- re: ab{3,4}bc
--- s: abbbbc



=== TEST 576: testinput1:2424
--- re: ab{4,5}bc
--- s: *** Failers



=== TEST 577: testinput1:2425
--- re: ab{4,5}bc
--- s: abq



=== TEST 578: testinput1:2426
--- re: ab{4,5}bc
--- s: abbbbc



=== TEST 579: testinput1:2429
--- re: ab?bc
--- s: abbc



=== TEST 580: testinput1:2430
--- re: ab?bc
--- s: abc



=== TEST 581: testinput1:2433
--- re: ab{0,1}bc
--- s: abc



=== TEST 582: testinput1:2438
--- re: ab?c
--- s: abc



=== TEST 583: testinput1:2441
--- re: ab{0,1}c
--- s: abc



=== TEST 584: testinput1:2446
--- re: ^abc$
--- s: abbbbc



=== TEST 585: testinput1:2447
--- re: ^abc$
--- s: abcc



=== TEST 586: testinput1:2450
--- re: ^abc
--- s: abcc



=== TEST 587: testinput1:2455
--- re: abc$
--- s: aabc



=== TEST 588: testinput1:2458
--- re: abc$
--- s: aabcd



=== TEST 589: testinput1:2461
--- re: ^
--- s: abc



=== TEST 590: testinput1:2464
--- re: $
--- s: abc



=== TEST 591: testinput1:2467
--- re: a.c
--- s: abc



=== TEST 592: testinput1:2468
--- re: a.c
--- s: axc



=== TEST 593: testinput1:2471
--- re: a.*c
--- s: axyzc



=== TEST 594: testinput1:2474
--- re: a[bc]d
--- s: abd



=== TEST 595: testinput1:2475
--- re: a[bc]d
--- s: *** Failers



=== TEST 596: testinput1:2476
--- re: a[bc]d
--- s: axyzd



=== TEST 597: testinput1:2477
--- re: a[bc]d
--- s: abc



=== TEST 598: testinput1:2480
--- re: a[b-d]e
--- s: ace



=== TEST 599: testinput1:2483
--- re: a[b-d]
--- s: aac



=== TEST 600: testinput1:2486
--- re: a[-b]
--- s: a-



=== TEST 601: testinput1:2489
--- re: a[b-]
--- s: a-



=== TEST 602: testinput1:2492
--- re: a]
--- s: a]



=== TEST 603: testinput1:2495
--- re: a[]]b
--- s: a]b



=== TEST 604: testinput1:2498
--- re: a[^bc]d
--- s: aed



=== TEST 605: testinput1:2499
--- re: a[^bc]d
--- s: *** Failers



=== TEST 606: testinput1:2500
--- re: a[^bc]d
--- s: abd



=== TEST 607: testinput1:2504
--- re: a[^-b]c
--- s: adc



=== TEST 608: testinput1:2507
--- re: a[^]b]c
--- s: adc



=== TEST 609: testinput1:2508
--- re: a[^]b]c
--- s: *** Failers



=== TEST 610: testinput1:2509
--- re: a[^]b]c
--- s: a-c



=== TEST 611: testinput1:2510
--- re: a[^]b]c
--- s: a]c



=== TEST 612: testinput1:2513
--- re: \ba\b
--- s: a-



=== TEST 613: testinput1:2514
--- re: \ba\b
--- s: -a



=== TEST 614: testinput1:2515
--- re: \ba\b
--- s: -a-



=== TEST 615: testinput1:2518
--- re: \by\b
--- s: *** Failers



=== TEST 616: testinput1:2519
--- re: \by\b
--- s: xy



=== TEST 617: testinput1:2520
--- re: \by\b
--- s: yz



=== TEST 618: testinput1:2521
--- re: \by\b
--- s: xyz



=== TEST 619: testinput1:2524
--- re: \Ba\B
--- s: *** Failers



=== TEST 620: testinput1:2525
--- re: \Ba\B
--- s: a-



=== TEST 621: testinput1:2526
--- re: \Ba\B
--- s: -a



=== TEST 622: testinput1:2527
--- re: \Ba\B
--- s: -a-



=== TEST 623: testinput1:2530
--- re: \By\b
--- s: xy



=== TEST 624: testinput1:2533
--- re: \by\B
--- s: yz



=== TEST 625: testinput1:2536
--- re: \By\B
--- s: xyz



=== TEST 626: testinput1:2539
--- re: \w
--- s: a



=== TEST 627: testinput1:2542
--- re: \W
--- s: -



=== TEST 628: testinput1:2543
--- re: \W
--- s: *** Failers



=== TEST 629: testinput1:2545
--- re: \W
--- s: a



=== TEST 630: testinput1:2548
--- re: a\sb
--- s: a b



=== TEST 631: testinput1:2551
--- re: a\Sb
--- s: a-b



=== TEST 632: testinput1:2552
--- re: a\Sb
--- s: *** Failers



=== TEST 633: testinput1:2554
--- re: a\Sb
--- s: a b



=== TEST 634: testinput1:2557
--- re: \d
--- s: 1



=== TEST 635: testinput1:2560
--- re: \D
--- s: -



=== TEST 636: testinput1:2561
--- re: \D
--- s: *** Failers



=== TEST 637: testinput1:2563
--- re: \D
--- s: 1



=== TEST 638: testinput1:2566
--- re: [\w]
--- s: a



=== TEST 639: testinput1:2569
--- re: [\W]
--- s: -



=== TEST 640: testinput1:2570
--- re: [\W]
--- s: *** Failers



=== TEST 641: testinput1:2572
--- re: [\W]
--- s: a



=== TEST 642: testinput1:2575
--- re: a[\s]b
--- s: a b



=== TEST 643: testinput1:2578
--- re: a[\S]b
--- s: a-b



=== TEST 644: testinput1:2579
--- re: a[\S]b
--- s: *** Failers



=== TEST 645: testinput1:2581
--- re: a[\S]b
--- s: a b



=== TEST 646: testinput1:2584
--- re: [\d]
--- s: 1



=== TEST 647: testinput1:2587
--- re: [\D]
--- s: -



=== TEST 648: testinput1:2588
--- re: [\D]
--- s: *** Failers



=== TEST 649: testinput1:2590
--- re: [\D]
--- s: 1



=== TEST 650: testinput1:2593
--- re: ab|cd
--- s: abc



=== TEST 651: testinput1:2594
--- re: ab|cd
--- s: abcd



=== TEST 652: testinput1:2597
--- re: ()ef
--- s: def



=== TEST 653: testinput1:2602
--- re: a\(b
--- s: a(b



=== TEST 654: testinput1:2605
--- re: a\(*b
--- s: ab



=== TEST 655: testinput1:2606
--- re: a\(*b
--- s: a((b



=== TEST 656: testinput1:2609
--- re: a\\b
--- s: a\b



=== TEST 657: testinput1:2612
--- re: ((a))
--- s: abc



=== TEST 658: testinput1:2615
--- re: (a)b(c)
--- s: abc



=== TEST 659: testinput1:2618
--- re: a+b+c
--- s: aabbabc



=== TEST 660: testinput1:2621
--- re: a{1,}b{1,}c
--- s: aabbabc



=== TEST 661: testinput1:2624
--- re: a.+?c
--- s: abcabc



=== TEST 662: testinput1:2627
--- re: (a+|b)*
--- s: ab



=== TEST 663: testinput1:2630
--- re: (a+|b){0,}
--- s: ab



=== TEST 664: testinput1:2633
--- re: (a+|b)+
--- s: ab



=== TEST 665: testinput1:2636
--- re: (a+|b){1,}
--- s: ab



=== TEST 666: testinput1:2639
--- re: (a+|b)?
--- s: ab



=== TEST 667: testinput1:2642
--- re: (a+|b){0,1}
--- s: ab



=== TEST 668: testinput1:2645
--- re: [^ab]*
--- s: cde



=== TEST 669: testinput1:2649
--- re: abc
--- s: b



=== TEST 670: testinput1:2656
--- re: ([abc])*d
--- s: abbbcd



=== TEST 671: testinput1:2659
--- re: ([abc])*bcd
--- s: abcd



=== TEST 672: testinput1:2662
--- re: a|b|c|d|e
--- s: e



=== TEST 673: testinput1:2665
--- re: (a|b|c|d|e)f
--- s: ef



=== TEST 674: testinput1:2668
--- re: abcd*efg
--- s: abcdefg



=== TEST 675: testinput1:2671
--- re: ab*
--- s: xabyabbbz



=== TEST 676: testinput1:2672
--- re: ab*
--- s: xayabbbz



=== TEST 677: testinput1:2675
--- re: (ab|cd)e
--- s: abcde



=== TEST 678: testinput1:2678
--- re: [abhgefdc]ij
--- s: hij



=== TEST 679: testinput1:2683
--- re: (abc|)ef
--- s: abcdef



=== TEST 680: testinput1:2686
--- re: (a|b)c*d
--- s: abcd



=== TEST 681: testinput1:2689
--- re: (ab|ab*)bc
--- s: abc



=== TEST 682: testinput1:2692
--- re: a([bc]*)c*
--- s: abc



=== TEST 683: testinput1:2695
--- re: a([bc]*)(c*d)
--- s: abcd



=== TEST 684: testinput1:2698
--- re: a([bc]+)(c*d)
--- s: abcd



=== TEST 685: testinput1:2701
--- re: a([bc]*)(c+d)
--- s: abcd



=== TEST 686: testinput1:2704
--- re: a[bcd]*dcdcde
--- s: adcdcde



=== TEST 687: testinput1:2707
--- re: a[bcd]+dcdcde
--- s: *** Failers



=== TEST 688: testinput1:2708
--- re: a[bcd]+dcdcde
--- s: abcde



=== TEST 689: testinput1:2709
--- re: a[bcd]+dcdcde
--- s: adcdcde



=== TEST 690: testinput1:2712
--- re: (ab|a)b*c
--- s: abc



=== TEST 691: testinput1:2715
--- re: ((a)(b)c)(d)
--- s: abcd



=== TEST 692: testinput1:2718
--- re: [a-zA-Z_][a-zA-Z0-9_]*
--- s: alpha



=== TEST 693: testinput1:2721
--- re: ^a(bc+|b[eh])g|.h$
--- s: abh



=== TEST 694: testinput1:2724
--- re: (bc+d$|ef*g.|h?i(j|k))
--- s: effgz



=== TEST 695: testinput1:2725
--- re: (bc+d$|ef*g.|h?i(j|k))
--- s: ij



=== TEST 696: testinput1:2726
--- re: (bc+d$|ef*g.|h?i(j|k))
--- s: reffgz



=== TEST 697: testinput1:2727
--- re: (bc+d$|ef*g.|h?i(j|k))
--- s: *** Failers



=== TEST 698: testinput1:2728
--- re: (bc+d$|ef*g.|h?i(j|k))
--- s: effg



=== TEST 699: testinput1:2729
--- re: (bc+d$|ef*g.|h?i(j|k))
--- s: bcdd



=== TEST 700: testinput1:2732
--- re: ((((((((((a))))))))))
--- s: a



=== TEST 701: testinput1:2738
--- re: (((((((((a)))))))))
--- s: a



=== TEST 702: testinput1:2741
--- re: multiple words of text
--- s: *** Failers



=== TEST 703: testinput1:2742
--- re: multiple words of text
--- s: aa



=== TEST 704: testinput1:2743
--- re: multiple words of text
--- s: uh-uh



=== TEST 705: testinput1:2746
--- re: multiple words
--- s: multiple words, yeah



=== TEST 706: testinput1:2749
--- re: (.*)c(.*)
--- s: abcde



=== TEST 707: testinput1:2752
--- re: \((.*), (.*)\)
--- s: (a, b)



=== TEST 708: testinput1:2757
--- re: abcd
--- s: abcd



=== TEST 709: testinput1:2760
--- re: a(bc)d
--- s: abcd



=== TEST 710: testinput1:2763
--- re: a[-]?c
--- s: ac



=== TEST 711: testinput1:2790
--- re: abc
--- s: ABC



=== TEST 712: testinput1:2791
--- re: abc
--- s: XABCY



=== TEST 713: testinput1:2792
--- re: abc
--- s: ABABC



=== TEST 714: testinput1:2794
--- re: abc
--- s: aaxabxbaxbbx



=== TEST 715: testinput1:2795
--- re: abc
--- s: XBC



=== TEST 716: testinput1:2796
--- re: abc
--- s: AXC



=== TEST 717: testinput1:2797
--- re: abc
--- s: ABX



=== TEST 718: testinput1:2800
--- re: ab*c
--- s: ABC



=== TEST 719: testinput1:2803
--- re: ab*bc
--- s: ABC



=== TEST 720: testinput1:2804
--- re: ab*bc
--- s: ABBC



=== TEST 721: testinput1:2807
--- re: ab*?bc
--- s: ABBBBC



=== TEST 722: testinput1:2810
--- re: ab{0,}?bc
--- s: ABBBBC



=== TEST 723: testinput1:2813
--- re: ab+?bc
--- s: ABBC



=== TEST 724: testinput1:2817
--- re: ab+bc
--- s: ABC



=== TEST 725: testinput1:2818
--- re: ab+bc
--- s: ABQ



=== TEST 726: testinput1:2823
--- re: ab+bc
--- s: ABBBBC



=== TEST 727: testinput1:2826
--- re: ab{1,}?bc
--- s: ABBBBC



=== TEST 728: testinput1:2829
--- re: ab{1,3}?bc
--- s: ABBBBC



=== TEST 729: testinput1:2832
--- re: ab{3,4}?bc
--- s: ABBBBC



=== TEST 730: testinput1:2835
--- re: ab{4,5}?bc
--- s: *** Failers



=== TEST 731: testinput1:2836
--- re: ab{4,5}?bc
--- s: ABQ



=== TEST 732: testinput1:2837
--- re: ab{4,5}?bc
--- s: ABBBBC



=== TEST 733: testinput1:2840
--- re: ab??bc
--- s: ABBC



=== TEST 734: testinput1:2841
--- re: ab??bc
--- s: ABC



=== TEST 735: testinput1:2844
--- re: ab{0,1}?bc
--- s: ABC



=== TEST 736: testinput1:2849
--- re: ab??c
--- s: ABC



=== TEST 737: testinput1:2852
--- re: ab{0,1}?c
--- s: ABC



=== TEST 738: testinput1:2855
--- re: ^abc$
--- s: ABC



=== TEST 739: testinput1:2857
--- re: ^abc$
--- s: ABBBBC



=== TEST 740: testinput1:2858
--- re: ^abc$
--- s: ABCC



=== TEST 741: testinput1:2861
--- re: ^abc
--- s: ABCC



=== TEST 742: testinput1:2866
--- re: abc$
--- s: AABC



=== TEST 743: testinput1:2869
--- re: ^
--- s: ABC



=== TEST 744: testinput1:2872
--- re: $
--- s: ABC



=== TEST 745: testinput1:2875
--- re: a.c
--- s: ABC



=== TEST 746: testinput1:2876
--- re: a.c
--- s: AXC



=== TEST 747: testinput1:2879
--- re: a.*?c
--- s: AXYZC



=== TEST 748: testinput1:2882
--- re: a.*c
--- s: *** Failers



=== TEST 749: testinput1:2883
--- re: a.*c
--- s: AABC



=== TEST 750: testinput1:2884
--- re: a.*c
--- s: AXYZD



=== TEST 751: testinput1:2887
--- re: a[bc]d
--- s: ABD



=== TEST 752: testinput1:2890
--- re: a[b-d]e
--- s: ACE



=== TEST 753: testinput1:2891
--- re: a[b-d]e
--- s: *** Failers



=== TEST 754: testinput1:2892
--- re: a[b-d]e
--- s: ABC



=== TEST 755: testinput1:2893
--- re: a[b-d]e
--- s: ABD



=== TEST 756: testinput1:2896
--- re: a[b-d]
--- s: AAC



=== TEST 757: testinput1:2899
--- re: a[-b]
--- s: A-



=== TEST 758: testinput1:2902
--- re: a[b-]
--- s: A-



=== TEST 759: testinput1:2905
--- re: a]
--- s: A]



=== TEST 760: testinput1:2908
--- re: a[]]b
--- s: A]B



=== TEST 761: testinput1:2911
--- re: a[^bc]d
--- s: AED



=== TEST 762: testinput1:2914
--- re: a[^-b]c
--- s: ADC



=== TEST 763: testinput1:2915
--- re: a[^-b]c
--- s: *** Failers



=== TEST 764: testinput1:2916
--- re: a[^-b]c
--- s: ABD



=== TEST 765: testinput1:2917
--- re: a[^-b]c
--- s: A-C



=== TEST 766: testinput1:2920
--- re: a[^]b]c
--- s: ADC



=== TEST 767: testinput1:2923
--- re: ab|cd
--- s: ABC



=== TEST 768: testinput1:2924
--- re: ab|cd
--- s: ABCD



=== TEST 769: testinput1:2927
--- re: ()ef
--- s: DEF



=== TEST 770: testinput1:2930
--- re: $b
--- s: *** Failers



=== TEST 771: testinput1:2931
--- re: $b
--- s: A]C



=== TEST 772: testinput1:2932
--- re: $b
--- s: B



=== TEST 773: testinput1:2935
--- re: a\(b
--- s: A(B



=== TEST 774: testinput1:2938
--- re: a\(*b
--- s: AB



=== TEST 775: testinput1:2939
--- re: a\(*b
--- s: A((B



=== TEST 776: testinput1:2942
--- re: a\\b
--- s: A\B



=== TEST 777: testinput1:2945
--- re: ((a))
--- s: ABC



=== TEST 778: testinput1:2948
--- re: (a)b(c)
--- s: ABC



=== TEST 779: testinput1:2951
--- re: a+b+c
--- s: AABBABC



=== TEST 780: testinput1:2954
--- re: a{1,}b{1,}c
--- s: AABBABC



=== TEST 781: testinput1:2957
--- re: a.+?c
--- s: ABCABC



=== TEST 782: testinput1:2960
--- re: a.*?c
--- s: ABCABC



=== TEST 783: testinput1:2963
--- re: a.{0,5}?c
--- s: ABCABC



=== TEST 784: testinput1:2966
--- re: (a+|b)*
--- s: AB



=== TEST 785: testinput1:2969
--- re: (a+|b){0,}
--- s: AB



=== TEST 786: testinput1:2972
--- re: (a+|b)+
--- s: AB



=== TEST 787: testinput1:2975
--- re: (a+|b){1,}
--- s: AB



=== TEST 788: testinput1:2978
--- re: (a+|b)?
--- s: AB



=== TEST 789: testinput1:2981
--- re: (a+|b){0,1}
--- s: AB



=== TEST 790: testinput1:2984
--- re: (a+|b){0,1}?
--- s: AB



=== TEST 791: testinput1:2987
--- re: [^ab]*
--- s: CDE



=== TEST 792: testinput1:2995
--- re: ([abc])*d
--- s: ABBBCD



=== TEST 793: testinput1:2998
--- re: ([abc])*bcd
--- s: ABCD



=== TEST 794: testinput1:3001
--- re: a|b|c|d|e
--- s: E



=== TEST 795: testinput1:3004
--- re: (a|b|c|d|e)f
--- s: EF



=== TEST 796: testinput1:3007
--- re: abcd*efg
--- s: ABCDEFG



=== TEST 797: testinput1:3010
--- re: ab*
--- s: XABYABBBZ



=== TEST 798: testinput1:3011
--- re: ab*
--- s: XAYABBBZ



=== TEST 799: testinput1:3014
--- re: (ab|cd)e
--- s: ABCDE



=== TEST 800: testinput1:3017
--- re: [abhgefdc]ij
--- s: HIJ



=== TEST 801: testinput1:3020
--- re: ^(ab|cd)e
--- s: ABCDE



=== TEST 802: testinput1:3023
--- re: (abc|)ef
--- s: ABCDEF



=== TEST 803: testinput1:3026
--- re: (a|b)c*d
--- s: ABCD



=== TEST 804: testinput1:3029
--- re: (ab|ab*)bc
--- s: ABC



=== TEST 805: testinput1:3032
--- re: a([bc]*)c*
--- s: ABC



=== TEST 806: testinput1:3035
--- re: a([bc]*)(c*d)
--- s: ABCD



=== TEST 807: testinput1:3038
--- re: a([bc]+)(c*d)
--- s: ABCD



=== TEST 808: testinput1:3041
--- re: a([bc]*)(c+d)
--- s: ABCD



=== TEST 809: testinput1:3044
--- re: a[bcd]*dcdcde
--- s: ADCDCDE



=== TEST 810: testinput1:3049
--- re: (ab|a)b*c
--- s: ABC



=== TEST 811: testinput1:3052
--- re: ((a)(b)c)(d)
--- s: ABCD



=== TEST 812: testinput1:3055
--- re: [a-zA-Z_][a-zA-Z0-9_]*
--- s: ALPHA



=== TEST 813: testinput1:3058
--- re: ^a(bc+|b[eh])g|.h$
--- s: ABH



=== TEST 814: testinput1:3061
--- re: (bc+d$|ef*g.|h?i(j|k))
--- s: EFFGZ



=== TEST 815: testinput1:3062
--- re: (bc+d$|ef*g.|h?i(j|k))
--- s: IJ



=== TEST 816: testinput1:3063
--- re: (bc+d$|ef*g.|h?i(j|k))
--- s: REFFGZ



=== TEST 817: testinput1:3065
--- re: (bc+d$|ef*g.|h?i(j|k))
--- s: ADCDCDE



=== TEST 818: testinput1:3066
--- re: (bc+d$|ef*g.|h?i(j|k))
--- s: EFFG



=== TEST 819: testinput1:3067
--- re: (bc+d$|ef*g.|h?i(j|k))
--- s: BCDD



=== TEST 820: testinput1:3070
--- re: ((((((((((a))))))))))
--- s: A



=== TEST 821: testinput1:3076
--- re: (((((((((a)))))))))
--- s: A



=== TEST 822: testinput1:3079
--- re: (?:(?:(?:(?:(?:(?:(?:(?:(?:(a))))))))))
--- s: A



=== TEST 823: testinput1:3082
--- re: (?:(?:(?:(?:(?:(?:(?:(?:(?:(a|b|c))))))))))
--- s: C



=== TEST 824: testinput1:3086
--- re: multiple words of text
--- s: AA



=== TEST 825: testinput1:3087
--- re: multiple words of text
--- s: UH-UH



=== TEST 826: testinput1:3090
--- re: multiple words
--- s: MULTIPLE WORDS, YEAH



=== TEST 827: testinput1:3093
--- re: (.*)c(.*)
--- s: ABCDE



=== TEST 828: testinput1:3096
--- re: \((.*), (.*)\)
--- s: (A, B)



=== TEST 829: testinput1:3101
--- re: abcd
--- s: ABCD



=== TEST 830: testinput1:3104
--- re: a(bc)d
--- s: ABCD



=== TEST 831: testinput1:3107
--- re: a[-]?c
--- s: AC



=== TEST 832: testinput1:3125
--- re: a(?:b|c|d)(.)
--- s: ace



=== TEST 833: testinput1:3128
--- re: a(?:b|c|d)*(.)
--- s: ace



=== TEST 834: testinput1:3131
--- re: a(?:b|c|d)+?(.)
--- s: ace



=== TEST 835: testinput1:3132
--- re: a(?:b|c|d)+?(.)
--- s: acdbcdbe



=== TEST 836: testinput1:3135
--- re: a(?:b|c|d)+(.)
--- s: acdbcdbe



=== TEST 837: testinput1:3138
--- re: a(?:b|c|d){2}(.)
--- s: acdbcdbe



=== TEST 838: testinput1:3141
--- re: a(?:b|c|d){4,5}(.)
--- s: acdbcdbe



=== TEST 839: testinput1:3144
--- re: a(?:b|c|d){4,5}?(.)
--- s: acdbcdbe



=== TEST 840: testinput1:3147
--- re: ((foo)|(bar))*
--- s: foobar



=== TEST 841: testinput1:3150
--- re: a(?:b|c|d){6,7}(.)
--- s: acdbcdbe



=== TEST 842: testinput1:3153
--- re: a(?:b|c|d){6,7}?(.)
--- s: acdbcdbe



=== TEST 843: testinput1:3156
--- re: a(?:b|c|d){5,6}(.)
--- s: acdbcdbe



=== TEST 844: testinput1:3159
--- re: a(?:b|c|d){5,6}?(.)
--- s: acdbcdbe



=== TEST 845: testinput1:3162
--- re: a(?:b|c|d){5,7}(.)
--- s: acdbcdbe



=== TEST 846: testinput1:3165
--- re: a(?:b|c|d){5,7}?(.)
--- s: acdbcdbe



=== TEST 847: testinput1:3168
--- re: a(?:b|(c|e){1,2}?|d)+?(.)
--- s: ace



=== TEST 848: testinput1:3171
--- re: ^(.+)?B
--- s: AB



=== TEST 849: testinput1:3174
--- re: ^([^a-z])|(\^)$
--- s: .



=== TEST 850: testinput1:3177
--- re: ^[<>]&
--- s: <&OUT



=== TEST 851: testinput1:3193
--- re: (?:(f)(o)(o)|(b)(a)(r))*
--- s: foobar



=== TEST 852: testinput1:3207
--- re: (?:..)*a
--- s: aba



=== TEST 853: testinput1:3210
--- re: (?:..)*?a
--- s: aba



=== TEST 854: testinput1:3216
--- re: ^(){3,5}
--- s: abc



=== TEST 855: testinput1:3219
--- re: ^(a+)*ax
--- s: aax



=== TEST 856: testinput1:3222
--- re: ^((a|b)+)*ax
--- s: aax



=== TEST 857: testinput1:3225
--- re: ^((a|bc)+)*ax
--- s: aax



=== TEST 858: testinput1:3228
--- re: (a|x)*ab
--- s: cab



=== TEST 859: testinput1:3231
--- re: (a)*ab
--- s: cab



=== TEST 860: testinput1:3344
--- re: (?:c|d)(?:)(?:a(?:)(?:b)(?:b(?:))(?:b(?:)(?:b)))
--- s: cabbbb



=== TEST 861: testinput1:3347
--- re: (?:c|d)(?:)(?:aaaaaaaa(?:)(?:bbbbbbbb)(?:bbbbbbbb(?:))(?:bbbbbbbb(?:)(?:bbbbbbbb)))
--- s: caaaaaaaabbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb



=== TEST 862: testinput1:3354
--- re: foo\w*\d{4}baz
--- s: foobar1234baz



=== TEST 863: testinput1:3357
--- re: x(~~)*(?:(?:F)?)?
--- s: x~~



=== TEST 864: testinput1:3382
--- re: ^(?:a?b?)*$
--- s: \



=== TEST 865: testinput1:3383
--- re: ^(?:a?b?)*$
--- s: a



=== TEST 866: testinput1:3384
--- re: ^(?:a?b?)*$
--- s: ab



=== TEST 867: testinput1:3385
--- re: ^(?:a?b?)*$
--- s: aaa   



=== TEST 868: testinput1:3386
--- re: ^(?:a?b?)*$
--- s: *** Failers



=== TEST 869: testinput1:3387
--- re: ^(?:a?b?)*$
--- s: dbcb



=== TEST 870: testinput1:3388
--- re: ^(?:a?b?)*$
--- s: a--



=== TEST 871: testinput1:3389
--- re: ^(?:a?b?)*$
--- s: aa-- 



=== TEST 872: testinput1:3420
--- re: ()^b
--- s: *** Failers



=== TEST 873: testinput1:3421
--- re: ()^b
--- s: a\nb\nc\n



=== TEST 874: testinput1:3477
--- re: (\w+:)+
--- s: one:



=== TEST 875: testinput1:3491
--- re: ([\w:]+::)?(\w+)$
--- s: abcd



=== TEST 876: testinput1:3492
--- re: ([\w:]+::)?(\w+)$
--- s: xy:z:::abcd



=== TEST 877: testinput1:3495
--- re: ^[^bcd]*(c+)
--- s: aexycd



=== TEST 878: testinput1:3498
--- re: (a*)b+
--- s: caab



=== TEST 879: testinput1:3503
--- re: ([\w:]+::)?(\w+)$
--- s: *** Failers



=== TEST 880: testinput1:3504
--- re: ([\w:]+::)?(\w+)$
--- s: abcd:



=== TEST 881: testinput1:3516
--- re: ([[:]+)
--- s: a:[b]:



=== TEST 882: testinput1:3519
--- re: ([[=]+)
--- s: a=[b]=



=== TEST 883: testinput1:3522
--- re: ([[.]+)
--- s: a.[b].



=== TEST 884: testinput1:3547
--- re: b\z
--- s: a\nb



=== TEST 885: testinput1:3548
--- re: b\z
--- s: *** Failers



=== TEST 886: testinput1:3640
--- re: ((Z)+|A)*
--- s: ZABCDEFG



=== TEST 887: testinput1:3643
--- re: (Z()|A)*
--- s: ZABCDEFG



=== TEST 888: testinput1:3646
--- re: (Z(())|A)*
--- s: ZABCDEFG



=== TEST 889: testinput1:3655
--- re: a*
--- s: abbab



=== TEST 890: testinput1:3658
--- re: ^[a-\d]
--- s: abcde



=== TEST 891: testinput1:3659
--- re: ^[a-\d]
--- s: -things



=== TEST 892: testinput1:3660
--- re: ^[a-\d]
--- s: 0digit



=== TEST 893: testinput1:3661
--- re: ^[a-\d]
--- s: *** Failers



=== TEST 894: testinput1:3662
--- re: ^[a-\d]
--- s: bcdef    



=== TEST 895: testinput1:3665
--- re: ^[\d-a]
--- s: abcde



=== TEST 896: testinput1:3666
--- re: ^[\d-a]
--- s: -things



=== TEST 897: testinput1:3667
--- re: ^[\d-a]
--- s: 0digit



=== TEST 898: testinput1:3668
--- re: ^[\d-a]
--- s: *** Failers



=== TEST 899: testinput1:3669
--- re: ^[\d-a]
--- s: bcdef    



=== TEST 900: testinput1:3678
--- re: [\s]+
--- s: > \x09\x0a\x0c\x0d\x0b<



=== TEST 901: testinput1:3681
--- re: \s+
--- s: > \x09\x0a\x0c\x0d\x0b<



=== TEST 902: testinput1:3684
--- re: ab
--- s: ab



=== TEST 903: testinput1:3739
--- re: abc.
--- s: abc1abc2xyzabc3 



=== TEST 904: testinput1:3781
--- re: -- an internal component. --
--- s: (?:                         # start of item



=== TEST 905: testinput1:3782
--- re: -- an internal component. --
--- s: (?: [0-9a-f]{1,4} |       # 1-4 hex digits or



=== TEST 906: testinput1:3783
--- re: -- an internal component. --
--- s: (?(1)0 | () ) )           # if null previously matched, fail; else null



=== TEST 907: testinput1:3784
--- re: -- an internal component. --
--- s: :                         # followed by colon



=== TEST 908: testinput1:3785
--- re: -- an internal component. --
--- s: ){1,7}                      # end item; 1-7 of them required               



=== TEST 909: testinput1:3786
--- re: -- an internal component. --
--- s: [0-9a-f]{1,4} $             # final hex number at end of string



=== TEST 910: testinput1:3787
--- re: -- an internal component. --
--- s: (?(1)|.)                    # check that there was an empty component



=== TEST 911: testinput1:3788
--- re: -- an internal component. --
--- s: /xi



=== TEST 912: testinput1:3789
--- re: -- an internal component. --
--- s: a123::a123



=== TEST 913: testinput1:3790
--- re: -- an internal component. --
--- s: a123:b342::abcd



=== TEST 914: testinput1:3791
--- re: -- an internal component. --
--- s: a123:b342::324e:abcd



=== TEST 915: testinput1:3792
--- re: -- an internal component. --
--- s: a123:ddde:b342::324e:abcd



=== TEST 916: testinput1:3793
--- re: -- an internal component. --
--- s: a123:ddde:b342::324e:dcba:abcd



=== TEST 917: testinput1:3794
--- re: -- an internal component. --
--- s: a123:ddde:9999:b342::324e:dcba:abcd



=== TEST 918: testinput1:3795
--- re: -- an internal component. --
--- s: *** Failers



=== TEST 919: testinput1:3796
--- re: -- an internal component. --
--- s: 1:2:3:4:5:6:7:8



=== TEST 920: testinput1:3797
--- re: -- an internal component. --
--- s: a123:bce:ddde:9999:b342::324e:dcba:abcd



=== TEST 921: testinput1:3798
--- re: -- an internal component. --
--- s: a123::9999:b342::324e:dcba:abcd



=== TEST 922: testinput1:3799
--- re: -- an internal component. --
--- s: abcde:2:3:4:5:6:7:8



=== TEST 923: testinput1:3800
--- re: -- an internal component. --
--- s: ::1



=== TEST 924: testinput1:3801
--- re: -- an internal component. --
--- s: abcd:fee0:123::   



=== TEST 925: testinput1:3802
--- re: -- an internal component. --
--- s: :1



=== TEST 926: testinput1:3803
--- re: -- an internal component. --
--- s: 1:  



=== TEST 927: testinput1:3815
--- re: [\z\C]
--- s: z



=== TEST 928: testinput1:3816
--- re: [\z\C]
--- s: C 



=== TEST 929: testinput1:3819
--- re: \M
--- s: M 



=== TEST 930: testinput1:3822
--- re: (a+)*b
--- s: aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa 



=== TEST 931: testinput1:3831
--- re: ≈жед[а-€ј-я]+
--- s: ≈жеда



=== TEST 932: testinput1:3832
--- re: ≈жед[а-€ј-я]+
--- s: ≈жед€



=== TEST 933: testinput1:3833
--- re: ≈жед[а-€ј-я]+
--- s: ≈жедј



=== TEST 934: testinput1:3834
--- re: ≈жед[а-€ј-я]+
--- s: ≈жедя



=== TEST 935: testinput1:3863
--- re: ^
--- s: a\nb\nc\n



=== TEST 936: testinput1:3864
--- re: ^
--- s: \ 



=== TEST 937: testinput1:3880
--- re: [[,abc,]+]
--- s: abc]



=== TEST 938: testinput1:3881
--- re: [[,abc,]+]
--- s: a,b]



=== TEST 939: testinput1:3882
--- re: [[,abc,]+]
--- s: [a,b,c]  



=== TEST 940: testinput1:3899
--- re: a*b*\w
--- s: aaabbbb



=== TEST 941: testinput1:3900
--- re: a*b*\w
--- s: aaaa



=== TEST 942: testinput1:3901
--- re: a*b*\w
--- s: a



=== TEST 943: testinput1:3904
--- re: a*b?\w
--- s: aaabbbb



=== TEST 944: testinput1:3905
--- re: a*b?\w
--- s: aaaa



=== TEST 945: testinput1:3906
--- re: a*b?\w
--- s: a



=== TEST 946: testinput1:3909
--- re: a*b{0,4}\w
--- s: aaabbbb



=== TEST 947: testinput1:3910
--- re: a*b{0,4}\w
--- s: aaaa



=== TEST 948: testinput1:3911
--- re: a*b{0,4}\w
--- s: a



=== TEST 949: testinput1:3914
--- re: a*b{0,}\w
--- s: aaabbbb



=== TEST 950: testinput1:3915
--- re: a*b{0,}\w
--- s: aaaa



=== TEST 951: testinput1:3916
--- re: a*b{0,}\w
--- s: a



=== TEST 952: testinput1:3919
--- re: a*\d*\w
--- s: 0a



=== TEST 953: testinput1:3920
--- re: a*\d*\w
--- s: a 



=== TEST 954: testinput1:3923
--- re: a*b *\w
--- s: a 



=== TEST 955: testinput1:3926
--- re: a*b *\w
--- s: *\w/x



=== TEST 956: testinput1:3930
--- re: a* b *\w
--- s: a 



=== TEST 957: testinput1:3933
--- re: ^\w+=.*(\\\n.*)*
--- s: abc=xyz\\\npqr



=== TEST 958: testinput1:3976
--- re: ^(a()*)*
--- s: aaaa



=== TEST 959: testinput1:3979
--- re: ^(?:a(?:(?:))*)*
--- s: aaaa



=== TEST 960: testinput1:3982
--- re: ^(a()+)+
--- s: aaaa



=== TEST 961: testinput1:3985
--- re: ^(?:a(?:(?:))+)+
--- s: aaaa



=== TEST 962: testinput1:3993
--- re: (a|)*\d
--- s: aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa



=== TEST 963: testinput1:3994
--- re: (a|)*\d
--- s: aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa4
--- cap: (0, 61) (59, 60)



=== TEST 964: testinput1:4001
--- re: (?:a|)*\d
--- s: aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa



=== TEST 965: testinput1:4002
--- re: (?:a|)*\d
--- s: aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa4



=== TEST 966: testinput1:4020
--- re: (.*(.)?)*
--- s: abcd
--- cap: (0, 4) (0, 4)



=== TEST 967: testinput1:4032
--- re: [[:abcd:xyz]]
--- s: a]



=== TEST 968: testinput1:4033
--- re: [[:abcd:xyz]]
--- s: :] 



=== TEST 969: testinput1:4036
--- re: [abc[:x\]pqr]
--- s: a



=== TEST 970: testinput1:4037
--- re: [abc[:x\]pqr]
--- s: [



=== TEST 971: testinput1:4038
--- re: [abc[:x\]pqr]
--- s: :



=== TEST 972: testinput1:4039
--- re: [abc[:x\]pqr]
--- s: ]



=== TEST 973: testinput1:4040
--- re: [abc[:x\]pqr]
--- s: p    



=== TEST 974: testinput1:4043
--- re: .*[op][xyz]
--- s: fooabcfoo



=== TEST 975: testinput1:4078
--- re: [\x00-\xff\s]+
--- s: \x0a\x0b\x0c\x0d



=== TEST 976: testinput1:4081
--- re: ^\c
--- s: ?



=== TEST 977: testinput1:4090
--- re: [^a]*
--- s: 12abc



=== TEST 978: testinput1:4091
--- re: [^a]*
--- s: 12ABC



=== TEST 979: testinput1:4098
--- re: [^a]*?X
--- s: ** Failers



=== TEST 980: testinput1:4099
--- re: [^a]*?X
--- s: 12abc



=== TEST 981: testinput1:4100
--- re: [^a]*?X
--- s: 12ABC



=== TEST 982: testinput1:4103
--- re: [^a]+?X
--- s: ** Failers



=== TEST 983: testinput1:4104
--- re: [^a]+?X
--- s: 12abc



=== TEST 984: testinput1:4105
--- re: [^a]+?X
--- s: 12ABC



=== TEST 985: testinput1:4108
--- re: [^a]?X
--- s: 12aXbcX



=== TEST 986: testinput1:4109
--- re: [^a]?X
--- s: 12AXBCX



=== TEST 987: testinput1:4110
--- re: [^a]?X
--- s: BCX 



=== TEST 988: testinput1:4113
--- re: [^a]??X
--- s: 12aXbcX



=== TEST 989: testinput1:4114
--- re: [^a]??X
--- s: 12AXBCX



=== TEST 990: testinput1:4115
--- re: [^a]??X
--- s: BCX



=== TEST 991: testinput1:4123
--- re: [^a]{2,3}
--- s: abcdef



=== TEST 992: testinput1:4124
--- re: [^a]{2,3}
--- s: ABCDEF  



=== TEST 993: testinput1:4127
--- re: [^a]{2,3}?
--- s: abcdef



=== TEST 994: testinput1:4128
--- re: [^a]{2,3}?
--- s: ABCDEF  



=== TEST 995: testinput1:4135
--- re: ((a|)+)+Z
--- s: Z



=== TEST 996: testinput1:4138
--- re: (a)b|(a)c
--- s: ac



=== TEST 997: testinput1:4177
--- re: (?:a+|ab)+c
--- s: aabc



=== TEST 998: testinput1:4192
--- re: ^(?:a|ab)+c
--- s: aaaabc



=== TEST 999: testinput1:4253
--- re: [:a]xxx[b:]
--- s: :xxx:



=== TEST 1000: testinput1:4310
--- re: ab\Cde
--- s: abXde



=== TEST 1001: testinput1:4316
--- re: a[\CD]b
--- s: aCb



=== TEST 1002: testinput1:4317
--- re: a[\CD]b
--- s: aDb 



=== TEST 1003: testinput1:4320
--- re: a[\C-X]b
--- s: aJb



=== TEST 1004: testinput1:4323
--- re: \H\h\V\v
--- s: X X\x0a



=== TEST 1005: testinput1:4324
--- re: \H\h\V\v
--- s: X\x09X\x0b



=== TEST 1006: testinput1:4325
--- re: \H\h\V\v
--- s: ** Failers



=== TEST 1007: testinput1:4326
--- re: \H\h\V\v
--- s: \xa0 X\x0a   



=== TEST 1008: testinput1:4329
--- re: \H*\h+\V?\v{3,4}
--- s: \x09\x20\xa0X\x0a\x0b\x0c\x0d\x0a



=== TEST 1009: testinput1:4330
--- re: \H*\h+\V?\v{3,4}
--- s: \x09\x20\xa0\x0a\x0b\x0c\x0d\x0a



=== TEST 1010: testinput1:4331
--- re: \H*\h+\V?\v{3,4}
--- s: \x09\x20\xa0\x0a\x0b\x0c



=== TEST 1011: testinput1:4332
--- re: \H*\h+\V?\v{3,4}
--- s: ** Failers 



=== TEST 1012: testinput1:4333
--- re: \H*\h+\V?\v{3,4}
--- s: \x09\x20\xa0\x0a\x0b



=== TEST 1013: testinput1:4336
--- re: \H{3,4}
--- s: XY  ABCDE



=== TEST 1014: testinput1:4337
--- re: \H{3,4}
--- s: XY  PQR ST 



=== TEST 1015: testinput1:4340
--- re: .\h{3,4}.
--- s: XY  AB    PQRS



=== TEST 1016: testinput1:4343
--- re: \h*X\h?\H+Y\H?Z
--- s: >XNNNYZ



=== TEST 1017: testinput1:4344
--- re: \h*X\h?\H+Y\H?Z
--- s: >  X NYQZ



=== TEST 1018: testinput1:4345
--- re: \h*X\h?\H+Y\H?Z
--- s: ** Failers



=== TEST 1019: testinput1:4346
--- re: \h*X\h?\H+Y\H?Z
--- s: >XYZ   



=== TEST 1020: testinput1:4347
--- re: \h*X\h?\H+Y\H?Z
--- s: >  X NY Z



=== TEST 1021: testinput1:4350
--- re: \v*X\v?Y\v+Z\V*\x0a\V+\x0b\V{2,3}\x0c
--- s: >XY\x0aZ\x0aA\x0bNN\x0c



=== TEST 1022: testinput1:4351
--- re: \v*X\v?Y\v+Z\V*\x0a\V+\x0b\V{2,3}\x0c
--- s: >\x0a\x0dX\x0aY\x0a\x0bZZZ\x0aAAA\x0bNNN\x0c



=== TEST 1023: testinput1:4906
--- re: \A.*?(?:a|bc)
--- s: ba



=== TEST 1024: testinput1:4912
--- re: \A.*?(a|bc)
--- s: ba



=== TEST 1025: testinput1:4930
--- re: \A.*?(?:a|bc|d)
--- s: ba



=== TEST 1026: testinput1:4954
--- re: ^\N+
--- s: abc\ndef



=== TEST 1027: testinput1:5260
--- re: ((?:a?)*)*c
--- s: aac   
--- cap: (0, 3) (0, 2)

