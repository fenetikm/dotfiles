#!/bin/bash

# df -h --si "/" | tail -n 1 | cut -w -f4
# e.g. 22G
# change colour dependent on amount of space
SPACE=$(df -h --si "/" | tail -n 1 | cut -w -f4)
NUM=$(echo $SPACE | sed -E 's/G//')
ICON=
ICON=
ICON=
COLOUR=0xffa1a1a9
if (( "$NUM" < 25)); then
  COLOUR=0xffFFC552
fi
if (( "$NUM" < 10)); then
  COLOUR=0xffFF3600
fi

sketchybar --set "$NAME" icon="$ICON" label="${SPACE}" label.color="${COLOUR}"
