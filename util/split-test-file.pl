#!/usr/bin/env perl

use strict;
use warnings;

my $infile = shift
    or usage();

if ($infile !~ m{(.*)\.t_?$}) {
    die "Bad input file name: $infile\n";
}

my $base = $1;

open my $in, $infile
    or die "cannot open $infile for reading: $!\n";

my $preamble;
my $parsing;
my $ncases = 0;
my $nfiles = 0;
my $out;

while (<$in>) {
    if (!$parsing) {
        $preamble .= $_;

        if (/^__DATA__$/) {
            $parsing = 1;
        }

        next;
    }

    # parsing

    if (/^=== /) {
        $ncases++;

        if ($ncases % 50 == 1) {
            if (defined $out) {
                close $out;
                undef $out;
            }

            $nfiles++;
            my $suffix = sprintf("%02d", $nfiles);

            my $outfile = "$base-$suffix.t";

            warn "writing $outfile ...\n";

            open $out, ">$outfile"
                or die "cannot open $outfile for writing: $!\n";
            print $out $preamble;
        }

        my $ntests = $ncases % 50 ? $ncases % 50 : 50;
        $_ =~ s/^===\sTEST\s+(\d+)/=== TEST $ntests/g;
        print $out $_;
        next;
    }

    if (!defined $out) {
        #die "syntax error in $infile: $.: $_";
        $preamble .= $_;
        next;
    }

    print $out $_;
}

if (defined $out) {
    close $out;
    undef $out;
}

close $in;

warn "base: $base\n";

sub usage {
    die <<_EOC_;
Usage: $0 <infile>
_EOC_
}

