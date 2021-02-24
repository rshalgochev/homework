#!/bin/bash


#Set parameters
filter=$1
number=$2
info=$3

#Define function for sorting unique addresses
sorter(){
	sort | uniq -c | sort | awk '{print $2}' | tail -n$(( $number + 1 ))
}


#Check count of accepted parameters
if [ $# -ne 3 ]
then
	read -p "Enter first parameter: " filter
	read -p "Enter second parameter: " number
	read -p "Enter third parameter: " info 
fi

#Check parameters
if [ ! "$filter" ] 
then
	echo "You must enter PID or application first!"
	exit 1
elif (echo "$number" | grep -qP '(\D+)') 
then 
	echo "Number must be only digit!"
	exit 1
elif [ "$number" -gt $(sudo netstat -tunapl | wc -l) ] 
then 
	echo "Your number is too big!" 2>&1
elif [ ! "$info" ]
then
	echo "Sorry, I don't know what are you waiting for("
	exit 1
fi


#Create list of unique connections

ip_string=$(sudo netstat -tunapl | awk '$0~$filter {print $5}'  | awk -F":" '{print $1}'| sorter)


for ip in $ip_string
do
	if [ "$ip" = "Address" ]
	then 
		continue
	else
		whois "$ip" | awk -F':' '$0~$info {print $2}' #Display information 
	fi
done
