#!/bin/sh

die () {
	echo "$1"
	exit 1
}

if [ "$#" != 1 ]; then
	die "Usage: $0 <target>"
fi

target="$1"
if echo "$target" | grep -vqF ":"; then
	target="$target:."
fi

temp="$(mktemp --tmpdir -d "ssh-mount-XXXX  $target")"
if sshfs -C -v "$target" "$temp"; then
	cd "$temp"
	"$SHELL"
	cd -
	umount -v "$temp"
	rmdir "$temp"
else
	rmdir "$temp"
	die "Unable to access $target"
fi

