#!/bin/sh

pw="$(< ~/.config/peanutbutter_pw)"

PEANUTBUTTER_PASSCODE="$pw" peanutbutter &
systemctl suspend
wait
