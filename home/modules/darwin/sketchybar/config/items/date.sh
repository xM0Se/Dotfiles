#!/bin/bash

sketchybar \
  --add item day left \
  --set day \
  update_freq=120 \
  icon.drawing=off \
  label="$(date '+%a')"

sketchybar \
  --add item date left \
  --set date \
  update_freq=120 \
  icon.drawing=off \
  label="$(date '+%d' | sed 's/^0//')"

sketchybar \
  --add item month left \
  --set month \
  update_freq=120 \
  icon.drawing=off \
  label="$(date '+%b')"
