#! /usr/bin/env zsh

echo '################'
echo 'application launched'

pid="${YABAI_PROCESS_ID}"
echo $pid

# wid="${YABAI_WINDOW_ID}"
# echo $wid
#
# # if the split is horizontal, toggle it to vertical
# yabai -m query --windows --window "${wid}" | jq -re '."split-type" == "horizontal" and ."display" == 2' \
#     && yabai -m window "${wid}" --toggle split
#
# yabai -m query --windows --window "${wid}" | jq -re '."display" == 2 and ."is-floating" == false' \
#     && yabai -m space $(yabai -m query --windows --window "$wid" | jq '.space') --balance
