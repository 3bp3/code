#!/usr/bin/perl

use warnings;

@ARGV >= 2 or die "Usage: ./identical_files.pl <files>\n";
$diff = 0;
open $fprevious, "<", $ARGV[0];
@previous = <$fprevious>;
for $number (1..$#ARGV){
	open $fcurrent, "<", $ARGV[$number];
	@current = <$fcurrent>;
	if (@previous eq @current){
		$diff = 0;
	}else{
		$diff = $number;
		last;
	}
	@previous = @current;
}

if ($diff){
	print "$ARGV[$diff] is not identical\n";
}else{
	print "All files are identical\n";
}
