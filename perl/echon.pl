#!/usr/bin/perl -w
use strict;

my $number = @ARGV;
if ($number != 2){
	print "Usage: ./echon.pl <number of lines> <string>\n";
	exit;
}

my $times = shift @ARGV;
if ($times !~ m/^[0-9]+$/){
	print "./echon.pl: argument 1 must be a non-negative integer\n";
	exit;
}

for ( 1..$times ){
	print "@ARGV\n";
}

