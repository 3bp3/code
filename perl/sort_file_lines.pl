#!/usr/bin/perl

use warnings;

while ($line = <>){
	chomp $line;
	$len = length $line;
	# print "the length of $line is: $len\n";
	$length{$line} = $len;
}

for $key (sort {$length{$a} <=> $length{$b}} sort keys %length){
	print "$key\n";
}
