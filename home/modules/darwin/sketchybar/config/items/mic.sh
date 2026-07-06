#!/bin/bash

sketchybar -m --add item mic right \
  --set mic update_freq=3 \
  --set mic script="$PLUGIN_DIR/mic.sh" \
  label.drawing=off \
  --subscribe mic volume_change
