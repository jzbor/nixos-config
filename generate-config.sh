#!/bin/sh

ask () {
	printf "$1" >&2
	read answer
	echo >&2

	if [ -z "$answer" ]; then
		echo >&2
		echo "This must not be empty" >&2
		ask "$@"
	else
		echo "$answer"
	fi
}

get_options () {
	(find . -maxdepth 1 -name '*.nix'; find ./machine -name '*.nix'; find ./boot -name 'boot-*.nix'; find ./programs -name '*.nix') 2>/dev/null \
		| sed '/^\.\/configuration.*\.nix$/d' \
		| sort \
		| sed 's/^/      \#/'
}

# Makes the string from get_options usable for sed
escape () {
	sed 's/\n/\\n/;s/\#/\\#/g;s/\//\\\//g' \
		| sed 's/$/\\n/g' | tr -d '\n'
}

# Query hostname and state_version from user
hostname="$(ask 'Please choose a hostname: ')"
state_version="$(ask 'Please provide the stateVersion: ')"

cat configuration.def.nix \
	| sed -z "s/IMPORT_OPTIONS/\[\n$(get_options | escape)    \]/g" \
	| sed "s/HOSTNAME/$hostname/" \
	| sed "s/STATE_VERSION/$state_version/"

