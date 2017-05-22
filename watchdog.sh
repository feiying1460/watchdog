#!/usr/local/bin/bash

#  watchdog.sh
#  Reboots a router via telnet when internet connectivity tests fail.
#
#  by Kirk Coombs (kcoombs@coombscloud.com)
#  Version 1.0 (May 19, 2017)
#    - Initial release

let COUNT=0
let REBOOT=0

while [ 1 ]
do

	echo ""
	echo $(date)
	echo "Performing Network Tests..."
	eval "host google.com" > /dev/null 2>&1
	let GOOGLE_FWDNS=$?

	eval "host 8.8.8.8" > /dev/null 2>&1
	let GOOGLE_RVDNS=$?

	eval "ping -c5 google.com" > /dev/null 2>&1
	let GOOGLE_PING=$?
	
	echo "Checking Results..."
	if [ "$GOOGLE_FWDNS" -ne "0" -a "$GOOGLE_RVDNS" -ne "0" -a "$GOOGLE_PING" -ne "0" ]; then
		
		echo "Tests failed with count $COUNT"
		COUNT=$((COUNT + 1))

		if [ "$COUNT" -gt "2" ]; then
			
			echo "Tests failed and count has reached $COUNT. Rebooting Modem..."
			eval "/home/USER/expect.sh"
			
			echo "Sleeping for three minutes to let the modem come back up..."
			sleep 180
						
			REBOOT=$((REBOOT + 1))

		fi

	elif [ "$COUNT" -ne "0" ]; then
		
		echo "Tests passed, but count is $COUNT. Resetting count."
		let COUNT=0
		
		if [ "$REBOOT" -gt "0" ]; then

			echo "Modem has been rebooted and network is up again. Sending e-mail notifications."
			eval echo "Network back up at $(date), after rebooting the modem $REBOOT times." | /usr/bin/mail -s "RPI Watchdog Triggered" user@example.com		
			
			let REBOOT=0

		fi
	
	else

		echo "Tests passed."

	fi

	if [ "$REBOOT" -gt "10" ]; then
		echo "Hmm... Modem reboot has been issued $REBOOT times and the network remains down. Sleeping for an hour."
		sleep 3600
	fi
	
	echo "Sleeping..."
	sleep 300

done
