#!/bin/bash
source "$CONFIG_DIR/colors.sh"

# VPN_STATUS1=$(/usr/local/bin/mullvad status | head -n 1) now using nym dont have a command yet
VPN_STATUS2=$(/usr/sbin/networksetup -showpppoestatus "Twingate" | head -n 2)

if [[ $VPN_STATUS1 == Connected ]]; then
  sketchybar -m --set vpn icon=􀙨 icon.color="$BASE05"
elif [[ $VPN_STATUS2 == connected ]]; then
  sketchybar -m --set vpn icon=􀒞 icon.color="$BASE05"
else
  sketchybar -m --set vpn icon=􀲊 icon.color="$BASE09"
fi
