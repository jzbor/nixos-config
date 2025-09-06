#!/bin/sh
set -euo pipefail

partitions=$(parted /dev/mmcblk0 print)
if echo "$partitions" | grep -q "^ 5.*legacy_boot"; then
	active=5
	inactive=6
elif echo "$partitions" | grep -q "^ 6.*legacy_boot"; then
	active=6
	inactive=5
else
	echo "Error: No active partition with legacy_boot flag found."
	exit 1
fi

echo "Partition $active is active, toggling to partition $inactive"
parted /dev/mmcblk0 set $inactive legacy_boot on
parted /dev/mmcblk0 set $active legacy_boot off
