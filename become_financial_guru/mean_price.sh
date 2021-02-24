#!/bin/bash

if [ ! $1 ]
then
	count=14
else
count=$1
fi

if [ $count -gt $(jq -c '.prices[]' quotes.json | wc -l) ]
then
	echo "The count of days is greater, than we can take!" 2>&1
	echo "Maximum count is $(jq -c '.prices[]' quotes.json | wc -l)" 2>&1
	count=$(jq -c '.prices[]' quotes.json | wc -l)
fi

cutter(){
	tail -n$count | cut -c 2- | rev | cut -c 2- | rev
}

jq -c '.prices[]' quotes.json | cutter | awk -F"," -v mean=0 '{mean+=$2} END {print mean/NR}'

