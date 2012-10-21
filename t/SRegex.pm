package t::SRegex;


use Test::Base -Base;
use IPC::Run3;
use Cwd;
use Test::LongString;


sub run_test ($);
sub parse_res ($);
sub fmt_cap ($$);


our @EXPORT = qw( run_tests );


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

    my ($res, $err);

    my @cmd = ("./sregex", $re, $s);

    if ($ENV{TEST_SREGEX_USE_VALGRIND}) {
        @cmd =  ('valgrind', '-q', '--leak-check=full', @cmd);
    }

    run3 \@cmd, undef, \$res, \$err;

    #warn "res:$res\nerr:$err\n";

    if (defined $block->err) {
        $err =~ /.*:.*:.*: (.*\s)?/;
        $err = $1;
        is $err, $block->err, "$name - err expected";

    } elsif ($?) {
        die "Failed to execute --- re for test $name: $err\n";

    } else {
        if ($err) {
            warn "$err\n";
        }

        #is $res, $block->out, "$name - output ok";
        if (!defined $res) {
            is_string $res, $block->out, "$name - output ok";

        } else {

            my ($thompson_match, $pike_match, $pike_cap) = parse_res($res);

            if ($ENV{TEST_SREGEX_VERBOSE}) {
                warn "thompson: $thompson_match, pike: $pike_match, cap: $pike_cap\n";
                warn $res;
            }

            if ($s =~ m/$re/) {
                my $expected_cap = fmt_cap(\@-, \@+);

                ok($thompson_match, "thompson vm should match");
                ok($pike_match, "pike vm should match");
                is($pike_cap, $expected_cap, "pike vm capture ok");

            } else {
                ok(!$thompson_match, "thompson vm should not match");
                ok(!$pike_match, "thompson vm should not match");
            }
        }
    }
}


sub parse_res ($) {
    my $res = shift;
    open my $in, '<', \$res or die $!;

    my ($thompson_match, $pike_match, $pike_cap);

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
            }

        } elsif (/^pike (.+)/) {
            my $res = $1;

            if (defined $pike_match) {
                warn "duplicate thompson result: $_";
                next;
            }

            if ($res eq 'no match') {
                $pike_match = 0;

            } elsif ($res =~ /^match (.+)/) {
                $pike_cap = $1;
                $pike_match = 1;

                $pike_cap =~ s/( \(-1, -1\))+$//g;

            } else {
                warn "unknown pike result: $res\n";
            }
        }
    }

    return ($thompson_match, $pike_match, $pike_cap);
}


sub fmt_cap ($$) {
    my ($from, $to) = @_;

    my $len = @$from;
    my @caps;
    for (my $i = 0; $i < $len; $i++) {
        my $f = $from->[$i];
        my $t = $to->[$i];
        push @caps, "($f, $t)";
    }

    return join " ", @caps;
}


1;
