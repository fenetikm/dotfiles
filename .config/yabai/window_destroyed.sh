#! /usr/bin/env zsh

echo '################'
echo 'window destroyed'

# fixme: pull this in from an env variable?
FIX_OPACITY=on

source "$HOME"/.config/yabai/balance.sh

# reset opacity of top window
SPACE=$(yabai -m query --spaces --space)
if [[ $(echo "$SPACE" | jq -re '."type" == "stack"') == true && "$FIX_OPACITY" == "on" ]]; then
  WINDOW_IDS=($(echo "$SPACE" | jq -r '."windows" | @sh'))
  C=0
  for i in "${WINDOW_IDS[@]}"
  do
    CW=$(yabai -m query --windows --window $i | jq -re '."is-visible" == true')
    if [[ "$CW" == true ]]; then
      # note: this resets it to 1.0
      yabai -m window "$i" --opacity 0.0
      exit 1
    fi
    C=$((C+1))
  done
fi
