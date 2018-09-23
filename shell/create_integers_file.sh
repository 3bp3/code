#!/bin/bash


i=$1
while test "$i" -le "$2"
do
	echo "$i" >> "$3"
	i=$(($i + 1))
done
