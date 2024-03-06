#!/bin/sh

if [ "$#" -gt 0 ]; then
	query="$1"
else
	query=""
fi

selection="$(man -k . \
	| fzf --query "$query" --preview "echo {} | sed 's/\([a-zA-Z0-9_\.-]*\) (\([a-z0-9]*\)).*/man -P cat \2 \1/' | sh" \
	| sed 's/\([a-zA-Z0-9_\.-]*\) (\([a-z0-9]*\)).*/man \2 \1/')"
if [ -n "$selection" ]; then
	echo "$selection" | sh
	fman "$(echo "$selection" | cut -f3 -d' ')"
fi
