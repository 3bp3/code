#!/usr/bin/perl

use warnings;
use strict;


my $count = 0;
while ( my $line = <> ){
	chomp $line;
	$line =~ s/[^A-Za-z]+/ /g;
	$line =~ s/^ //g;

	foreach my $words (split(/ /, $line)){
		$count ++;
	}	
}
print "$count words\n";