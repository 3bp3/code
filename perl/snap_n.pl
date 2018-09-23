#!/usr/bin/perl
use warnings;

$n = $ARGV[0];

while ($line = <STDIN>){
	chomp $line;
	$count{$line}++;
	if ($count{$line} == $n){
		print "Snap: $line\n";
		last;
	}
}