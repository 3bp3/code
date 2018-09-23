#!/bin/bash

#set -x
if [ "$#" -eq 0 ]
then
	echo 'Usage: ./tag_music.sh <Directory1> <Directory2> ...'
else
	for directory in "$@"
	do
		find "$directory" -name '*.mp3' | while read file
		do
			parent_dir="$(dirname "$file" | rev | cut -f1 -d'/' | rev | cut -c 1-)"
			#echo "parent dir is: " "$parent_dir"
			id3 -t "$(basename "$file" | sed 's/ \- /$/g' | rev | cut -f2 -d'$' | rev)" "$file" >/dev/null
			id3 -a "$(basename "$file" | sed 's/ \- /$/g' | rev | cut -f1 -d'$' | cut -c 5- | rev)" "$file" >/dev/null
			id3 -A "$parent_dir" "$file" >/dev/null
			id3 -y "$(echo "$parent_dir" | cut -f2 -d',' | tr -d ' ')" "$file" >/dev/null
			id3 -T "$(basename "$file" | cut -f1 -d'-' | tr -d ' ')" "$file" >/dev/null

		done
	done

fi
