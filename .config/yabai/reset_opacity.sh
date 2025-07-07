#!/usr/bin/env zsh

if [[ "$1" == "" ]]; then
  echo "Missing space index argument."
  exit 1
fi

SPACE=$(yabai -m query --spaces --space "$1")
WINDOW_IDS=($(echo "$SPACE" | jq -r '."windows" | @sh'))
for i in "${WINDOW_IDS[@]}"
do
  yabai -m window "$i" --opacity 1.0
done
