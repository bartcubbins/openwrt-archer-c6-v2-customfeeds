#!/bin/sh
# SPDX-License-Identifier: MIT
# Copyright (C) 2025 Pavel Dubrova <pashadubrova@gmail.com>

. /lib/functions.sh

board=$(board_name)

case "$board" in
tplink,archer-c6-v2|\
tplink,archer-c6-v2-us)
	# OK - continue
	;;
*)
	echo "Unsupported board: $board" >&2
	exit 1
	;;
esac

GREEN_LED="/sys/class/leds/green:wan"
RED_LED="/sys/class/leds/amber:wan"

POLL_DELAY=1

RETRY_COUNT=3
RETRY_DELAY=1

PING_HOST="8.8.8.8"

last_state="unknown"

while true; do
	ok=0
	attempt=0
	state="unknown"

	port_status=$(swconfig dev switch0 show | grep port:1 | awk '{print $3}' | cut -d: -f2)
	if [ "$port_status" != "up" ]; then
		state="disconnected"
	else
		while [ $attempt -lt $RETRY_COUNT ]; do
			if ping -c1 -W1 "$PING_HOST" >/dev/null 2>&1; then
				ok=1
				break
			fi
			attempt=$((attempt + 1))
			sleep $RETRY_DELAY
		done

		if [ $ok -eq 1 ]; then
			state="online"
		else
			state="offline"
		fi
	fi

	if [ "$state" != "$last_state" ]; then
		if [ "$state" = "online" ]; then
			echo 0 > $RED_LED/brightness
			echo 1 > $GREEN_LED/brightness
		elif [ "$state" = "offline" ]; then
			echo 0 > $GREEN_LED/brightness
			echo 1 > $RED_LED/brightness
		else
			echo 0 > $GREEN_LED/brightness
			echo 0 > $RED_LED/brightness
		fi
		last_state="$state"
	fi

	sleep $POLL_DELAY
done
