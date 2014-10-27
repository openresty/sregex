#!/usr/bin/env perl

# generate .t file from the testinput* files in the PCRE source tree's
# testdata/ directory.

use strict;
use warnings;

use Getopt::Std;
#use Data::Dumper;

my %opts;
getopts("ho:", \%opts)
    or usage();

if ($opts{h}) {
    usage();
}

my $outfile = $opts{o}
    or die "No -o option specified.\n";

my $start;
my @tests;

my $code_assertions = 0;
my $esc_G = 0;
my $posix_char_classes = 0;
my $esc_p = 0;
my $dup = 0;
my $backref = 0;
my $embedded_modifiers = 0;
my $esc_N = 0;
my $esc_R = 0;
my $esc_x_unicode = 0;
my $esc_o_unicode = 0;
my $esc_Z = 0;
#my $null_char = 0;
my $lookaround = 0;
my $named_cap = 0;
my $branch_reset = 0;
my $postponed = 0;
my $verbs = 0;
my $independent = 0;
my $possessive = 0;
my $conditional = 0;
my $comments = 0;
my $esc_K = 0;
my $esc_g = 0;
my $metaquoting = 0;
my %memo;

my $bang = sprintf "\\%03o", ord "!"; # \41 would not be portable.
my $ffff  = chr(0xff) x 2;
my $nulnul = "\0" x 2;

my $infile = shift
    or usage();

open my $in, $infile
    or die "Cannot open $infile for reading: $!\n";

