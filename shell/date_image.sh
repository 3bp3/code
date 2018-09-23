#!/bin/bash

if [ "$#" -eq 0 ]
then
    echo 'Usage: ./date_image.sh <image name> <image name> ...'
    exit 1
else
    for image in "$@"
    do
        modtime=$(ls -l "$image" | cut -f6,7,8 -d' ')
        convert -gravity south -pointsize 36 -draw "text 0,10 \"$modtime\"" "$image" "$image"

    done

fi
