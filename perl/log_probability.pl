#!/usr/bin/perl

use warnings;
#use strict;
$word = shift @ARGV;
$word = lc $word;


foreach $file (glob "lyrics/*.txt") {
        ($author) = ($file =~ /\/([\w]+)\.txt/);
        $author =~ tr /_/ /;
        open F,"<", "$file" or die "Can not open $file: $!\n";
        while ($line = <F>){
        	$line = lc $line;						#convert to lower case character
			$line =~ s/[^A-Za-z]+/ /g;		#replace all the non-alphabetic charecters to space
			$line =~ s/^ //g;				#remove space at the beginning	
			@words = $line =~ /\b$word\b/g;	#match the word, need \b as a wprd boundary
			$total{$author} += (split / /, $line);
			# foreach $chr (split / /, $line){
			# 	$total{$author} ++;
			# }
			$freq{$author} += @words;		
        }
        $log_prob{$author} = log(($freq{$author} + 1)/$total{$author});

        printf "log((%d+1)/%6d) = %8.4f %s\n", $freq{$author}, $total{$author}, $log_prob{$author}, $author;

}

