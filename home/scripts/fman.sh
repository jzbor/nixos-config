#!/bin/sh

selection="$(man -k . \
	| fzf --preview "echo {} | sed 's/\([a-zA-Z0-9_\.-]*\) (\([a-z0-9]*\)).*/man -P cat \2 \1/' | sh" \
	| sed 's/\([a-zA-Z0-9_\.-]*\) (\([a-z0-9]*\)).*/man \2 \1/')"
if [ -n "$selection" ]; then
	echo "$selection" | sh
	fman
fi
