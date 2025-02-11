#!/bin/sh

if [ "$#" != 1 ]; then
	echo "Usage: $(basename "$0") <image-file>" > /dev/stderr
	exit 1
fi

if ! [ -f "$1" ]; then
	echo "File '$1' not found" > /dev/stderr
	exit 1
fi

ln -sfv "$(realpath "$1")" ~/.background-image
xwallpaper --zoom "$1"
