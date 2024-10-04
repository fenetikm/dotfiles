#! /usr/bin/env zsh

# toggle float
if [[ $(yabai -m query --windows --window | jq -re '."is-floating"') == false ]]; then
  yabai -m window --toggle float
fi

# hide using opacity might be better so don't need to save state otherwise?

# hide all other windows
WINDOW_ID=$(yabai -m query --windows --window | jq '.id')
OTHER_WINDOWS=($(yabai -m query --windows --space | jq -c -re '.[] | select(.id != "$WINDOW_ID" and ."is-visible" == true) | .id | @sh'))

for i in "${OTHER_WINDOWS}"
do
  # yabai -m window "$i" --opacity 0.001
done

# DISPLAY_WIDTH=$(yabai -m query --displays --space | jq '.frame.w')
# # this should really work out the ratio instead of only looking at the width
# IS_ULTRAWIDE=$(echo "$DISPLAY_WIDTH > 3000" | bc -l)
