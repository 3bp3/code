#!/usr/bin/perl 

use warnings;

while ($line = <>){
	chomp $line;
	@sorted_line = sort split / +/, $line;
	print join " ", @sorted_line,"\n";
}