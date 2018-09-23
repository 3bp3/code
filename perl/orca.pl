#!/usr/bin/perl

use warnings;
use strict;

my %count = ();
my @number;

my @filename = @ARGV;

#when u read stdin from arguments, the @ARGV will automatically shifted
foreach my $line (<>){
	if ($line =~ m/ Orca/){
		@number = split /\s+/, $line, 3;
		$count{'Orca'} += $number[1];	
	}
}
print $count{'Orca'}," Orcas reported in @filename\n";

