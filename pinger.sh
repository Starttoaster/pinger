#!/bin/bash

#
# Pre-Script Declarations
#
shopt -s lastpipe
BATCH="$(cat $1)"
RED=$(tput setaf 1) 
GREEN=$(tput setaf 2) 
NC=$(tput sgr0) 
online="${GREEN}ONLINE$NC" 
offline="${RED}OFFLINE$NC"


#
# Functions
#
function addNewHost {
	hosts+=( "$host" )
}
function pingIt {
	result="$(ping -w 1 -c 1 "$i" &> /dev/null ; echo "$?")"
	if [ "$result" = "0" ]; then
		results+=( "$online" )
		timeout["$counter"]=""
        else
                results+=( "$offline" )
		if [ "${timeout["$counter"]}" = "" ]; then
			timeout["$counter"]="$(date +"%T")"	
		fi
	fi
}
function downtime {
	for i in "${timeout[@]}"; do
		if [ "$i" != "" ]; then
			string=$(date +"%T")
			starttime=$(date -u -d "$i" +"%s")
			currenttime=$(date -u -d "$string" +"%s")
			timedifference=$(date -u -d "0 $currenttime sec - $starttime sec" +"%H:%M:%S")
			timer+=( "$timedifference" )
		else
			timer+=( "" )
		fi
	done
}

#
# Script main
#

echo "$BATCH" | while read -r host; do
	if [ ! -z "$host" ]; then	
		addNewHost
	fi
done
while true; do
	unset results
	unset timer
	counter=0
	for i in "${hosts[@]}"; do
		pingIt
		((counter++))
	done
	downtime

	clear
	for ((i=0; i<${#hosts[@]}; i++)); do
		printf '%-20s: %-20s: %s\n' "${hosts[i]}" "${results[i]}" "${timer[i]}"
	done
done
