#!/bin/sh

while file="$( (ls -1; echo ..) | fzf --prompt "$(basename "$(pwd)") => " --ansi --preview 'bat --color=always {} 2>/dev/null || ls -1 --color=always {}')"; do
	mimetype="$(file -i "$file" | sed 's/.*: \(.*\);.*/\1/')"
	case $mimetype in
		text/plain) sh -i -c nvim "$file" ;;
		inode/directory) cd "$file" || exit;;
		inode/symlink) cd "$file" || exit;;
		*) xdg-open "$file" ;;
	esac
done

pwd
