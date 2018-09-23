#!/usr/bin/perl
use warnings;

while ($line = <>){
	#comment line
	$line =~ s/^#![\/a-z]+/#!\/usr\/bin\/perl -w/g;
	# do -> empty
	# done -> }	
	# then ->empty
	# fi -> }
	# else -> } eles {
	#(()) -> empty
	$line =~ s/^( *)(do|then)$/$1\{/g;
	$line =~ s/^( *)(done|fi)$/$1\}/g;
	$line =~ s/^( *)else/$1\} else \{/g;
	$line =~ s/(\(\(|\)\))//g;
	print $line;
}