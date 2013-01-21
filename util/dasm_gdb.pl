#!/usr/bin/env perl

use strict;
use warnings;
use bigint qw/hex/;

my $gdb_outfile = "a.out";
system("gdb --quiet --batch -x a.gdb sregex-cli > $gdb_outfile");

my %regs;
my $dascfile = "src/sregex/sre_vm_thompson_x64.dasc";
open my $in, $dascfile
    or die "Cannot open $dascfile for reading: $!\n";
while (<$in>) {
    if (/^\|\.define\s+(\w+)\s*,\s*(\w+)/) {
        $regs{$2} = $1;

    } elsif (/^\|\.type\s+(\w+)\s*,\s*\w+\s*,\s*(\w+)/) {
        $regs{$2} = $1;
    }
}

close $in;

my $metafile = "/tmp/thompson-jit.txt";
open $in, $metafile
    or die "cannot open $metafile for reading: $!\n";
my $line = <$in>;
my ($code_start_addr, $code_size);
if ($line =~ /^code section: start=0x([0-9a-f]+) len=(\d+)/i) {
    $code_start_addr = hex($1);
    $code_size = $2;
} else {
    die "Bad line: line $.\n";
}

$line = <$in>;
if ($line ne "global names:\n") {
    die "Bad line: line $.: $line";
}

my %globnames;
while (<$in>) {
    if (/^\s+(\S+) => 0x([a-z0-9]+)$/) {
        my ($name, $addr) = ($1, hex($2));
        my $names = $globnames{$addr};
        if (!defined $names) {
            $globnames{$addr} = [$name];

        } else {
            push @$names, $name;
        }

    } else {
        last;
    }
}

$line = <$in>;
if ($line ne "pc labels:\n") {
    die "Bad line: line $.: $line";
}

my %pclabels;
while (<$in>) {
    if (/^\s+(\d+) => (\d+)$/) {
        my ($pclabel, $ofs) = ($1, $2);
        my $addr = $ofs + $code_start_addr;
        #warn sprintf("pc label %d => %x\n", $pclabel, $addr);
        my $labels = $pclabels{$addr};
        if (!defined $labels) {
            $pclabels{$addr} = [$pclabel];

        } else {
            push @$labels, $pclabel;
        }

    } else {
        last;
    }
}
close $in;

open $in, $gdb_outfile
    or die "Cannot open $gdb_outfile for reading: $!\n";

my $prev_jmp_addr;
my $start = 0;
while (<$in>) {
    if (!$start) {
        if (!/^0x[0-9a-f]+ in \?\? \(\)$/) {
            next;
        }

        $start = 1;
        next;
    }

    if (/^run_jitted_thompson \(/) {
        last;
    }

    if (/^=> 0x([0-9a-f]+):\s+(.+)/i) {
        my ($pc, $ins) = (hex($1), $2);
        if ($pc < $code_start_addr && $pc > $code_start_addr + $code_size) {
            die sprintf("Bad pc: %x, code start: %x", $pc, $code_start_addr);
        }
        my $labels = $globnames{$pc};
        if ($labels) {
            for my $label (@$labels) {
                print "->$label:\n";
            }
        }

        $labels = $pclabels{$pc};
        if ($labels) {
            for my $label (@$labels) {
                print "=>$label:\n";
            }
        }

        $ins =~ s/\b(?:0x)?([0-9a-f]+)\b/to_label("$1") || $&/eg;
        $ins =~ s/\b0xfffffffffffffffe\b/-2/g;
        $ins =~ s/\b0xffffffffffffffff\b/-1/g;
        $ins =~ s/\b0xfffffffffffffffb\b/-5/g;

        if (defined $prev_jmp_addr) {
            #warn sprintf("testing %x against $prev_jmp_addr\n", $pc, $prev_jmp_addr);
            if ($pc == hex($prev_jmp_addr)) {
                print "$prev_jmp_addr:\n";
            }
            undef $prev_jmp_addr;
        }

        if ($ins =~ /^j(?:ne|e|z|nz|ge|le|l|g|mp)\s+0x([0-9a-f]+)/) {
            $prev_jmp_addr = $1;
        }

        $ins =~ s/\b\w{2,4}\b/$regs{"$&"} || "$&"/ge;

        print "\t$ins\n";
    }

    #print;
}

close $in;

sub to_label {
    my $raw = shift;
    my $addr = hex($raw);
    my $name;
    my $labels = $pclabels{$addr};
    if ($labels) {
        $name .= "=>@$labels";
    }

    $labels = $globnames{$addr};
    if ($labels) {
        $name .= "->@$labels";
    }

    return $name ? $name : undef;
}

