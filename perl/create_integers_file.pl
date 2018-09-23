#!/usr/bin/perl

use warnings;
#use strict;

@ARGV == 3 or die "Usage: ./create_integers.pl <start number> <end number> <file>";
open F, ">", $ARGV[2];
for $i ($ARGV[0]..$ARGV[1]){
	print F "$i\n";
}
