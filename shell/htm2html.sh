#!/bin/bash



for file in *
do
	if [ "${file: -3}" = 'htm' ]
	then
		if test -e "$file"l
		then
			echo "$file"l exists
			exit 1	
		else
			mv "$file" "${file::-4}".html
		fi
	fi
done

