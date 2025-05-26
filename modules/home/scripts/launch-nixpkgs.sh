#!/bin/sh

nix search "$@" nixpkgs ^ --json 2>/dev/null \
	| jq "keys[]" \
	| sed 's/"legacyPackages\..*-linux\.\(.*\)"/\1/' \
	| rofi -i -dmenu \
	| xargs -I {} sh -c "$TERMINAL -e 'nix build $* nixpkgs#{} --no-link || { read; false; }' && nix run $* nixpkgs#{}"
