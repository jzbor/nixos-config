#!/bin/sh

path="$(find -L ~/Documents ~/Downloads ~/Nextcloud -type f -printf "%A+ %f\t%p\n" | grep -v '/\.' | sort -r | cut -c 32- | rofi -i -p Open -dmenu | cut -f2)"

mimetype="$(file -i "$path" | sed 's/.*: \(.*\);.*/\1/')"

case $mimetype in
	text/plain) $TERMINAL -e "nvim \"$path\"" ;;
	*) xdg-open "$path" ;;
esac

