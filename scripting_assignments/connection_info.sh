#!/bin/bash

#Set parameters
filter=$1
number=$2
info=$3

#Check count of accepted parameters
if [ $# -ne 3 ]
then
	echo "This script needs three parameters for work! Please, enter following parameters!"
	read -p "Enter PID of connection or application, which establishet connection, or connection status: " filter
	read -p "Enter max number of unique connections you want to see at display: " number
	read -p "What type of information about connection your looking for (Organization for e.g.): " info 
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
elif [ "$number" -gt 50 ] 
then 
	echo "Your number is too big!"
	exit 1
elif [ ! "$info" ]
then
	echo "Sorry, I don't know what are you waiting for("
	exit 1
fi

#Check for package whios is installed on system
dpkg --get-selections | grep whios &> /dev/null
if [ ! "$?" ]
then
	sudo apt install -y whois
fi
i=1

#Create list of unique connections
ip_string=$(sudo netstat -tunapl | grep -i $filter | awk  ' {print $5}' | cut -d: -f1 | sort | uniq -c | sort | tail -n$number)


for ip in $ip_string
do
	if [ $(expr $i % 2) -eq 0 ]
	then 
		whois "$ip" | grep -i "$info" | awk -F':' ' {print $2}' #Display information
	fi
	i=$(expr $i + 1)
done
