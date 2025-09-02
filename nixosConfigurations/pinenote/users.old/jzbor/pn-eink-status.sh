#!/bin/sh

get_display () {
	performance_bit="$(dbus-send --system --print-reply --dest=org.pinenote.ebc /ebc org.pinenote.ebc.GetDclkSelect 2>/dev/null | tail -n 1 | sed 's/^\s*byte //')"
	mode_bit="$(dbus-send --system --print-reply --dest=org.pinenote.ebc /ebc org.pinenote.ebc.GetDefaultWaveform 2>/dev/null | tail -n 1 | sed 's/^\s*byte //')"

	performance_val="?"
	case "$performance_bit" in
		0) performance_val="q";;
		1) performance_val="p";;
	esac

	mode_val="???"
	case "$mode_bit" in
		0) mode_val="RESET";;
		1) mode_val="A2";;
		2) mode_val="DU";;
		3) mode_val="DU4";;
		4) mode_val="GC16";;
		5) mode_val="GCC16";;
		6) mode_val="GL16";;
		7) mode_val="GLR16";;
		8) mode_val="GLD16";;
	esac

	echo "$mode_val/$performance_val"
}

get_display

dbus-monitor --system "interface='org.pinenote.ebc'" | while read -r; do
	get_display
done
