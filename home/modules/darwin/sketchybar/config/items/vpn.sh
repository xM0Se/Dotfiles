#!/bin/bash

sketchybar -m --add item vpn right \
  --set vpn update_freq=5 \
  --set vpn script="$PLUGIN_DIR/vpn.sh"
