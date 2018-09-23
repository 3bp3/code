#!/bin/bash

if [ $# -eq 1 ]
then
	first=1
	step=1
	last=$1
elif [ $# -eq 2 ]
then
	first=$1
	step=1
	last=$2
elif [ $# -eq 3 ]
then
	first=$1
	last=$3
	step=$2
else
	echo "Usage: ./seq.sh <first> <last> <step>\n"
fi

i=$first

while [ $i -le $last ]
do
	echo $i
	i=$((i+step))
	#i=`expr $i + $step`
done
