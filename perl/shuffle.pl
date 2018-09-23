#!/usr/bin/perl -w


use strict;


my @lines = <STDIN>;
my $number = $#lines;
my @usednumber;
chomp $number;

for my $i (0..$#lines){
	while (1){
		$number = rand($#lines);
		$number =~ s/\.[0-9]*//;
		print "number is $number\n";
		if ( grep{ $_ = $number } @usednumber ){
			print "used numbers are: @usednumber\n";
			print "already exitsts";
			next;
		}else{
			push @usednumber, $number;
			print $lines[$number];
			last;
		}
	}

}
