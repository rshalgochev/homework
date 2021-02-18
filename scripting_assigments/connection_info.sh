#!/bin/bash
#Collect parameters
read -p "Enter PID of connection or application, which establishet connection, or connection status: " filter
read -p "Enter max number of unique connections you want to see at display: " number
read -p "What type of information about connection your looking for (Organization for e.g.): " info 


#Check parameters
if [ ! "$filter" ] 
then
	echo "You must enter PID or application first!"
	exit 1
elif (echo "$number" | grep -qP '(\D+)') 
then 
	echo "Number must be only digit!"
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

#Create list of unique connections
sudo netstat -tunapl | grep -i "$filter" | awk  ' {print $5}' | cut -d: -f1 | sort | uniq -c | sort | tail -n"$number" | grep -oP '(\d+\.){3}\d+' > /tmp/ip_list
while read IP
do 
	whois "$IP" | grep -i "$info" | awk -F':' ' {print $2}' #Display information
done < /tmp/ip_list #Read IP-addresses from list
