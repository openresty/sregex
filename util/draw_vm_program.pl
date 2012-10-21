#!/usr/bin/env perl

use strict;
use warnings;

use Getopt::Std;

sub usage {
    die <<_EOC_;
Usage: $0 -t <title> <infile>
Example:
    $0 -t 'NFA for the Regex (a*)*' a.txt | neato -Tpng > a.png
_EOC_
}

my %opts;
getopts("ht:", \%opts) or usage();

if ($opts{h}) {
    usage();
}

my $title = $opts{t} or usage();

my $start;
my %match;
my %edges;

my $prog_len = 0;

my $infile = shift or
    die "No input file specified.\n";

open my $in, $infile or
    die "Cannot open file $infile for reading: $!\n";

while (<$in>) {
    next if /^\s*$/;

    if (/^\s*(\d+)\.\s+(\w+)\s*(.*)/) {
        my ($pc, $cmd, $args) = ($1, $2, $3);

        $prog_len++;

        if ($cmd eq 'split') {
            my ($x, $y) = split /\s*,\s*/, $args;
            $edges{$pc} = [[$x, "x"], [$y, "y"]];

        } elsif ($cmd eq 'any') {
            $edges{$pc} = [[$pc + 1, "."]];

        } elsif ($cmd eq 'char') {
            $args =~ s/\\/\\\\/g;
            $args =~ s/'/\\'/g;
            $edges{$pc} = [[$pc + 1, "'$args'"]];

        } elsif ($cmd eq 'match') {
            $match{$pc} = 1;

        } elsif ($cmd eq 'jmp') {
            $edges{$pc} = [[$args, "jmp"]];

        } elsif ($cmd eq 'save') {
            $edges{$pc} = [[$pc + 1, "save $args"]];

        } else {
            die "Unknown opcode: $cmd\n";
        }

    } else {
        die "Unknown instruction: $_";
    }
}

close $in;

print <<"_EOC_";
digraph test {
    graph [ratio=auto];
    labelloc="t";
    label="$title";
    node [label="\\N", fillcolor=yellow, shape=circle, style=filled, width=0.5, height=0.5];
    edge [color=red];

_EOC_

for (my $pc = 0; $pc < $prog_len; $pc++) {
    if ($match{$pc}) {
        print qq{    node$pc [label="$pc", shape=doublecircle];\n};

    } else {
        print qq{    node$pc [label="$pc"];\n};
    }
}

print <<'_EOC_';

    entry [label="entry", shape=plaintext, fillcolor=white, color=white];
    entry -> node0;
_EOC_

while (my ($from, $arcs) = each %edges) {
    for my $arc (@$arcs) {
        my ($to, $label) = @$arc;
        $label =~ s/\\/\\\\/g;
        $label =~ s/"/\\"/g;
        print qq{    node$from -> node$to [label="$label"]\n};
    }
}

print <<'_EOC_';
}
_EOC_

