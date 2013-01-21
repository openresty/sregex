#!/usr/bin/env perl

use strict;
use warnings;
use bigint qw/hex/;

my $user_addr = shift;

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

if ($user_addr) {
    $user_addr = hex($user_addr);
    $user_addr -= $code_start_addr;
    if ($user_addr < 0) {
        die "Bad user addr: $user_addr\n";
    }
}

$line = <$in>;
if ($line ne "global names:\n") {
    die "Bad line: line $.: $line";
}

my %globnames;
while (<$in>) {
    if (/^\s+(\S+) => 0x([a-z0-9]+)$/) {
        my ($name, $addr) = ($1, hex($2));
        $addr -= $code_start_addr;
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
        my $addr = $ofs;
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

my $od_outfile = "a.out";
system("objdump -b binary -D -mi386 -Mx86-64 -Mintel /tmp/thompson-jit.bin > $od_outfile");

open $in, $od_outfile
    or die "Cannot open $od_outfile for reading: $!\n";

my %jmp_addrs;
my $start = 0;
while (<$in>) {
    if (!$start) {
        if (!/^0+ <\.data>:$/) {
            next;
        }

        $start = 1;
        next;
    }

    if (/^\s+([0-9a-f]+):\s+(?:[0-9a-f]{2}\s+)+(.+)/i) {
        my ($pc, $ins) = (hex($1), $2);
        $ins =~ s/\s+$//g;

        if ($pc > $code_size) {
            die sprintf("Bad pc: %x", $pc);
        }

        my $no_label = 1;

        my $labels = $globnames{$pc};
        if ($labels) {
            if ($no_label) {
                undef $no_label;
                print "\n";
            }

            for my $label (@$labels) {
                print "->$label:\n";
            }
        }

        $labels = $pclabels{$pc};
        if ($labels) {
            if ($no_label) {
                undef $no_label;
                print "\n";
            }

            for my $label (@$labels) {
                print "=>$label:\n";
            }
        }

        $ins =~ s/\b\w{2,4}\b/$regs{"$&"} || "$&"/ge;

        if ($ins !~ /^\s*cmp\s+C,/) {
            $ins =~ s/(?<!\+)0x([0-9a-f]+)\b/to_label("$1") || $&/eg;
        }

        $ins =~ s/\b0xfffffffffffffffe\b/-2/g;
        $ins =~ s/\b0xffffffffffffffff\b/-1/g;
        $ins =~ s/\b0xfffffffffffffffb\b/-5/g;

        if ($ins =~ /^\s*j(?:n?e|n?z|[glab]e?|mp)\s+0x([0-9a-f]+)/) {
            my $addr = hex($1);
            #warn "jmp addr: $addr\n";
            $jmp_addrs{$addr} = 1;
        }

        if (defined $jmp_addrs{$pc}) {
            #warn sprintf("testing %x against $prev_jmp_addr\n", $pc, $prev_jmp_addr);
            printf("0x%x:\n", $pc);
        }

        if (defined $user_addr && $pc == $user_addr) {
            printf("USER ADDR 0x%x:\n", $pc);
        }

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

