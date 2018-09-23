#!/usr/bin/perl -w
#

use strict;

my @files;
my $number = 10;


foreach my $arg (@ARGV){
	if ($arg eq "--version"){
		print "$0: version 0.1\n";
		exit 0;
	}elsif($arg =~ m/^-[0-9]+$/){
		$arg =~ tr /-//d;
		$number = $arg;
	}else{
		push @files, $arg;
	}
}

#tail from std input: use <C>+d to end the stdin.
#if number greater than number of lines in stdin, print out all the lines
#else print the tail

if (!@files){
	my @content = <STDIN>;
	if ($number >= $#content+1){
		print @content;
	}else{
		for my $i ($#content+1-$number..$#content){
			print $content[$i];
		}
	}
}

my @line;

#if one file,just print; else print '==>' etc
foreach my $file (@files){
	open F, '<', $file or die "$0: Can't open $file: $!\n";
	
	#read file to an array
	if (@files == 1){
		@line = <F>;
	}else{
		@line = <F>;
		print "==> $file <==\n";
	}

	if ($number >= $#line+1){
		print @line;
	}else{
		foreach my $i ($#line+1-$number..$#line) {
			print $line[$i]			
		}
	}
	close F;
}
