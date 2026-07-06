#!/bin/bash

export SB_BAR=(
  position=left
  height=60
  sticky=on
  topmost=off
  shadow=on
  y_offset=10
  margin=10
  padding_left=10
  padding_right=10
  color="$BASE01"
  border_color="$BASE02"
  border_width=1
  corner_radius=12
  font_smoothing=on
  blur_radius=30
)

export SB_DEFAULT=(
  icon.font.family="SF Pro:Semibold:15.0"
  icon.font.style="Regular"
  icon.font.size=16
  icon.color="$BASE05"
  label.font="JetBrains Mono:Semibold:15.0"
  label.font.style="Regular"
  label.font.size=14
  label.color="$BASE05"
  padding_left=6
  padding_right=6
  icon.padding_right=4
  icon.padding_left=4
)
