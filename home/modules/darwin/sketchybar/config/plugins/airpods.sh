#!/bin/bash
source "$CONFIG_DIR/colors.sh"

CASE=$(/usr/sbin/system_profiler SPBluetoothDataType | /run/current-system/sw/bin/rg -A6 "Moritz’s AirPods:" | tail -n +5 | head -n 1 | /run/current-system/sw/bin/rg -o '\d+')

LEFT=$(/usr/sbin/system_profiler SPBluetoothDataType | /run/current-system/sw/bin/rg -A6 "Moritz’s AirPods:" | tail -n +6 | head -n 1 | /run/current-system/sw/bin/rg -o '\d+')

RIGHT=$(/usr/sbin/system_profiler SPBluetoothDataType | /run/current-system/sw/bin/rg -A6 "Moritz’s AirPods:" | tail -n +7 | head -n 1 | /run/current-system/sw/bin/rg -o '\d+')

if [ "$CASE" -lt 10 ]; then
  sketchybar -m --set casep label="${CASE}%" label.color="$BASE09"
  sketchybar -m --set casei label.color="$BASE09"
elif [ "$CASE" -gt 100 ]; then
  sketchybar -m --set casep label="100%" label.color="$BASE05"
  sketchybar -m --set casei label.color="$BASE05"
else
  sketchybar -m --set casep label="${CASE}%" label.color="$BASE05"
  sketchybar -m --set casei label.color="$BASE05"
fi

if [ "$LEFT" -lt 10 ]; then
  sketchybar -m --set lpodp label="${LEFT}%" label.color="$BASE09"
  sketchybar -m --set lpodi label.color="$BASE09"
elif [ "$LEFT" -gt 100 ]; then
  sketchybar -m --set lpodp label="100%" label.color="$BASE05"
  sketchybar -m --set lpodi label.color="$BASE05"
else
  sketchybar -m --set lpodp label="${LEFT}%" label.color="$BASE05"
  sketchybar -m --set lpodi label.color="$BASE05"
fi

if [ "$RIGHT" -lt 10 ]; then
  sketchybar -m --set rpodp label="${RIGHT}%" label.color="$BASE09"
  sketchybar -m --set rpodi label.color="$BASE09"
elif [ "$RIGHT" -gt 100 ]; then
  sketchybar -m --set rpodp label="100%" label.color="$BASE05"
  sketchybar -m --set rpodi label.color="$BASE05"
else
  sketchybar -m --set rpodp label="${RIGHT}%" label.color="$BASE05"
  sketchybar -m --set rpodi label.color="$BASE05"
fi
