#!/bin/bash
source_file=./quotes.json
count=14
i=1
jq -r '.prices[][]' $source_file | tail -n"$count" #| awk -v mean=0 '{mean+=$1} END {print mean/14}')
while read line
do
	if [ $(expr $i % 2) -eq 0 ]
	then 
			
	echo $line  #| awk -v mean=0 '{mean+=$1} END {print mean/14}'
	fi
	i=$(expr $i + 1)
done
