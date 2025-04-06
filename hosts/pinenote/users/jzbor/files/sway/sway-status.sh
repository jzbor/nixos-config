while true; do
	printf '%s | %s%%\n' "$(date +'%d.%m.%y %H:%M')" "$(cat /sys/class/power_supply/rk817-battery/capacity)";
	sleep 15;
done
