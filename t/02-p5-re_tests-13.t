# vim:set ft= ts=4 sw=4 et fdm=marker:

use t::SRegex 'no_plan';

run_tests();

__DATA__

=== TEST 1: re_tests:1084
--- re: (?P<=n>foo|bar|baz)
--- s eval: "snofooewa"
--- err_like: ^\[error\] syntax error at pos \d+$



=== TEST 2: re_tests:1085
--- re: (?P<!n>foo|bar|baz)
--- s eval: "snofooewa"
--- err_like: ^\[error\] syntax error at pos \d+$



=== TEST 3: re_tests:1086
--- re: (?PX<n>foo|bar|baz)
--- s eval: "snofooewa"
--- err_like: ^\[error\] syntax error at pos \d+$



=== TEST 4: re_tests:1208
--- re: (foo[1x]|bar[2x]|baz[3x])+y
--- s eval: "foo1bar2baz3y"



=== TEST 5: re_tests:1210
--- re: (foo[1x]|bar[2x]|baz[3x])*y
--- s eval: "foo1bar2baz3y"



=== TEST 6: re_tests:1213
--- re: ([yX].|WORDS|[yX].|WORD)S
--- s eval: "WORDS"



=== TEST 7: re_tests:1215
--- re: ([yX].|WORDS|WORD|[xY].)S
--- s eval: "WORDS"



=== TEST 8: re_tests:1216
--- re: (foo|fool|[zx].|money|parted)$
--- s eval: "fool"



=== TEST 9: re_tests:1217
--- re: ([zx].|foo|fool|[zq].|money|parted|[yx].)$
--- s eval: "fool"



=== TEST 10: re_tests:1218
--- re: (foo|fool|[zx].|money|parted)$
--- s eval: "fools"



=== TEST 11: re_tests:1219
--- re: ([zx].|foo|fool|[qx].|money|parted|[py].)$
--- s eval: "fools"



=== TEST 12: re_tests:1221
--- re: ([yX].|WORDS|[yX].|WORD)+S
--- s eval: "WORDS"



=== TEST 13: re_tests:1222
--- re: (WORDS|WORLD|WORD)+S
--- s eval: "WORDS"



=== TEST 14: re_tests:1223
--- re: ([yX].|WORDS|WORD|[xY].)+S
--- s eval: "WORDS"



=== TEST 15: re_tests:1224
--- re: (foo|fool|[zx].|money|parted)+$
--- s eval: "fool"



=== TEST 16: re_tests:1225
--- re: ([zx].|foo|fool|[zq].|money|parted|[yx].)+$
--- s eval: "fool"



=== TEST 17: re_tests:1226
--- re: (foo|fool|[zx].|money|parted)+$
--- s eval: "fools"



=== TEST 18: re_tests:1227
--- re: ([zx].|foo|fool|[qx].|money|parted|[py].)+$
--- s eval: "fools"



=== TEST 19: re_tests:1229
--- re: (x|y|z[QW])+(longish|loquatious|excessive|overblown[QW])+
--- s eval: "xyzQzWlongishoverblownW"



=== TEST 20: re_tests:1230
--- re: (x|y|z[QW])*(longish|loquatious|excessive|overblown[QW])*
--- s eval: "xyzQzWlongishoverblownW"



=== TEST 21: re_tests:1231
--- re: (x|y|z[QW]){1,5}(longish|loquatious|excessive|overblown[QW]){1,5}
--- s eval: "xyzQzWlongishoverblownW"



=== TEST 22: re_tests:1270
--- re: (?''foo) bar
--- s eval: "..foo bar.."
--- err_like: ^\[error\] syntax error at pos \d+$



=== TEST 23: re_tests:1271
--- re: (?<>foo) bar
--- s eval: "..foo bar.."
--- err_like: ^\[error\] syntax error at pos \d+$



=== TEST 24: re_tests:1272
--- re: foo \k'n'
--- s eval: "foo foo"
--- err_like: ^\[error\] syntax error at pos \d+$



