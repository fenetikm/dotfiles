#! /usr/bin/env zsh

echo '################'
echo 'window destroyed'

# todo: pull this in from an env variable?
FIX_OPACITY=on

# fixme: instead of this, go through all spaces that have stacks and do it, more reliable
SPACE=$(yabai -m query --spaces --space)

# process ID will be set via application_hidden event
if [[ "$YABAI_PROCESS_ID" != "" ]]; then
  SPACE_ID=$(yabai -m query --windows | jq -re '.[] | select(."pid" == '"$YABAI_PROCESS_ID"') | .space')
  SPACE=$(yabai -m query --spaces --space "$SPACE_ID")
fi

# reset opacity of top window
if [[ $(echo "$SPACE" | jq -re '."type" == "stack"') == "true" && "$FIX_OPACITY" == "on" ]]; then
  WINDOW_IDS=($(echo "$SPACE" | jq -r '."windows" | @sh'))
  C=0
  for i in "${WINDOW_IDS[@]}"
  do
    CW=$(yabai -m query --windows --window $i | jq -re '."is-visible" == true')
    if [[ "$CW" == true ]]; then
      yabai -m window "$i" --opacity 1.0

      exit 1
    fi
    C=$((C+1))
  done
fi

source "$HOME"/.config/yabai/balance.sh
