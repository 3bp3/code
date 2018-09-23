#!/bin/bash

for jpg in *
do
	test -d "$jpg" && continue
	if [ ${jpg: -3} = 'jpg' ]
	#watch out the space after :, choose the last three
	then
		if test -e "${jpg::-4}.png"
		#choose from beginning to last four
		then
			echo "${jpg::-4}.png" already exists
		else
			convert "$jpg" "${jpg::-4}.png"
		fi
	fi
done
