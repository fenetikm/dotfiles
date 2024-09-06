#! /usr/bin/env zsh

HAS_FLOATING=$(yabai -m query --windows --space | jq '[.[] | select(."is-visible" == true and ."is-floating" == true)]')
if [[ "$HAS_FLOATING" != "[]" ]]; then
  FLOATING_PIDS=($(echo "$HAS_FLOATING" | jq -r '.[] .pid | @sh'))
  for p in "${FLOATING_PIDS[@]}"
  do
    hs -c "hs.application.applicationForPID($p):hide()"
  done
fi
