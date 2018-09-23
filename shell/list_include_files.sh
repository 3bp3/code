#!/bin/sh


for file in *.c
do
	egrep -o '#include[<"].+[>"]' $file | sed 's/#include[<"]//g' | sed 's/[>"]//g'

done
