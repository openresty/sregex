# vim:set ft= ts=4 sw=4 et fdm=marker:

use t::SRegex 'no_plan';

run_tests();

__DATA__

=== TEST 1: testinput1:6
--- re: the quick brown fox
--- s eval: "the quick brown fox"



=== TEST 2: testinput1:7
--- re: the quick brown fox
--- s eval: "The quick brown FOX"



=== TEST 3: testinput1:8
--- re: the quick brown fox
--- s eval: "What do you know about the quick brown fox?"



=== TEST 4: testinput1:9
--- re: the quick brown fox
--- s eval: "What do you know about THE QUICK BROWN FOX?"



=== TEST 5: testinput1:12
--- re: The quick brown fox
--- s eval: "the quick brown fox"
--- flags: i



=== TEST 6: testinput1:13
--- re: The quick brown fox
--- s eval: "The quick brown FOX"
--- flags: i



=== TEST 7: testinput1:14
--- re: The quick brown fox
--- s eval: "What do you know about the quick brown fox?"
--- flags: i



=== TEST 8: testinput1:15
--- re: The quick brown fox
--- s eval: "What do you know about THE QUICK BROWN FOX?"
--- flags: i



=== TEST 9: testinput1:18
--- re: abcd\t\n\r\f\a\e\071\x3b\$\\\?caxyz
--- s eval: "abcd\t\n\r\f\a\e9;\$\\?caxyz"



=== TEST 10: testinput1:21
--- re: a*abc?xyz+pqr{3}ab{2,}xy{4,5}pq{0,6}AB{0,}zz
--- s eval: "abxyzpqrrrabbxyyyypqAzz"



=== TEST 11: testinput1:23
--- re: a*abc?xyz+pqr{3}ab{2,}xy{4,5}pq{0,6}AB{0,}zz
--- s eval: "aabxyzpqrrrabbxyyyypqAzz"



=== TEST 12: testinput1:24
--- re: a*abc?xyz+pqr{3}ab{2,}xy{4,5}pq{0,6}AB{0,}zz
--- s eval: "aaabxyzpqrrrabbxyyyypqAzz"



=== TEST 13: testinput1:25
--- re: a*abc?xyz+pqr{3}ab{2,}xy{4,5}pq{0,6}AB{0,}zz
--- s eval: "aaaabxyzpqrrrabbxyyyypqAzz"



=== TEST 14: testinput1:26
--- re: a*abc?xyz+pqr{3}ab{2,}xy{4,5}pq{0,6}AB{0,}zz
--- s eval: "abcxyzpqrrrabbxyyyypqAzz"



=== TEST 15: testinput1:27
--- re: a*abc?xyz+pqr{3}ab{2,}xy{4,5}pq{0,6}AB{0,}zz
--- s eval: "aabcxyzpqrrrabbxyyyypqAzz"



=== TEST 16: testinput1:28
--- re: a*abc?xyz+pqr{3}ab{2,}xy{4,5}pq{0,6}AB{0,}zz
--- s eval: "aaabcxyzpqrrrabbxyyyypAzz"



=== TEST 17: testinput1:29
--- re: a*abc?xyz+pqr{3}ab{2,}xy{4,5}pq{0,6}AB{0,}zz
--- s eval: "aaabcxyzpqrrrabbxyyyypqAzz"



=== TEST 18: testinput1:30
--- re: a*abc?xyz+pqr{3}ab{2,}xy{4,5}pq{0,6}AB{0,}zz
--- s eval: "aaabcxyzpqrrrabbxyyyypqqAzz"



=== TEST 19: testinput1:31
--- re: a*abc?xyz+pqr{3}ab{2,}xy{4,5}pq{0,6}AB{0,}zz
--- s eval: "aaabcxyzpqrrrabbxyyyypqqqAzz"



=== TEST 20: testinput1:32
--- re: a*abc?xyz+pqr{3}ab{2,}xy{4,5}pq{0,6}AB{0,}zz
--- s eval: "aaabcxyzpqrrrabbxyyyypqqqqAzz"



=== TEST 21: testinput1:33
--- re: a*abc?xyz+pqr{3}ab{2,}xy{4,5}pq{0,6}AB{0,}zz
--- s eval: "aaabcxyzpqrrrabbxyyyypqqqqqAzz"



=== TEST 22: testinput1:34
--- re: a*abc?xyz+pqr{3}ab{2,}xy{4,5}pq{0,6}AB{0,}zz
--- s eval: "aaabcxyzpqrrrabbxyyyypqqqqqqAzz"



=== TEST 23: testinput1:35
--- re: a*abc?xyz+pqr{3}ab{2,}xy{4,5}pq{0,6}AB{0,}zz
--- s eval: "aaaabcxyzpqrrrabbxyyyypqAzz"



=== TEST 24: testinput1:36
--- re: a*abc?xyz+pqr{3}ab{2,}xy{4,5}pq{0,6}AB{0,}zz
--- s eval: "abxyzzpqrrrabbxyyyypqAzz"



=== TEST 25: testinput1:37
--- re: a*abc?xyz+pqr{3}ab{2,}xy{4,5}pq{0,6}AB{0,}zz
--- s eval: "aabxyzzzpqrrrabbxyyyypqAzz"



