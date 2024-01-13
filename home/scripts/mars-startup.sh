#/bin/sh

is_running () {
	pgrep --uid "$UID" "$1" > /dev/null
}

xset -dpms

[ -f ~/.screenlayout/default.sh ] && /bin/sh ~/.screenlayout/default.sh;

# somehow pgrep does not recognize the full name cause it's too long
is_running wallpaper-daem || wallpaper-daemon &
is_running marsbar || marsbar &
is_running touchegg || touchegg &
is_running skippy-xd || skippy-xd --start-daemon > /dev/null 2>&1 &
