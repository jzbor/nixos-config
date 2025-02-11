#!/bin/sh

set +o nounset

CC_RED="\e[0;31m"
CC_RESET="\e[0m"

die () {
    printf "$CC_RED%s$CC_RESET\n" "$1" > /dev/stderr
    exit 1
}

check_dependencies () {
    for dep in "$@"; do
        command -v "$dep" > /dev/null \
            || die "Dependency $1 not installed"
    done
}

# check_dependencies ffmpeg slop mpv

offset=""


record () {
    ffmpeg -f x11grab -y -r 30 -s "$resolution" -i ":0.0$offset" \
	    -c:v copy -f nut - | mpv --no-cache --untimed --no-demuxer-thread -
	    # -vf "crop=trunc(iw/2)*2:trunc(ih/2)*2" \
	    # -c:v copy -crf 0 -preset ultrafast -color_range 2 \
	    # -fflags nobuffer -flags low_delay \
}

slop_select () {
    tmp="$(slop)"
    # shellcheck disable=SC2001
    resolution="$(echo "$tmp" | sed 's/\([0-9]*\)x\([0-9]*\)+\([0-9]*\)+\([0-9]*\)/\1x\2/')"
    # shellcheck disable=SC2001
    offset="$(echo "$tmp" | sed 's/\([0-9]*\)x\([0-9]*\)+\([0-9]*\)+\([0-9]*\)/+\3,\4/')"
}

slop_select
record
