#/bin/sh

is_running () {
	pgrep --uid "$UID" "$1" > /dev/null
}

xset -dpms
xmodmap -e 'keycode 94 = Alt_L Meta_L Alt_L Meta_L'

if [ -f ~/.screenlayout/default.sh ]; then
	/bin/sh ~/.screenlayout/default.sh || true;
fi


# import environment into user services and startup xsession.target
systemctl --user import-environment DISPLAY XAUTHORITY PATH
if command -v dbus-update-activation-environment >/dev/null 2>&1; then
    dbus-update-activation-environment --systemd --all
fi
systemctl --user --no-block start xsession.target