=== TEST 25: re_tests:1273
--- re: foo \k<n>
--- s eval: "foo foo"
--- err_like: ^\[error\] syntax error at pos \d+$



=== TEST 26: re_tests:1274
--- re: foo \k'a1'
--- s eval: "foo foo"
--- err_like: ^\[error\] syntax error at pos \d+$



=== TEST 27: re_tests:1275
--- re: foo \k<a1>
--- s eval: "foo foo"
--- err_like: ^\[error\] syntax error at pos \d+$



=== TEST 28: re_tests:1276
--- re: foo \k'_'
--- s eval: "foo foo"
--- err_like: ^\[error\] syntax error at pos \d+$



=== TEST 29: re_tests:1277
--- re: foo \k<_>
--- s eval: "foo foo"
--- err_like: ^\[error\] syntax error at pos \d+$



=== TEST 30: re_tests:1278
--- re: foo \k'_0_'
--- s eval: "foo foo"
--- err_like: ^\[error\] syntax error at pos \d+$



=== TEST 31: re_tests:1279
--- re: foo \k<_0_>
--- s eval: "foo foo"
--- err_like: ^\[error\] syntax error at pos \d+$



=== TEST 32: re_tests:1280
--- re: foo \k'0'
--- s eval: "foo foo"
--- err_like: ^\[error\] syntax error at pos \d+$



=== TEST 33: re_tests:1281
--- re: foo \k<0>
--- s eval: "foo foo"
--- err_like: ^\[error\] syntax error at pos \d+$



=== TEST 34: re_tests:1282
--- re: foo \k'12'
--- s eval: "foo foo"
--- err_like: ^\[error\] syntax error at pos \d+$



=== TEST 35: re_tests:1283
--- re: foo \k<12>
--- s eval: "foo foo"
--- err_like: ^\[error\] syntax error at pos \d+$



=== TEST 36: re_tests:1284
--- re: foo \k'1a'
--- s eval: "foo foo"
--- err_like: ^\[error\] syntax error at pos \d+$



=== TEST 37: re_tests:1285
--- re: foo \k<1a>
--- s eval: "foo foo"
--- err_like: ^\[error\] syntax error at pos \d+$



=== TEST 38: re_tests:1286
--- re: foo \k''
--- s eval: "foo foo"
--- err_like: ^\[error\] syntax error at pos \d+$



=== TEST 39: re_tests:1287
--- re: foo \k<>
--- s eval: "foo foo"
--- err_like: ^\[error\] syntax error at pos \d+$



=== TEST 40: re_tests:1364
--- re: foo(\v+)bar
--- s eval: "foo\r\n\x{85}\r\n\nbar"



=== TEST 41: re_tests:1365
--- re: (\V+)(\v)
--- s eval: "foo\r\n\x{85}\r\n\nbar"



=== TEST 42: re_tests:1366
--- re: (\v+)(\V)
--- s eval: "foo\r\n\x{85}\r\n\nbar"



=== TEST 43: re_tests:1367
--- re: foo(\v)bar
--- s eval: "foo\x{85}bar"



=== TEST 44: re_tests:1368
--- re: (\V)(\v)
--- s eval: "foo\x{85}bar"



=== TEST 45: re_tests:1369
--- re: (\v)(\V)
--- s eval: "foo\x{85}bar"



=== TEST 46: re_tests:1370
--- re: foo(\v)bar
--- s eval: "foo\rbar"



=== TEST 47: re_tests:1371
--- re: (\V)(\v)
--- s eval: "foo\rbar"



=== TEST 48: re_tests:1372
--- re: (\v)(\V)
--- s eval: "foo\rbar"



=== TEST 49: re_tests:1375
--- re: foo(\h+)bar
--- s eval: "foo\t\x{A0}bar"



=== TEST 50: re_tests:1376
--- re: (\H+)(\h)
--- s eval: "foo\t\x{A0}bar"



