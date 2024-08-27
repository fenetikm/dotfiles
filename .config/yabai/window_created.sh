#! /usr/bin/env zsh

echo '################'
echo 'window created'

wid="${YABAI_WINDOW_ID}"

# if the split is horizontal, toggle it to vertical
yabai -m query --windows --window "${wid}" | jq -re '."split-type" == "horizontal" and ."display" == 2' \
    && yabai -m window "${wid}" --toggle split

# balance out the windows
yabai -m query --windows --window "${wid}" | jq -re '."display" == 2 and ."is-floating" == false' \
    && yabai -m space $(yabai -m query --windows --window "$wid" | jq '.space') --balance
