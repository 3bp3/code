#!/bin/bash

if [ "$#" -eq 0 ]
then
    echo 'Usage: ./email_image.sh <image name> <image name> ...'
    exit 1
else
    for image in "$@"
    do
        display "$image"
        echo -n 'Address to e-mail this image to? '
        read email_address
        test "$email_address" = '' && continue 
        echo -n 'Message to accompany image? '
        read message
        echo "$message"|mutt -s "${image::-4}!" -e 'set copy=no' -a "$image" -- "$email_address" &&
        echo "$image" sent to "$email_address"

    done

fi
