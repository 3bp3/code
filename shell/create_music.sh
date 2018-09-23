#!/bin/bash



wget -q -O- 'https://en.wikipedia.org/wiki/Triple_J_Hottest_100?action=raw'| egrep '\| style="text.+[0-9]\]' | egrep -o 'Triple J Hottest 100, [0-9]{4}' | while read file
do
	echo "$file" "yes"
done
