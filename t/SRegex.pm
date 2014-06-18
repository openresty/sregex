package t::SRegex;


use 5.016002;
use bytes;
use Test::Base -Base;
use IPC::Run3;
use Cwd;
use Test::LongString;


sub run_test ($);
sub parse_res ($);
sub fmt_cap ($$);


our @EXPORT = qw( run_tests );

our $UseValgrind = $ENV{TEST_SREGEX_USE_VALGRIND};
our $ForceMultiRegexes = $ENV{TEST_SREGEX_FORCE_MULTI_REGEXES};

sub run_tests {
    for my $block (blocks()) {
        run_test($block);
    }
}


sub run_test ($) {
    my $block = shift;
    #print $json_xs->pretty->encode(\@new_rows);
    #my $res = #print $json_xs->pretty->encode($res);
    my $name = $block->name;

    my $s = $block->s;
    if (!defined $s) {
        die "No --- s specified for test $name\n";
    }

    my $re = $block->re;
    if (!defined $re) {
        die "No --- re specified for test $name\n";
    }

    if (!ref $re && $ForceMultiRegexes) {
        $re = ['^章亦春$', $re];
    }

    my $flags = $block->flags;

    #warn "flags: $flags\n";

    my ($prefix, @opts);
    if ($flags) {
        $prefix = "(?$flags)";
        #warn "prefix: $prefix\n";
        push @opts, "--flags", $flags;

    } else {
        $prefix = "";
    }

    if (ref $re) {
        push @opts, "-n", scalar @$re;

        if ($flags && @$re == 2 && $re->[0] eq '^章亦春$') {
            push @opts, "--flags", " $flags";
        }
    }

    my ($res, $err);

    my $stdin = bytes::length($s) . "\n$s";

    my @cmd = ("./sregex-cli", "--stdin", @opts, ref $re ? @$re : $re);

    if ($UseValgrind) {
        warn "$name\n";
        @cmd =  ('valgrind', '--gen-suppressions=all',
                 '--suppressions=valgrind.suppress',
                 '--show-possibly-lost=no', '-q', '--leak-check=full', @cmd);
    }

    run3 \@cmd, \$stdin, \$res, \$err;

    #warn "res:$res\nerr:$err\n";

    if (defined $block->err) {
        $err =~ /\[error\] .*\n/;
        $err = $&;

        if (ref $re && @$re == 2 && $re->[0] eq '^章亦春$') {
            $err =~ s/regex \d+:\s+//;
        }

        is $err, $block->err, "$name - err expected (regex: \"$re\")";

    } elsif (defined $block->err_like) {
        $err =~ /\[error\] .*\n/;
        $err = $&;

        if (ref $re && @$re == 2 && $re->[0] eq '^章亦春$') {
            $err =~ s/regex \d+:\s+//;
        }

        my $re = $block->err_like;
        like $err, qr/$re/, "$name - err_like expected (regex: \"$re\")";

    } elsif ($?) {
        if (defined $block->fatal) {
            pass("failed as expected");

        } else {
            fail("failed to execute --- re for test $name: $err\n");
            return;
        }

    } else {
        if ($err) {
            if (!defined $block->err) {
                warn "$err\n";

            } else {
                is $err, $block->err, "$name - err ok";
            }
        }

        #is $res, $block->out, "$name - output ok";
        if (!defined $res) {
            is_string $res, $block->out, "$name - output ok";

        } else {

            my ($thompson_match, $jitted_thompson_match, $splitted_jitted_thompson_match,
                $splitted_thompson_match, $pike_match, $pike_cap,
                $splitted_pike_match, $splitted_pike_cap, $splitted_pike_temp_cap,
                $pike_re_id, $splitted_pike_re_id)
                = parse_res($res);

            if ($ENV{TEST_SREGEX_VERBOSE}) {
                my $cap = $pike_cap;
                if (!defined $cap) {
                    $cap = '<undef>';
                }
                if (!defined $pike_match) {
                    $pike_match = '<undef>';
                }
                warn "$name - thompson: $thompson_match, pike: $pike_match, cap: $cap\n";
                warn $res;
            }

            if (ref $re && @$re == 2 && $re->[0] eq '^章亦春$') {
                $re = pop @$re;
            }

            no warnings 'regexp';
            no warnings 'syntax';
            no warnings 'deprecated';

            if (!ref $re && !defined $block->no_match && !defined $block->cap) {
                eval {
                    $s =~ m/$prefix$re/sm;
                };

                if ($@) {
                    fail("$name - bad regex: $re: $@");
                    return;
                }
            }

            if (defined $block->cap || defined $block->no_match) {
                my $expected_cap = $block->cap;

                if (defined $block->no_match) {
                    ok(!$thompson_match, "$name - thompson vm should not match");

                } else {
                    ok($thompson_match, "$name - thompson vm should match");
                }

                SKIP: {
                    skip "Thompson JIT disabled", 1 if $jitted_thompson_match == -1;
                    if (defined $block->no_match) {
                        ok(!$jitted_thompson_match, "$name - jitted thompson vm should not match");
                    } else {
                        ok($jitted_thompson_match, "$name - jitted thompson vm should match");
                    }
                }

                SKIP: {
                    skip "Thompson JIT disabled", 1 if $splitted_jitted_thompson_match == -1;
                    if (defined $block->no_match) {
                        ok(!$splitted_jitted_thompson_match, "$name - splitted jitted thompson vm should not match");

                    } else {
                        ok($splitted_jitted_thompson_match, "$name - splitted jitted thompson vm should match");
                    }
                }

                if (defined $block->no_match) {
                    ok(!$splitted_thompson_match, "$name - splitted thompson vm should not match");
                    ok(!$pike_match, "$name - pike vm should not match");
                } else {
                    ok($splitted_thompson_match, "$name - splitted thompson vm should match");
                    ok($pike_match, "$name - pike vm should match");
                }

                if (defined $block->match_id) {
                    is $pike_re_id, $block->match_id, "$name - pike match id ok";
                }

                if (defined $expected_cap) {
                    if (ref $expected_cap) {
                        like($pike_cap, $expected_cap, "$name - pike vm capture ok");

                    } else {
                        is($pike_cap, $expected_cap, "$name - pike vm capture ok");
                    }
                }

                if (defined $block->no_match) {
                    ok(!$splitted_pike_match, "$name - splitted pike vm should not match");
                } else {
                    ok($splitted_pike_match, "$name - splitted pike vm should match");
                }

                if (defined $block->match_id) {
                    is $splitted_pike_re_id, $block->match_id, "$name - splitted pike match id ok";
                }

                if (ref $expected_cap) {
                    like($pike_cap, $expected_cap, "$name - pike vm capture ok");

                } else {
                    is($splitted_pike_cap, $expected_cap, "$name - splitted pike vm capture ok");
                }

                if (defined $block->temp_cap) {
                    is($splitted_pike_temp_cap, $block->temp_cap, "$name - splitted pike vm temporary capture ok");
                }

            } elsif ($s =~ m/$prefix$re/sm) {
                my $expected_cap = fmt_cap(\@-, \@+);

                #warn "regex: $prefix$re";

                ok($thompson_match, "$name - thompson vm should match");

                SKIP: {
                    skip "Thompson JIT disabled", 1 if $jitted_thompson_match == -1;
                    ok($jitted_thompson_match, "$name - jitted thompson vm should match");
                }

                SKIP: {
                    skip "Thompson JIT disabled", 1 if $splitted_jitted_thompson_match == -1;
                    ok($splitted_jitted_thompson_match, "$name - splitted jitted thompson vm should match");
                }

                ok($splitted_thompson_match, "$name - splitted thompson vm should match");

                ok($pike_match, "$name - pike vm should match");
                is($pike_cap, $expected_cap, "$name - pike vm capture ok");

                ok($splitted_pike_match, "$name - splitted pike vm should match");
                is($splitted_pike_cap, $expected_cap, "$name - splitted pike vm capture ok");

                if (defined $block->temp_cap) {
                    is($splitted_pike_temp_cap, $block->temp_cap, "$name - splitted pike vm temporary capture ok");
                }

            } else {
                ok(!$thompson_match, "$name - thompson vm should not match");

                SKIP: {
                    skip "Thompson JIT disabled", 1 if $jitted_thompson_match == -1;
                    ok(!$jitted_thompson_match, "$name - jitted thompson vm should not match");
                }

                SKIP: {
                    skip "Thompson JIT disabled", 1 if $splitted_jitted_thompson_match == -1;
                    ok(!$splitted_jitted_thompson_match, "$name - splitted jitted thompson vm should not match");
                }

                ok(!$splitted_thompson_match, "$name - splitted thompson vm should not match");
                ok(!$pike_match, "$name - pike vm should not match");
                ok(!$splitted_pike_match, "$name - splitted pike vm should not match");
            }
        }
    }
}


