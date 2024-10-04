#! /usr/bin/env zsh

# unhide hidden floating apps
HAS_HIDDEN=$(yabai -m query --windows --space | jq '[.[] | select(."is-visible" == false)]')
if [[ "$HAS_HIDDEN" != "[]" ]]; then
  FLOATING_PIDS=($(echo "$HAS_HIDDEN" | jq -r '.[] .pid | @sh'))
  for p in "${FLOATING_PIDS[@]}"
  do
    hs -c "hs.application.applicationForPID($p):unhide()"
  done
fi
