#!/bin/sh

list_displays () {
	xrandr | grep ' connected ' | cut -f1 -d' ' | paste -s
}

disable_disconnected () {
	for disp in $(xrandr | grep ' disconnected ' | cut -f1 -d' ' | paste -s); do
		xrandr --output "$disp" --auto
	done
}

mirror () {
	first=""
	for disp in $(list_displays); do
		if [ -z "$first" ]; then
			xrandr --output "$disp" --auto
			first="$disp"
		else
			xrandr --output "$disp" --auto --same-as "$first"
		fi
	done
}

extend () {
	prev=""
	for disp in $(list_displays); do
		if [ -z "$prev" ]; then
			xrandr --output "$disp" --auto
		else
			xrandr --output "$disp" --auto --right-of "$prev"
		fi
		prev="$disp"
	done
}

only () {
	if [ -z "$1" ]; then
		echo "Error: no param for only()" >/dev/stderr
	fi

	for disp in $(list_displays); do
		if [ "$disp" != "$1" ]; then
			xrandr --output "$disp" --off
		fi
	done
	xrandr --output "$1" --auto
}

select_layout () {
	selection="$(find ~/.screenlayout -maxdepth 1 -type f -printf "%f\n" | sed 's/\.sh$//' | xmenu)"
	if [ -n "$selection" ]; then
		"$HOME/.screenlayout/$selection.sh"
	fi
}

only_options () {
	for disp in $(list_displays); do
		printf "%s %s=%s " "-A" "$disp" "$disp"
	done
}

ensure_first () {
	first="$(xrandr | grep ' connected ' | cut -f1 -d' ' | head -n 1)"
	xrandr --output "$first" --auto
}

message () {
	displays="$(list_displays)"
	msg="$1"

	if [ -z "$msg" ]; then
		msg="$displays"
	fi

        # shellcheck disable=SC2046
	result="$(notify-send "Monitor Settings" "$msg" -A mirror=mirror -A extend=extend -A select=select $(only_options))"
	case "$result" in
		"") ;;
		"select") select_layout ;;
		"mirror") mirror ;;
		"extend") extend ;;
		*) only "$result" ;;
	esac
	disable_disconnected
}

listen () {
	output=""
	connection=""
	xev -root -event randr \
		| grep --line-buffered 'output \|connection ' \
		| while read -r line; do
			# echo "line: $line"
			case "$line" in
				output*) output="$(echo "$line" | cut -d',' -f1 | cut -d' ' -f2)" ;;
				connection*) connection="$(echo "$line" | cut -d',' -f1 | cut -d' ' -f2)" ;;
			esac

			if [ "$connection" = "RR_Connected" ]; then
				message "Connected $output" &
				connection=""
			elif [ "$connection" = "RR_Disconnected" ]; then
				ensure_first
				disable_disconnected
				message "Disconnected $output" &
				connection=""
			fi
		done
}

listen
