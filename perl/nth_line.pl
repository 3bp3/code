#!/usr/bin/perl

use warnings;


$number = shift @ARGV;
open F, "<", "$ARGV[0]";



$count = 1;
while($line = <F>){
	if ($number == $count){
		print $line;
		last;
	}
	$count ++;
}
