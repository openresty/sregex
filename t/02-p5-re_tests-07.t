# vim:set ft= ts=4 sw=4 et fdm=marker:

use t::SRegex 'no_plan';

run_tests();

__DATA__

=== TEST 1: re_tests:429
--- re: (((((((((a)))))))))
--- s eval: "A"
--- flags: i



=== TEST 2: re_tests:430
--- re: (?:(?:(?:(?:(?:(?:(?:(?:(?:(a))))))))))
--- s eval: "A"
--- flags: i



=== TEST 3: re_tests:431
--- re: (?:(?:(?:(?:(?:(?:(?:(?:(?:(a|b|c))))))))))
--- s eval: "C"
--- flags: i



=== TEST 4: re_tests:432
--- re: multiple words of text
--- s eval: "UH-UH"
--- flags: i



=== TEST 5: re_tests:433
--- re: multiple words
--- s eval: "MULTIPLE WORDS, YEAH"
--- flags: i



=== TEST 6: re_tests:434
--- re: (.*)c(.*)
--- s eval: "ABCDE"
--- flags: i



=== TEST 7: re_tests:435
--- re: \((.*), (.*)\)
--- s eval: "(A, B)"
--- flags: i



=== TEST 8: re_tests:436
--- re: [k]
--- s eval: "AB"
--- flags: i



=== TEST 9: re_tests:437
--- re: abcd
--- s eval: "ABCD"
--- flags: i



=== TEST 10: re_tests:438
--- re: a(bc)d
--- s eval: "ABCD"
--- flags: i



=== TEST 11: re_tests:439
--- re: a[-]?c
--- s eval: "AC"
--- flags: i



=== TEST 12: re_tests:446
--- re: a(?:b|c|d)(.)
--- s eval: "ace"



=== TEST 13: re_tests:447
--- re: a(?:b|c|d)*(.)
--- s eval: "ace"



=== TEST 14: re_tests:448
--- re: a(?:b|c|d)+?(.)
--- s eval: "ace"



=== TEST 15: re_tests:449
--- re: a(?:b|c|d)+?(.)
--- s eval: "acdbcdbe"



=== TEST 16: re_tests:450
--- re: a(?:b|c|d)+(.)
--- s eval: "acdbcdbe"



=== TEST 17: re_tests:451
--- re: a(?:b|c|d){2}(.)
--- s eval: "acdbcdbe"



=== TEST 18: re_tests:452
--- re: a(?:b|c|d){4,5}(.)
--- s eval: "acdbcdbe"



=== TEST 19: re_tests:453
--- re: a(?:b|c|d){4,5}?(.)
--- s eval: "acdbcdbe"



=== TEST 20: re_tests:454
--- re: ((foo)|(bar))*
--- s eval: "foobar"



=== TEST 21: re_tests:455
--- re: (?
--- s eval: "-"
--- err_like: ^\[error\] syntax error at pos \d+$



=== TEST 22: re_tests:456
--- re: a(?:b|c|d){6,7}(.)
--- s eval: "acdbcdbe"



=== TEST 23: re_tests:457
--- re: a(?:b|c|d){6,7}?(.)
--- s eval: "acdbcdbe"



=== TEST 24: re_tests:458
--- re: a(?:b|c|d){5,6}(.)
--- s eval: "acdbcdbe"



=== TEST 25: re_tests:459
--- re: a(?:b|c|d){5,6}?(.)
--- s eval: "acdbcdbe"



=== TEST 26: re_tests:460
--- re: a(?:b|c|d){5,7}(.)
--- s eval: "acdbcdbe"



=== TEST 27: re_tests:461
--- re: a(?:b|c|d){5,7}?(.)
--- s eval: "acdbcdbe"



=== TEST 28: re_tests:462
--- re: a(?:b|(c|e){1,2}?|d)+?(.)
--- s eval: "ace"



=== TEST 29: re_tests:463
--- re: ^(.+)?B
--- s eval: "AB"



=== TEST 30: re_tests:464
--- re: ^([^a-z])|(\^)$
--- s eval: "."



=== TEST 31: re_tests:465
--- re: ^[<>]&
--- s eval: "<&OUT"



=== TEST 32: re_tests:472
--- re: ((a{4})+)
--- s eval: "aaaaaaaaa"



=== TEST 33: re_tests:473
--- re: (((aa){2})+)
--- s eval: "aaaaaaaaaa"



=== TEST 34: re_tests:474
--- re: (((a{2}){2})+)
--- s eval: "aaaaaaaaaa"



=== TEST 35: re_tests:475
--- re: (?:(f)(o)(o)|(b)(a)(r))*
--- s eval: "foobar"



=== TEST 36: re_tests:483
--- re: (?<%)b
--- s eval: "-"
--- err_like: ^\[error\] syntax error at pos \d+$



=== TEST 37: re_tests:484
--- re: (?:..)*a
--- s eval: "aba"



=== TEST 38: re_tests:485
--- re: (?:..)*?a
--- s eval: "aba"



=== TEST 39: re_tests:487
--- re: ^(){3,5}
--- s eval: "abc"



=== TEST 40: re_tests:488
--- re: ^(a+)*ax
--- s eval: "aax"



=== TEST 41: re_tests:489
--- re: ^((a|b)+)*ax
--- s eval: "aax"



=== TEST 42: re_tests:490
--- re: ^((a|bc)+)*ax
--- s eval: "aax"



=== TEST 43: re_tests:491
--- re: (a|x)*ab
--- s eval: "cab"



=== TEST 44: re_tests:492
--- re: (a)*ab
--- s eval: "cab"



=== TEST 45: re_tests:531
--- re: (?:c|d)(?:)(?:a(?:)(?:b)(?:b(?:))(?:b(?:)(?:b)))
--- s eval: "cabbbb"



=== TEST 46: re_tests:532
--- re: (?:c|d)(?:)(?:aaaaaaaa(?:)(?:bbbbbbbb)(?:bbbbbbbb(?:))(?:bbbbbbbb(?:)(?:bbbbbbbb)))
--- s eval: "caaaaaaaabbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb"



=== TEST 47: re_tests:535
--- re: foo\w*\d{4}baz
--- s eval: "foobar1234baz"



=== TEST 48: re_tests:537
--- re: a(?{)b
--- s eval: "-"
--- err_like: ^\[error\] syntax error at pos \d+$



=== TEST 49: re_tests:544
--- re: x(~~)*(?:(?:F)?)?
--- s eval: "x~~"



=== TEST 50: re_tests:552
--- re: ^(?:a?b?)*$
--- s eval: "a--"



