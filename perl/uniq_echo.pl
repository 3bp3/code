#!/usr/bin/perl
use warnings;

foreach $word (@ARGV){
	if (defined $occur{$word}){
		next;
	}else{
		$occur{$word}++;
		print "$word ";
	}
}
print "\n";
