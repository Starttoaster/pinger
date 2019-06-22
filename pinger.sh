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
function checkString {
	# Set base value
        isIP=true
	# Checks to see if a string has http or www, if they don't then it's assumed to be a localnet hostname.
        if ! [[ "$i" =~ "http" ]] || [[ "$i" =~ "www" ]]; then
		isIP=true
	else
		isIP=false
	fi

	#Runs pingIt if IP, curlIt if not IP
	if [ "$isIP" = "true" ]; then
		methods+=( "ping" )
		pingIt
	else
		methods+=( "cURL" )
		curlIt
	fi
	
}
function pingIt {
        result="$(ping -w 1 -c 1 "$i" &> /dev/null ; echo "$?")"
        if [ "$result" = "0" ]; then
                results+=( "$online" )
                timeout["$counter"]=""
        else
		results+=( "$offline" )
                if [ -z "${timeout["$counter"]}" ]; then
			timeout["$counter"]="$(date +"%T")"
                fi
        fi
}
function curlIt {
	curlreq="$(curl --silent --output /dev/null --max-time 1 --show-error --fail "$i" 2>&1)"
        if [ -z "$curlreq" ]; then
	        results+=( "$online" )
                timeout["$counter"]=""
	else
		results+=( "$offline" )
		if [ -z "${timeout["$counter"]}" ]; then
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
	        hosts+=( "$host" )
	fi
done
while true; do
	unset results
	unset timer
	unset methods
	counter=0
	for i in "${hosts[@]}"; do
		checkString
		((counter++))
	done
	downtime
	clear
	printf '%-25s: %-10s: %-10s: %s\n' "Hostname" "Status" "Method" "Timer"
	for ((i=0; i<${#hosts[@]}; i++)); do
		printf '%-25s: %-21s: %-10s: %s\n' "${hosts[i]}" "${results[i]}" "${methods[i]}" "${timer[i]}"
	done
done
