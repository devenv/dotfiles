#!/usr/bin/env bash

# Ensure the script reflects the focused AeroSpace workspace
if [ "$1" = "$FOCUSED_WORKSPACE" ]; then
  sketchybar --set $NAME background.drawing=on
else
  sketchybar --set $NAME background.drawing=off
fi
