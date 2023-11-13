#!/bin/bash

# Get the battery percentage without the % symbol
percentage=$(upower -i /org/freedesktop/UPower/devices/battery_BAT1 | awk '/percentage/ {gsub(/%/, ""); print $2}')

# Check if the percentage is below 30
if [ "$percentage" -lt 30 ]; then
  notify-send -h string:x-canonical-private-synchronous:sys-notify -u critical "Battery Level Critical" 
else
  notify-send -h string:x-canonical-private-synchronous:sys-notify -u critical "Battery Level Normal"
fi

