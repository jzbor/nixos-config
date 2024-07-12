#!/bin/sh

if [ "$#" -gt 0 ]; then
	query="$1"
else
	query=""
fi

selection="$(nix search nixpkgs --json 2>/dev/null \
	| jq "keys[]" \
	| sed 's/"\(.*\)"/\1/g' \
	| fzf --query "$query" --prompt "nixpkgs#" --preview='nix eval --json nixpkgs#{}.meta | jq -C' \
	| sed 's/legacyPackages\..*-linux\.\(.*\)/\1/'
)"
if [ -n "$selection" ]; then
	#nix eval --json "nixpkgs#$selection.meta" | jq -C | less
	#xdg-open "https://search.nixos.org/packages?channel=unstable&show=$selection"
	nix eval --json "nixpkgs#$selection.meta" | jq | nvim -R
	search-nixpkgs "$selection"
fi
