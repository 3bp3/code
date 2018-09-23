#!/bin/bash


for file in "$@"
do	
	for name in ` egrep '^#include "' "$file" | sed 's/#include "//g' | sed 's/".*//g' `
	do
		if test ! -e "$name"
		then
			echo "$name" included into "$file" does not exist
		fi
	done
done
