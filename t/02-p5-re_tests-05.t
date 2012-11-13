# vim:set ft= ts=4 sw=4 et fdm=marker:

use t::SRegex 'no_plan';

run_tests();

__DATA__

=== TEST 1: re_tests:328
--- re: ab??bc
--- s eval: "ABBC"



=== TEST 2: re_tests:329
--- re: ab??bc
--- s eval: "ABC"



=== TEST 3: re_tests:330
--- re: ab{0,1}?bc
--- s eval: "ABC"



=== TEST 4: re_tests:331
--- re: ab??bc
--- s eval: "ABBBBC"



=== TEST 5: re_tests:332
--- re: ab??c
--- s eval: "ABC"



=== TEST 6: re_tests:333
--- re: ab{0,1}?c
--- s eval: "ABC"



=== TEST 7: re_tests:334
--- re: ^abc$
--- s eval: "ABC"



=== TEST 8: re_tests:335
--- re: ^abc$
--- s eval: "ABCC"



=== TEST 9: re_tests:336
--- re: ^abc
--- s eval: "ABCC"



=== TEST 10: re_tests:337
--- re: ^abc$
--- s eval: "AABC"



=== TEST 11: re_tests:338
--- re: abc$
--- s eval: "AABC"



=== TEST 12: re_tests:339
--- re: ^
--- s eval: "ABC"



=== TEST 13: re_tests:340
--- re: $
--- s eval: "ABC"



=== TEST 14: re_tests:341
--- re: a.c
--- s eval: "ABC"



=== TEST 15: re_tests:342
--- re: a.c
--- s eval: "AXC"



=== TEST 16: re_tests:343
--- re: a\Nc
--- s eval: "ABC"



=== TEST 17: re_tests:344
--- re: a.*?c
--- s eval: "AXYZC"



=== TEST 18: re_tests:345
--- re: a.*c
--- s eval: "AXYZD"



=== TEST 19: re_tests:346
--- re: a[bc]d
--- s eval: "ABC"



=== TEST 20: re_tests:347
--- re: a[bc]d
--- s eval: "ABD"



=== TEST 21: re_tests:348
--- re: a[b-d]e
--- s eval: "ABD"



=== TEST 22: re_tests:349
--- re: a[b-d]e
--- s eval: "ACE"



=== TEST 23: re_tests:350
--- re: a[b-d]
--- s eval: "AAC"



=== TEST 24: re_tests:351
--- re: a[-b]
--- s eval: "A-"



=== TEST 25: re_tests:352
--- re: a[b-]
--- s eval: "A-"



=== TEST 26: re_tests:353
--- re: a[b-a]
--- s eval: "-"
--- err
[error] syntax error



=== TEST 27: re_tests:354
--- re: a[]b
--- s eval: "-"
--- err
[error] syntax error



=== TEST 28: re_tests:355
--- re: a[
--- s eval: "-"
--- err
[error] syntax error



=== TEST 29: re_tests:356
--- re: a]
--- s eval: "A]"



=== TEST 30: re_tests:357
--- re: a[]]b
--- s eval: "A]B"



=== TEST 31: re_tests:358
--- re: a[^bc]d
--- s eval: "AED"



=== TEST 32: re_tests:359
--- re: a[^bc]d
--- s eval: "ABD"



=== TEST 33: re_tests:360
--- re: a[^-b]c
--- s eval: "ADC"



=== TEST 34: re_tests:361
--- re: a[^-b]c
--- s eval: "A-C"



=== TEST 35: re_tests:362
--- re: a[^]b]c
--- s eval: "A]C"



=== TEST 36: re_tests:363
--- re: a[^]b]c
--- s eval: "ADC"



=== TEST 37: re_tests:364
--- re: ab|cd
--- s eval: "ABC"



=== TEST 38: re_tests:365
--- re: ab|cd
--- s eval: "ABCD"



=== TEST 39: re_tests:366
--- re: ()ef
--- s eval: "DEF"



=== TEST 40: re_tests:367
--- re: *a
--- s eval: "-"
--- err
[error] syntax error



=== TEST 41: re_tests:368
--- re: (|*)b
--- s eval: "-"
--- err
[error] syntax error



=== TEST 42: re_tests:369
--- re: (*)b
--- s eval: "-"
--- err
[error] syntax error



=== TEST 43: re_tests:370
--- re: $b
--- s eval: "B"



=== TEST 44: re_tests:371
--- re: a\
--- s eval: "-"
--- err
[error] syntax error



=== TEST 45: re_tests:372
--- re: a\(b
--- s eval: "A(B"



=== TEST 46: re_tests:373
--- re: a\(*b
--- s eval: "AB"



=== TEST 47: re_tests:374
--- re: a\(*b
--- s eval: "A((B"



=== TEST 48: re_tests:375
--- re: a\\b
--- s eval: "A\\B"



=== TEST 49: re_tests:376
--- re: abc)
--- s eval: "-"
--- err
[error] syntax error



=== TEST 50: re_tests:377
--- re: (abc
--- s eval: "-"
--- err
[error] syntax error



