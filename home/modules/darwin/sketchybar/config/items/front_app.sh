#!/bin/bash

sketchybar \
  --add item front_app left \
  --set front_app \
  script="$PLUGIN_DIR/front_app.sh" \
  icon.drawing=on \
  icon.font="sketchybar-app-font:Regular:16.0" \
  label.drawing=off \
  drawing=on \
  --subscribe front_app front_app_switched window_change
