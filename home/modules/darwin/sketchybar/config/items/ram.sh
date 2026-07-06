#!/bin/bash

sketchybar --add item ram right \
  --set ram \
  script="$PLUGIN_DIR/ram.sh" \
  update_freq=5 \
  icon="􀫦" \
  label="--%" \
  background.drawing=off
