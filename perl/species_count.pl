#!/usr/bin/perl

use warnings;
use strict;
my %pod_count = ();
my %indv_count = ();
my @number;
my $filename = pop @ARGV;
my $species_name = join(" ", @ARGV);



open F, '<', $filename or die "Open failed\n";
my @lines = <F>;
for my $line (@lines){
	if ($line =~ m/$species_name/ ){
		$pod_count{$species_name}++;
		@number = split /\s+/, $line, 3;
		$indv_count{$species_name} += $number[1];
	}
}

if (exists $pod_count{$species_name}) {
	print "$species_name observations: $pod_count{$species_name} pods, $indv_count{$species_name} individuals\n";
} else {
	print "$species_name not found\n";
}
