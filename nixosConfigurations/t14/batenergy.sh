#!/usr/bin/env bash
# https://github.com/equaeghe/batenergy

FILE=/tmp/batenergy.dat
ADP=(/sys/class/power_supply/A*)
BAT=(/sys/class/power_supply/BAT*)

[[ -e ${BAT[0]} ]] || exit

state=$1
sleep_type=$2

now="$(date +'%s')"

# Read an energy in mWh from /sys/class/power_supply.
# Some firmware only reports charge (in µAh), in which case we convert using voltage.
read_energy() {
	local when=$1
	local -n var=energy_$when
	if [[ -e "${BAT[0]}/energy_$when" ]]; then
		# shellcheck disable=2034
		(( var = "$(< "${BAT[0]}/energy_$when")" / 1000 )) # mWh
	else
		if (( ! voltage_now )); then
			(( voltage_now = $(< "${BAT[0]}"/voltage_now) )) # µV
		fi
		# shellcheck disable=2034
		(( var = "$(< "${BAT[0]}/charge_$when")" * voltage_now / 1000000000 )) # mWh
	fi
}

read_energy now
read_energy full

if [[ -f ${ADP[0]}/online ]]; then
	read -r online < "${ADP[0]}"/online

	if (( online )); then
		echo "Currently on mains."
	else
		echo "Currently on battery."
	fi
fi

case $state in
"pre")
	echo "Saving time and battery energy before sleeping ($sleep_type)."
	echo "$now" > $FILE
	# shellcheck disable=2154
	echo "$energy_now" >> $FILE
	;;
"post")
	exec 3<>$FILE
	read -r prev <&3
	read -r energy_prev <&3
	rm $FILE
	time_diff=$((now - prev)) # seconds
	days=$((time_diff / (3600*24)))
	hours=$((time_diff % (3600*24) / 3600))
	minutes=$((time_diff % 3600 / 60))
	echo "Duration of $days days $hours hours $minutes minutes sleeping ($sleep_type)."
	(( energy_diff = energy_now - energy_prev )) # mWh
	(( avg_rate = energy_diff * 3600 / time_diff )) # mW
	# shellcheck disable=2154
	energy_diff_pct=$(bc <<< "scale=1;$energy_diff * 100 / $energy_full") # %
	avg_rate_pct=$(bc <<< "scale=2;$avg_rate * 100 / $energy_full") # %/h
	echo "Battery energy change of $energy_diff_pct % ($energy_diff mWh) at an average rate of $avg_rate_pct %/h ($avg_rate mW)."
	;;
esac