sub parse_res ($) {
    my $res = shift;
    open my $in, '<', \$res or die $!;

    my ($thompson_match, $jitted_thompson_match, $splitted_jitted_thompson_match,
        $splitted_thompson_match, $pike_match, $pike_cap,
        $splitted_pike_match, $splitted_pike_cap, $splitted_pike_temp_cap,
        $pike_re_id, $splitted_pike_re_id);

    while (<$in>) {
        if (/^thompson (.+)/) {
            my $res = $1;

            if (defined $thompson_match) {
                warn "duplicate thompson result: $_";
                next;
            }

            if ($res eq 'match') {
                $thompson_match = 1;

            } elsif ($res eq 'no match') {
                $thompson_match = 0;

            } else {
                warn "unknown thompson result: $res\n";
                $thompson_match = 0;
            }

        } elsif (/^jitted thompson (.+)/) {
            my $res = $1;

            if (defined $jitted_thompson_match) {
                warn "duplicate jitted thompson result: $_";
                next;
            }

            if ($res eq 'match') {
                $jitted_thompson_match = 1;

            } elsif ($res eq 'no match') {
                $jitted_thompson_match = 0;

            } elsif ($res eq 'disabled') {
                $jitted_thompson_match = -1;

            } else {
                warn "unknown jitted thompson result: $res\n";
                $jitted_thompson_match = 0;
            }

        } elsif (/^splitted jitted thompson (.+)/) {
            my $res = $1;

            if (defined $splitted_jitted_thompson_match) {
                warn "duplicate splitted jitted thompson result: $_";
                next;
            }

            if ($res eq 'match') {
                $splitted_jitted_thompson_match = 1;

            } elsif ($res eq 'no match') {
                $splitted_jitted_thompson_match = 0;

            } elsif ($res eq 'disabled') {
                $splitted_jitted_thompson_match = -1;

            } else {
                warn "unknown splitted jitted thompson result: $res\n";
                $splitted_jitted_thompson_match = 0;
            }

        } elsif (/^splitted thompson (.+)/) {
            my $res = $1;

            if (defined $splitted_thompson_match) {
                warn "duplicate splitted thompson result: $_";
                next;
            }

            if ($res eq 'match') {
                $splitted_thompson_match = 1;

            } elsif ($res eq 'no match') {
                $splitted_thompson_match = 0;

            } else {
                warn "unknown splitted thompson result: $res\n";
                $splitted_thompson_match = 0;
            }

        } elsif (/^pike (.+)/) {
            my $res = $1;

            if (defined $pike_match) {
                warn "duplicate pike result: $_";
                next;
            }

            if ($res eq 'no match') {
                $pike_match = 0;

            } elsif ($res =~ /^match (\d+) (.+)/) {
                $pike_re_id = $1;
                $pike_cap = $2;
                $pike_match = 1;

                $pike_cap =~ s/( \(-1, -1\))+$//g;

            } else {
                warn "unknown pike result: $res\n";
            }

        } elsif (/^splitted pike (.+)/) {
            my $res = $1;

            if ($res =~ s/^(?:\s*\[(?:\(-?\d+, -?\d+\))+\](?:\(-?\d+, -?\d+\))?)+\s*//) {
                $splitted_pike_temp_cap = $&;
                $splitted_pike_temp_cap =~ s/^\s+|\s+$//g;
            }

            if (defined $splitted_pike_match) {
                warn "duplicate splitted pike result: $_";
                next;
            }

            if ($res eq 'no match') {
                $splitted_pike_match = 0;

            } elsif ($res =~ /^match (\d+) (.+)/) {
                $splitted_pike_re_id = $1;
                $splitted_pike_cap = $2;
                $splitted_pike_match = 1;

                $splitted_pike_cap =~ s/( \(-1, -1\))+$//g;

            } else {
                warn "unknown splitted pike result: $res\n";
            }
        }

    }

    return ($thompson_match, $jitted_thompson_match, $splitted_jitted_thompson_match,
        $splitted_thompson_match, $pike_match, $pike_cap,
        $splitted_pike_match, $splitted_pike_cap, $splitted_pike_temp_cap,
        $pike_re_id, $splitted_pike_re_id);
}


sub fmt_cap ($$) {
    my ($from, $to) = @_;

    my $len = @$from;
    my @caps;
    for (my $i = 0; $i < $len; $i++) {
        my $f = $from->[$i];
        my $t = $to->[$i];

        if (!defined $f) {
            $f = -1;
        }

        if (!defined $t) {
            $t = -1;
        }
        push @caps, "($f, $t)";
    }

    return join " ", @caps;
}


1;
