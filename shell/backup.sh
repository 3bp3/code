#!/bin/bash

if [ "$#" -ne 1 ]
then
	echo "Usage: ./backup.sh <filename>"
fi

count=0

while test -e ".${1}.$count"
do
	count=$(($count+1))
done
#echo ".${1}.$count"
cp "$1" ".${1}.$count"
echo "Backup of '$1' saved as '.${1}.$count'"