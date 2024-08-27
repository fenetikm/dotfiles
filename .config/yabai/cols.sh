#!/bin/bash

#! /usr/bin/env zsh

# enable auto balance
yabai -m config auto_balance on

# register events
# for event in window_focused application_activated; do
#   yabai -m signal --add label="${0}_${event}" event="${event}" \
#     action="${0}"
# done

# when loading the script, convert all existing splits to horizontal
yabai -m query --windows --space \
  | jq -r '.[] | select(."is-visible" == true and ."split-type" == "horizontal").id' \
  | xargs -I{} yabai -m window {} --toggle split

exit

# yabai -m window --insert "$(jq -nr \
# 	--arg window_placement "$(yabai -m config window_placement)" \
# 	--argjson display "$(yabai -m query --displays --display)" \
# 	'[["west", "east"], ["north", "south"]][if $display | .frame | .w >= .h then 0 else 1 end][if $window_placement == "first_child" then 0 else 1 end]')"
