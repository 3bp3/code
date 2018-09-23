#!/bin/bash


if [ "$#" -gt 0 ]
then
	for file in "$@"
	do
		while read line
		do
			echo "$line"
		done < "$file"
	done	

else
	while read line
	do
		echo "$line"
	done
fi
