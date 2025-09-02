#!/bin/sh

set +o nounset

CC_RED="\e[0;31m"
CC_BLUE="\e[0;34m"

CC_BOLD="\e[1m"
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

print_header () {
    printf "\n%s=== %s ===%s\n" "$CC_BLUE$CC_BOLD" "$1" "$CC_RESET"
}

print_help () {
    print_header "Help: $(basename "$0")"
    printf "\n%s\n\n" "$HELPTEXT" | fmt -s
}

HELPTEXT="Record screen on X11 (primary screen by default)

    -h  --help      print this message
    -p  --pulse     record audio
    -s  --select    select area with slop
    output          output file"

DEST="${XDG_VIDEOS_DIR:-$HOME/Videos}/Screencasts"
FILENAME="$(date +'Screencast_%Y-%m-%d_%H-%M-%S.mp4')"
RECORD_PULSE=0
RECORD_ALSA=0
SLOP_SELECT=0

check_dependencies ffmpeg xrandr

resolution="$(xrandr | grep primary | cut -d' ' -f4 | grep -o '[0-9]*x[0-9]*')"
offset=""


get_audio () {
    if [ "$RECORD_PULSE" = 1 ]; then
        checkdependencies pulseaudio
        echo "-f pulse -ac 2 -i 0"
    elif [ "$RECORD_ALSA" = 1 ]; then
        echo "-f alsa -ac 2 -i hw:0"
    fi
}

record () {
    [ -d "$DEST" ] || mkdir -vp "$DEST"
    # shellcheck disable=SC2046
    ffmpeg -f x11grab -y -r 60 -s "$resolution" -i ":0.0$offset" \
        $(get_audio) \
        -vcodec h264 -pix_fmt yuv420p \
        -vf "crop=trunc(iw/2)*2:trunc(ih/2)*2" \
        "$DEST/$FILENAME"
}

slop_select () {
    check_dependencies slop
    tmp="$(slop)"
    # shellcheck disable=SC2001
    resolution="$(echo "$tmp" | sed 's/\([0-9]*\)x\([0-9]*\)+\([0-9]*\)+\([0-9]*\)/\1x\2/')"
    # shellcheck disable=SC2001
    offset="$(echo "$tmp" | sed 's/\([0-9]*\)x\([0-9]*\)+\([0-9]*\)+\([0-9]*\)/+\3,\4/')"
}

# parse arguments
while :; do
    case $1 in
        # -a | --alsa) RECORD_ALSA=1; shift ;;
        -h | --help) print_help; exit ;;
        -p | --pulse) RECORD_PULSE=1; shift ;;
        -s | --select) SLOP_SELECT=1; shift ;;
        *) break ;;
    esac
done

if [ -n "$1" ]; then
    if [ -d "$1" ]; then
        DEST="$1"
    else
        DEST="$(dirname "$1")"
        FILENAME="$(basename "$1")"
    fi
fi

[ "$SLOP_SELECT" = 1 ] && slop_select

record
