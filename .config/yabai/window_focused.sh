#! /usr/bin/env zsh

echo '################'
echo 'window focused'

# fixme: pull in from env variable?
FIX_OPACITY=on

WID="${YABAI_WINDOW_ID}"
WINDOW=$(yabai -m query --windows --window "$WID")
if [[ $(echo "$WINDOW" | jq -re '."is-floating"') == "true" ]]; then
  exit 1
fi

# this resets the opacity to 1.0
yabai -m window "$WID" --opacity 0.0

# first scenario, stacked space
SPACE=$(yabai -m query --spaces --space)
if [[ $(echo "$SPACE" | jq -re '."type" == "stack"') == true && "$FIX_OPACITY" == "on" ]]; then
  WINDOW_IDS=($(echo "$SPACE" | jq -r '."windows" | @sh'))
  if [[ "${WINDOW_IDS[1]}" == "$WID" ]]; then
    WINDOWS=$(yabai -m query --windows --space)
    C=0
    for i in "${WINDOW_IDS[@]}"
    do
      if (( "$C" > 0 )); then
        CW=$(yabai -m query --windows --window $i | jq -re '."is-visible" == true')
        if [[ "$CW" == true ]]; then
          yabai -m window "$i" --opacity 0.001
        else
          # once this is false, all other windows are hidden (it seems!)
          exit 1
        fi
      fi
      C=$((C+1))
    done
  fi
fi

# second scenario, when window is in stack but space not in stack
# not needed for now