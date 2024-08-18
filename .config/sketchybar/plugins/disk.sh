#!/bin/bash

SPACE=$(df -h --si "/" | tail -n 1 | cut -w -f4)
NUM=$(echo $SPACE | sed -E 's/G//')
ICON=
COLOUR=0xffb4b4b9
if (( "$NUM" < 20 )); then
  COLOUR=0xffFFC552
fi
if (( "$NUM" < 10 )); then
  COLOUR=0xffFF3600
fi

sketchybar --set "$NAME" icon="$ICON" label="HDD ${SPACE}" label.color="${COLOUR}" icon.drawing=off
