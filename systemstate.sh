#!/bin/bash

#//var directory threshhold percentage

THRESHOLD=85
PARTITION="/var"

#Get the current usage

USAGE=$(df -h "$PARTITION" | awk 'NR==2 {print $5}' | tr -d '%')


if [ "$USAGE" -ge "$THRESHOLD" ]; then
	echo "WARNING: $PARTITION currently at ${USAGE}% full!"
	# mail -s "Disk Alert: $PARTITION" user@example.com <<< "$PARTITION usage is ${USAGE}%"
else 
	echo "$PARTITION currently at ${USAGE}% and below the threshold which is ($THRESHOLD%)"
fi


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

DOCKERSTATUS=$( systemctl status docker | grep active | awk 'NR==1 {print$3}' | tr -d \(\) )

if [ "$DOCKERSTATUS" == "running" ]; then
	echo "Docker is currently in a $DOCKERSTATUS state"
else
	echo "Docker is currently in a $DOCKERSTATUS state"
fi


ZOMBIE=$(ps -eo stat | grep Z | wc -l)

if [ "$ZOMBIE" -gt 0 ]; then
	echo "Curerntly $ZOMBIE processes in a zombie state"
fi


