#!/bin/bash

#//var directory threshhold percentage

printf "\n"

echo "****BASIC SYSTEM CHECK****"

printf "\n"


THRESHOLD=85
PARTITION="/var"

#Get the current /var partition storage percentage and warn if needed
USAGE=$(df -h "$PARTITION" | awk 'NR==2 {print $5}' | tr -d '%')


if [ "$USAGE" -ge "$THRESHOLD" ]; then
	echo "WARNING: $PARTITION currently at ${USAGE}% full!"

# mail -s "Disk Alert: $PARTITION" user@example.com <<< "$PARTITION usage is ${USAGE}%"

else 
	echo "$PARTITION currently at ${USAGE}% and below the threshold which is ($THRESHOLD%)"
fi

printf "\n"

#Check the root partition disk usage and warn if critical

ROOTPART="/"

unset USAGE

USAGE=$(df -h "$ROOTPART" | awk 'NR==2 {print$5}' | tr -d '%')

if [ "$USAGE" -ge "$THRESHOLD" ]; then
	echo "WARNING: Root partition currently ${USAGE}% full!"
elif [ "$USAGE" -gt 90 ]; then
	echo "***CRITICAL WARNING*** : \n Root partition currently at ${USAGE}%"
fi

if [ "$USAGE" -le 85 ]; then
	echo "$ROOTPART Partiton usage currently at ${USAGE}%"
fi

printf "\n"

#Check Docekr status according to systecmtl output

DOCKERSTATUS=$( systemctl status docker | grep active | awk 'NR==1 {print$3}' | tr -d \(\) )

if [ "$DOCKERSTATUS" == "running" ]; then
	echo "Docker is currently in a $DOCKERSTATUS state"
else
	echo "Docker is currently in a $DOCKERSTATUS state"
fi

printf "\n"

#Check amount of zombie processes or ignore output if there are none

ZOMBIE=$(ps -eo stat | grep Z | wc -l)

if [ "$ZOMBIE" -gt 0 ]; then
	echo "Curerntly $ZOMBIE processes in a zombie state"
fi

printf "\n"

#Check amount of errors in /var logs and output amount or further investigation

logs=$(find /var/log/*.log)
errors=$(cat $logs | grep -c "error")

echo "Currently $errors errors in /var logs"
echo "Would you like to see these errors in detail ?"

read -p "Y/N" ANSWER

ONLYERROR=$(cat $logs | grep "error")
if [ "$ANSWER" = "Y" ]; then
	echo "$ONLYERROR"
elif [ "$ANSWER" = "N" ]; then
	echo "Will not send errors to stdout"
fi



