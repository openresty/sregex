#!/usr/bin/env perl

use strict;
use warnings;

my $infile = "abc.txt";
open my $in, ">$infile" or
    die "Cannot open $infile for writing: $!\n";
print $in "abccc" x (1024 * 500) . "aaabbccb";
close $in;

