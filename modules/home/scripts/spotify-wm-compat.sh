#!/bin/sh

if ! command -v spotify > /dev/null; then
	echo "Spotify is not installed"
	exit 1
fi

if pidof .spotify-wrapped > /dev/null; then
    for wid in $(xdotool search --class spotify | tr '\n' ' '); do
        mars-relay -w "$wid" activate
    done
else
    spotify &
    sleep 0.5
    xids="$(xdotool search --class spotify)"
    while [ -z "$xids" ]; do
        sleep 0.2
        xids="$(xdotool search --class spotify)"
    done
    for xid in $(xdotool search --class spotify); do
	mars-relay -w "$xid" send-to-workspace 7
    done
fi