=== TEST 26: testinput1:38
--- re: a*abc?xyz+pqr{3}ab{2,}xy{4,5}pq{0,6}AB{0,}zz
--- s eval: "aaabxyzzzzpqrrrabbxyyyypqAzz"



=== TEST 27: testinput1:39
--- re: a*abc?xyz+pqr{3}ab{2,}xy{4,5}pq{0,6}AB{0,}zz
--- s eval: "aaaabxyzzzzpqrrrabbxyyyypqAzz"



=== TEST 28: testinput1:40
--- re: a*abc?xyz+pqr{3}ab{2,}xy{4,5}pq{0,6}AB{0,}zz
--- s eval: "abcxyzzpqrrrabbxyyyypqAzz"



=== TEST 29: testinput1:41
--- re: a*abc?xyz+pqr{3}ab{2,}xy{4,5}pq{0,6}AB{0,}zz
--- s eval: "aabcxyzzzpqrrrabbxyyyypqAzz"



=== TEST 30: testinput1:42
--- re: a*abc?xyz+pqr{3}ab{2,}xy{4,5}pq{0,6}AB{0,}zz
--- s eval: "aaabcxyzzzzpqrrrabbxyyyypqAzz"



=== TEST 31: testinput1:43
--- re: a*abc?xyz+pqr{3}ab{2,}xy{4,5}pq{0,6}AB{0,}zz
--- s eval: "aaaabcxyzzzzpqrrrabbxyyyypqAzz"



=== TEST 32: testinput1:44
--- re: a*abc?xyz+pqr{3}ab{2,}xy{4,5}pq{0,6}AB{0,}zz
--- s eval: "aaaabcxyzzzzpqrrrabbbxyyyypqAzz"



=== TEST 33: testinput1:45
--- re: a*abc?xyz+pqr{3}ab{2,}xy{4,5}pq{0,6}AB{0,}zz
--- s eval: "aaaabcxyzzzzpqrrrabbbxyyyyypqAzz"



=== TEST 34: testinput1:46
--- re: a*abc?xyz+pqr{3}ab{2,}xy{4,5}pq{0,6}AB{0,}zz
--- s eval: "aaabcxyzpqrrrabbxyyyypABzz"



=== TEST 35: testinput1:47
--- re: a*abc?xyz+pqr{3}ab{2,}xy{4,5}pq{0,6}AB{0,}zz
--- s eval: "aaabcxyzpqrrrabbxyyyypABBzz"



=== TEST 36: testinput1:48
--- re: a*abc?xyz+pqr{3}ab{2,}xy{4,5}pq{0,6}AB{0,}zz
--- s eval: ">>>aaabxyzpqrrrabbxyyyypqAzz"



=== TEST 37: testinput1:49
--- re: a*abc?xyz+pqr{3}ab{2,}xy{4,5}pq{0,6}AB{0,}zz
--- s eval: ">aaaabxyzpqrrrabbxyyyypqAzz"



=== TEST 38: testinput1:50
--- re: a*abc?xyz+pqr{3}ab{2,}xy{4,5}pq{0,6}AB{0,}zz
--- s eval: ">>>>abcxyzpqrrrabbxyyyypqAzz"



=== TEST 39: testinput1:51
--- re: a*abc?xyz+pqr{3}ab{2,}xy{4,5}pq{0,6}AB{0,}zz
--- s eval: "*** Failers"



=== TEST 40: testinput1:52
--- re: a*abc?xyz+pqr{3}ab{2,}xy{4,5}pq{0,6}AB{0,}zz
--- s eval: "abxyzpqrrabbxyyyypqAzz"



=== TEST 41: testinput1:53
--- re: a*abc?xyz+pqr{3}ab{2,}xy{4,5}pq{0,6}AB{0,}zz
--- s eval: "abxyzpqrrrrabbxyyyypqAzz"



=== TEST 42: testinput1:54
--- re: a*abc?xyz+pqr{3}ab{2,}xy{4,5}pq{0,6}AB{0,}zz
--- s eval: "abxyzpqrrrabxyyyypqAzz"



=== TEST 43: testinput1:55
--- re: a*abc?xyz+pqr{3}ab{2,}xy{4,5}pq{0,6}AB{0,}zz
--- s eval: "aaaabcxyzzzzpqrrrabbbxyyyyyypqAzz"



=== TEST 44: testinput1:56
--- re: a*abc?xyz+pqr{3}ab{2,}xy{4,5}pq{0,6}AB{0,}zz
--- s eval: "aaaabcxyzzzzpqrrrabbbxyyypqAzz"



=== TEST 45: testinput1:57
--- re: a*abc?xyz+pqr{3}ab{2,}xy{4,5}pq{0,6}AB{0,}zz
--- s eval: "aaabcxyzpqrrrabbxyyyypqqqqqqqAzz"



=== TEST 46: testinput1:60
--- re: ^(abc){1,2}zz
--- s eval: "abczz"



=== TEST 47: testinput1:61
--- re: ^(abc){1,2}zz
--- s eval: "abcabczz"



=== TEST 48: testinput1:62
--- re: ^(abc){1,2}zz
--- s eval: "*** Failers"



=== TEST 49: testinput1:63
--- re: ^(abc){1,2}zz
--- s eval: "zz"



=== TEST 50: testinput1:64
--- re: ^(abc){1,2}zz
--- s eval: "abcabcabczz"



