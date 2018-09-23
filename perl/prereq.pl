#!/usr/bin/perl

use warnings;
use strict;


@ARGV == 1 or die "Usage: ./prereq.pl [COURSE CODE]\n";

#set the url and its suffix
my $under_url = "http://legacy.handbook.unsw.edu.au/undergraduate/courses/2018/";
my $post_url = "http://legacy.handbook.unsw.edu.au/postgraduate/courses/2018/";
my $suffix = ".html";
my @prereq;

for my $course (@ARGV){
	#check the course code
	($course) =~ /[A-Z]{4}[0-9]{4}/ or die "Invalid course code, please enter again";
	
	$under_url = "$under_url"."$course"."$suffix";
	$post_url = "$post_url"."$course"."$suffix";
	
	#wget the html file from the url
	open F, "-|", "wget -q -O- $under_url $post_url" or die "Can't fetch the website";
	#wget url1 url2

	while (my $line = <F>){
		chomp $line;
		if ($line =~ /Prerequisite/){
			#print "Got you $line\n";
			#need the brackets for the varaiable
			($line) = ($line =~ /<p>Prerequisite[s]*:([^\/]+)<\/p>/);
			#print "now line is:\n";
			#print $line;
			#print "i am here\n";
			(@prereq) = ($line =~ /([A-Z]{4}[0-9]{4})/g);
			#sort can be used in an array
			for my $word (sort @prereq){
				print "$word\n";
			}
		}

	}
}