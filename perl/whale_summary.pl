#!/usr/bin/perl

use warnings;
use strict;
my %pod_count = ();
my %indv_count = ();
my @list;
my @lines;


open F, '<', @ARGV or die "open failed!\n";
@lines = <F>;

foreach my $line (@lines){
	@list = split /\s+/, $line, 3;
	chomp $list[2];
	$list[2] =~ tr /A-Z/a-z/; 	#convert captial letters to lower case
	$list[2] =~ s/s$//g;		#remove trailing s
	$list[2] =~ s/  +/ /g;    	#delete extra spaces 
	$list[2] =~ s/\s$//g;		#delete single space at the end of the line
	$list[2] =~ s/^\s//g;		#delete single space in the beginning of the line
	$indv_count{$list[2]} += $list[1];
	$pod_count{$list[2]}++;
}

for my $key (sort keys %pod_count){
	print "$key observations: $pod_count{$key} pods, $indv_count{$key} individuals\n";
}
