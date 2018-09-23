#!/usr/bin/perl -w 

use strict;

while(<>){
	tr /0-4/</;
	tr /6-9/>/;
	print;
}
