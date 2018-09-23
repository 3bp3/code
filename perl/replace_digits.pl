#!/usr/bin/perl
use warnings;


@ARGV == 1 or die "Usage: ./replace_digits.pl <filename>";

open F, "<", $ARGV[0]; 
@content = <F>;
for $word (@content){
	$word =~ s/[0-9]/#/g;
}
close F;
open F, ">", $ARGV[0];
print F @content;
close F;
