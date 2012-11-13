# vim:set ft= ts=4 sw=4 et fdm=marker:

use t::SRegex 'no_plan';

run_tests();

__DATA__

=== TEST 1: re_tests:780
--- re: ab\z
--- s eval: "ca\nb\n"



=== TEST 2: re_tests:781
--- re: ab$
--- s eval: "ca\nb\n"



=== TEST 3: re_tests:783
--- re: ab\z
--- s eval: "b\nca\n"



=== TEST 4: re_tests:784
--- re: ab$
--- s eval: "b\nca\n"



=== TEST 5: re_tests:786
--- re: ab\z
--- s eval: "b\nca"



=== TEST 6: re_tests:787
--- re: ab$
--- s eval: "b\nca"



=== TEST 7: re_tests:789
--- re: ab\z
--- s eval: "ca\nb\n"



=== TEST 8: re_tests:790
--- re: ab$
--- s eval: "ca\nb\n"



=== TEST 9: re_tests:792
--- re: ab\z
--- s eval: "b\nca\n"



=== TEST 10: re_tests:793
--- re: ab$
--- s eval: "b\nca\n"



=== TEST 11: re_tests:795
--- re: ab\z
--- s eval: "b\nca"



=== TEST 12: re_tests:796
--- re: ab$
--- s eval: "b\nca"



=== TEST 13: re_tests:798
--- re: abb\z
--- s eval: "abb\nb\n"



=== TEST 14: re_tests:799
--- re: abb$
--- s eval: "abb\nb\n"



=== TEST 15: re_tests:801
--- re: abb\z
--- s eval: "b\nabb\n"



=== TEST 16: re_tests:802
--- re: abb$
--- s eval: "b\nabb\n"



=== TEST 17: re_tests:804
--- re: abb\z
--- s eval: "b\nabb"



=== TEST 18: re_tests:805
--- re: abb$
--- s eval: "b\nabb"



=== TEST 19: re_tests:807
--- re: abb\z
--- s eval: "abb\nb\n"



=== TEST 20: re_tests:808
--- re: abb$
--- s eval: "abb\nb\n"



=== TEST 21: re_tests:810
--- re: abb\z
--- s eval: "b\nabb\n"



=== TEST 22: re_tests:811
--- re: abb$
--- s eval: "b\nabb\n"



=== TEST 23: re_tests:813
--- re: abb\z
--- s eval: "b\nabb"



=== TEST 24: re_tests:814
--- re: abb$
--- s eval: "b\nabb"



=== TEST 25: re_tests:816
--- re: abb\z
--- s eval: "ac\nb\n"



=== TEST 26: re_tests:817
--- re: abb$
--- s eval: "ac\nb\n"



=== TEST 27: re_tests:819
--- re: abb\z
--- s eval: "b\nac\n"



=== TEST 28: re_tests:820
--- re: abb$
--- s eval: "b\nac\n"



=== TEST 29: re_tests:822
--- re: abb\z
--- s eval: "b\nac"



=== TEST 30: re_tests:823
--- re: abb$
--- s eval: "b\nac"



=== TEST 31: re_tests:825
--- re: abb\z
--- s eval: "ac\nb\n"



=== TEST 32: re_tests:826
--- re: abb$
--- s eval: "ac\nb\n"



=== TEST 33: re_tests:828
--- re: abb\z
--- s eval: "b\nac\n"



=== TEST 34: re_tests:829
--- re: abb$
--- s eval: "b\nac\n"



=== TEST 35: re_tests:831
--- re: abb\z
--- s eval: "b\nac"



=== TEST 36: re_tests:832
--- re: abb$
--- s eval: "b\nac"



=== TEST 37: re_tests:834
--- re: abb\z
--- s eval: "ca\nb\n"



=== TEST 38: re_tests:835
--- re: abb$
--- s eval: "ca\nb\n"



=== TEST 39: re_tests:837
--- re: abb\z
--- s eval: "b\nca\n"



=== TEST 40: re_tests:838
--- re: abb$
--- s eval: "b\nca\n"



=== TEST 41: re_tests:840
--- re: abb\z
--- s eval: "b\nca"



=== TEST 42: re_tests:841
--- re: abb$
--- s eval: "b\nca"



=== TEST 43: re_tests:843
--- re: abb\z
--- s eval: "ca\nb\n"



=== TEST 44: re_tests:844
--- re: abb$
--- s eval: "ca\nb\n"



=== TEST 45: re_tests:846
--- re: abb\z
--- s eval: "b\nca\n"



=== TEST 46: re_tests:847
--- re: abb$
--- s eval: "b\nca\n"



=== TEST 47: re_tests:849
--- re: abb\z
--- s eval: "b\nca"



=== TEST 48: re_tests:850
--- re: abb$
--- s eval: "b\nca"



=== TEST 49: re_tests:851
--- re: (^|x)(c)
--- s eval: "ca"



=== TEST 50: re_tests:852
--- re: a*abc?xyz+pqr{3}ab{2,}xy{4,5}pq{0,6}AB{0,}zz
--- s eval: "x"



