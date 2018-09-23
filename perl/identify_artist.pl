#!/usr/bin/perl

use warnings;
#use strict;
$option = 0;
if (grep (/^-d$/, @ARGV)){
	$option = 1;
	@ARGV = grep (!/^-d$/, @ARGV);
}

#get the total words in lyrics file and save it to hash %total
foreach $file (glob "lyrics/*.txt"){
	open F, "<", "$file" or die "Can not open $file: $!\n";
	($author) = ($file =~ /\/([\w]+)\.txt/);
	$author =~ tr /_/ /;
	while ( $line = <F> ){
		chomp $line;
		$line =~ s/[^A-Za-z]+/ /g;
		$line =~ s/^ //g;
		$total{$author}+= split / /, $line;
	}
}


foreach $song (@ARGV){
	open FILE, "<", "$song" or die "Can't open $song $!\n";

	while ($line = <FILE>){
		$line = lc $line;						#convert to lower case character
		$line =~ s/[^A-Za-z]+/ /g;		#replace all the non-alphabetic charecters to space
		$line =~ s/^ //g;
		@words = split / /, $line;				#remove space at the beginning
		next if (! @words);
		foreach $word (@words){
			foreach $file (glob "lyrics/*.txt") {
			    ($author) = ($file =~ /\/([\w]+)\.txt/);
			    $author =~ tr /_/ /;
				if (! defined $log_prob{$word}{$author}){
			        open F,"<", "$file" or die "Can not open $file: $!\n";
			        while ($line = <F>){
			        	$line = lc $line;						#convert to lower case character
						$line =~ s/[^A-Za-z]+/ /g;		#replace all the non-alphabetic charecters to space
						$line =~ s/^ //g;				#remove space at the beginning	
						@characters = $line =~ /\b$word\b/g;	#match the word, need \b as a wprd boundary
						$freq{$author} += @characters;
					}
					$log_prob{$word}{$author} = log(($freq{$author} + 1)/$total{$author});
					#print "log_prob for $word of $author is $log_prob{$word}{$author}\n";
				}
				$freq{$author} = 0; #clean the %freq for counting the following word frequency
				$probability{$song}{$author} += $log_prob{$word}{$author};
			}
		}
	}

}

foreach $key1 (sort keys %probability){
	@order = sort {$probability{$key1}{$b} <=> $probability{$key1}{$a}} keys %{$probability{$key1}};
	foreach $key2 (@order){
		if ($option){
			printf "%s: log_probability of %.1f for %s\n", $key1, $probability{$key1}{$key2}, $key2;
		}
	}
	printf "%s most resembles the work of %s (log-probability=%.1f)\n", $key1, $order[0], $probability{$key1}{$order[0]};
	#$order[0] is the key of the max value
}	
