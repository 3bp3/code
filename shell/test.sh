#!/bin/bash

string=`cat song2.txt | tr 'A-Z' 'a-z' | sed 's/[^a-z]/ /g' | tr -d '\n'`

for i in {1..30}
do
	./log_probability.pl `echo $string | cut -f $i -d' '` 
	echo $string | cut -f $i -d' '
done
