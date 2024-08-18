#!/bin/sh

# todo: app icons

if [ "$SENDER" = "front_app_switched" ]; then
  sketchybar --set "$NAME" label="\\$INFO" label.color=0xffb4b4b9
fi
