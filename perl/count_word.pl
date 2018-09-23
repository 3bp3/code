#!/usr/bin/perl

use warnings;
use strict;



@ARGV >= 1 or die "Usage: ./count_word.pl <word> <file>";
my $count = 0;
my $word = shift @ARGV;
$word = lc $word;
my @words;

while (my $line = <>){
	$line =~ tr /A-Z/a-z/;
	$line =~ s/[^A-Za-z]+/ /g;
	$line =~ s/^ //g;

	my @words = $line =~ /\b$word\b/g;
	$count += @words;
	# foreach my $char (split (/ /, $line)){
	# 	if ($char =~ /^$word$/){
	# 		$count++;
	# 	}
	# }
}
print "$word occurred $count times\n";