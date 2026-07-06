#!/bin/bash

sketchybar \
  --add item cpu right \
  --subscribe cpu system_woke \
  --set cpu \
  script="$PLUGIN_DIR/cpu.sh" \
  update_freq=5 \
  icon="􀫥" \
  label="--%" \
  background.drawing=off
