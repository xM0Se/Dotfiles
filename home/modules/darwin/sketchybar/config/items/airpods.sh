#!/bin/bash

sketchybar -m \
  --add item casep right \
  --set casep update_freq=10 \
  label="--%" \
  label.align=center \
  --set casep script="$PLUGIN_DIR/airpods.sh"

sketchybar -m \
  --add item casei right \
  --set casei \
  label.drawing=off \
  icon="􂭇"

sketchybar -m \
  --add item lpodp right \
  --set casep update_freq=10 \
  label="--%" \
  label.align=center \
  --set lpodp script="$PLUGIN_DIR/airpods.sh"

sketchybar -m \
  --add item lpodi right \
  --set lpodi \
  label.drawing=off \
  icon="􂭄"

sketchybar -m \
  --add item rpodp right \
  --set casep update_freq=10 \
  label="--%" \
  label.align=center \
  --set rpodp script="$PLUGIN_DIR/airpods.sh"

sketchybar -m \
  --add item rpodi right \
  --set rpodi \
  label.drawing=off \
  icon="􂭅"