my ($re, $flags);
while (<$in>) {
    if (!$start) {
        if (!m!^/[^\-]!) {
            next;
        }

        $start = 1;
    }

    next if /^\s*$/;

    if (m{^/--}) {
        undef $start;
        next;
    }

    if (m{^/(.*)/(\S*)}) {
        $re = $1;
        $flags = $2;

        if ($flags =~ /i/) {
            $flags = 'i';

        } else {
            undef $flags;
        }

        next;
    }

    if (m{^/}) {
        undef $start;
        next;
    }

    if (!defined $re) {
        next;
    }

    my $s;
    if (m/^ +(.*)/) {
        $s = $1;

    } else {
        next;
    }

    #print join ", ", @elems, "\n";

    my $key = "$re\0$s\0" . ($flags || "");
    if (exists $memo{$key}) {
        $dup++;
        next;
    }

    $memo{$key} = 1;

    if ($re =~ m{\(\?\{.*?\}\)}) {
        $code_assertions++;
        next;
    }

    if ($re =~ /\(\?[-a-z]+:(.*?)\)|\(\?[-a-z]*\)/) {
        $embedded_modifiers++;
        next;
    }

    if ($re =~ m{\[:\^?\w+:\]}) {
        $posix_char_classes++;
        next;
    }

    if ($re =~ m{\\G}) {
        $esc_G++;
        next;
    }

    if ($re =~ m/\\p\{[^}]+\}|\\p\w/) {
        $esc_p++;
        next;
    }

    if ($re =~ m/\\g?[1-9]\d*|\(\?P=\w+\)|\(\?>\w+\)|\\g\{-\d+\}|\\g-\d+/) {
        $backref++;
        next;
    }

    if ($re =~ m/\\N\{.*?\}/) {
        $esc_N++;
        next;
    }

    if ($re =~ m{\\R}) {
        $esc_R++;
        next;
    }

    if ($re =~ m/\\x{[a-zA-Z0-9]{3,}}/) {
        $esc_x_unicode++;
        next;
    }

    if ($re =~ m/\\o{([0-7]+)}/) {
        my $code = $1;
        if (oct($code) > 255) {
            $esc_o_unicode++;
            next;
        }
    }

    if ($re =~ m{\(\?(?:\=|<!|!|<=).*?\)}) {
        $lookaround++;
        next;
    }

    if ($re =~ m{\(\?>.*?\)}) {
        $independent++;
        next;
    }

    if ($re =~ m{\(\?\([^)]+\).*?\)}) {
        $conditional++;
        next;
    }

    if ($re =~ m{\(\?\?\{.*?\}\)|\(\?[-+]?\d+\)|\(\?R\)}) {
        $postponed++;
        next;
    }

    #if ($re =~ m/\\0{3}|\\0\b|\\x0\b|\\x00/) {
        #$null_char++;
        #next;
    #}

    if ($re =~ m/(?:[\*\+\?]|\{\d+(?:,(?:\d+)?)?\})\+/) {
        $possessive++;
        next;
    }

    if ($re =~ m/\\Z/) {
        $esc_Z++;
        next;
    }

    if ($re =~ m/\\K/) {
        $esc_K++;
        next;
    }

    if ($re =~ m/\(\?['<]\w+['>].*?\)|\(\?P<\w+>.*?\)/) {
        $named_cap++;
        next;
    }

    if ($re =~ m{\(\?\#.*?\)}) {
        $comments++;
        next;
    }

    if ($re =~ m/\(\?\|.*?\)/) {
        $branch_reset++;
        next;
    }

    if ($re =~ m{(?:\\Q|\\E)}) {
        $metaquoting++;
        next;
    }

    if ($re =~ m{\(\*(?:COMMIT|SKIP|PRUNE|ACCEPT|THEN|FAIL|F)\)|\(\?!\)|\(\*(?:THEN|PRUNE|MARK|):.*?\)}) {
        $verbs++;
        next;
    }

    if ($re =~ /\\g/) {
        $esc_g++;
        next;
    }

    my $skip;
    if ($re =~ m{\\N\{def}) {
        $skip = 1;
    }

    my $err;

    eval {
        no warnings 'regexp';
        no warnings 'syntax';
        no warnings 'deprecated';

        "" =~ m/$re/;
    };

    if ($@) {
        $err = 1;
    }

    push @tests, [$re, $flags, $s, $., $err, $skip];
}

close $in;

#print Dumper(\@tests);

open my $out, ">$outfile"
    or die "Cannot open $outfile for writing: $!\n";

print $out <<'_EOC_';
# vim:set ft= ts=4 sw=4 et fdm=marker:

use t::SRegex 'no_plan';

run_tests();

__DATA__

_EOC_

my $n = 0;
for my $test (@tests) {
    my ($re, $flags, $s, $ln, $err, $skip) = @$test;
    $n++;

    if ($s eq '\\') {
        $s = '';

    } else {
        $s =~ s/\\B/\\\\B/g;
        $s =~ s/\\x([\da-f])(?=[^\da-f])/\\x{$1}/gi;
    }

    #$s =~ s/\\$/\\\\/;
    print $out <<_EOC_;
=== TEST $n: $infile:$ln
--- re: $re
--- s eval: "$s"
_EOC_

    if (defined $flags) {
        print $out "--- flags: $flags\n";
    }

    if ($err) {
        print $out "--- err\n[error] syntax error\n";
    }

    if ($skip) {
        print $out "--- SKIP\n";
    }

    if ($re eq '((?:a?)*)*c' && $s eq 'aac   ') {
        print $out "--- cap: (0, 3) (0, 2)\n";
    }

    if ($re eq '(.*(.)?)*' && $s eq 'abcd') {
        print $out "--- cap: (0, 4) (0, 4)\n";
    }

    if (($re eq '[\s]+' || $re eq '\s+') && $s eq '> \x09\x0a\x0c\x0d\x0b<') {
        print $out "--- cap: (1, 6)\n";
    }

    if ($re eq '(a|(bc)){0,0}?xyz' && $s eq 'xyz') {
        print $out "--- cap: (0, 3)\n";
    }

    if ($re eq '(a|)*\d' && $s eq 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa4') {
        print $out "--- cap: (0, 61) (59, 60)\n";
    }

    if ($re eq '([^ab]*)*' && $s eq 'cccc') {
        print $out "--- cap: (0, 4) (0, 4)\n";
    }

    if ($re eq '([^a]*)*' && $s eq 'bbbb') {
        print $out "--- cap: (0, 4) (0, 4)\n";
    }

    if ($re eq '([^a]*)*' && $s eq 'b') {
        print $out "--- cap: (0, 1) (0, 1)\n";
    }

    if ($re eq '([ab]*)*' && $s eq 'bbbb    ') {
        print $out "--- cap: (0, 4) (0, 4)\n";
    }

    if ($re eq '([ab]*)*' && $s eq 'aaaabcde') {
        print $out "--- cap: (0, 5) (0, 5)\n";
    }

    if ($re eq '([ab]*)*' && $s eq 'ababab') {
        print $out "--- cap: (0, 6) (0, 6)\n";
    }

    if ($re eq '([ab]*)*' && $s eq 'b') {
        print $out "--- cap: (0, 1) (0, 1)\n";
    }

    if ($re eq '([ab]*)*' && $s eq 'a') {
        print $out "--- cap: (0, 1) (0, 1)\n";
    }

    if ($re eq '([a]*)*') {
        if ($s eq 'aaaaa ') {
            print $out "--- cap: (0, 5) (0, 5)\n";

        } elsif ($s eq 'a') {
            print $out "--- cap: (0, 1) (0, 1)\n";
        }
    }

    if ($re eq '(abc|)+') {
        if ($s eq 'abcabcabc') {
            print $out "--- cap: (0, 9) (6, 9)\n";

        } elsif ($s eq 'abcabc') {
            print $out "--- cap: (0, 6) (3, 6)\n";

        } elsif ($s eq 'abc') {
            print $out "--- cap: (0, 3) (0, 3)\n";
        }
    }

    print $out "\n";

    if ($n != @tests) {
        print $out "\n\n";
    }
}

close $out;

warn "skipped $code_assertions code assertions, ",
    "$esc_G \\G tests, ",
    "$posix_char_classes POSIX char class tests, ",
    "$esc_p \\p{} tests, ",
    "$backref back-reference tests, ",
    "$embedded_modifiers inlined regex modifier tests, ",
    "$esc_N \\N{} tests, ",
    "$esc_R \\R tests, ",
    "$esc_o_unicode \\o{} for Unicode code point tests, ",
    "$esc_x_unicode \\x{} for Unicode code point tests, ",
    #"$null_char \\0 tests, ",
    "$lookaround look-around tests, ",
    "$esc_Z \\Z tests, ",
    "$esc_K \\K tests, ",
    "$named_cap named captures tests, ",
    "$branch_reset branch-reset tests, ",
    "$postponed postponed subexpression tests, ",
    "$verbs verbs tests, ",
    "$independent independent subexpression tests, ",
    "$conditional conditional subexpression tests, ",
    "$possessive possessive quantifier tests, ",
    "$comments comment tests, ",
    "$metaquoting meta-quoting tests, ",
    "$esc_g \\g tests, ",
    "and $dup duplicate tests.\n";

sub usage {
    die <<_EOC_;
Usage:
    $0 -o <outfile> /path/to/pcre-x.xx/testdata/testinput1
_EOC_
}

