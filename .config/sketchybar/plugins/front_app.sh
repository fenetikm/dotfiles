#!/bin/zsh

source "$HOME/.config/sketchybar/colours.sh"

WINDOWINFO=$(yabai -m query --windows --window)

TITLE=$(echo $WINDOWINFO | jq -r '.title')
APP=$(echo $WINDOWINFO | jq -r '.app')
if [[ "$APP" = "kitty" ]]; then
  TITLE=kitty
fi
if [[ -z $TITLE ]]; then
    TITLE=$(echo $WINDOWINFO | jq -r '.app')
fi
TRIM_LEN=48
TITLE_LEN=${#TITLE}
if (( "$TITLE_LEN" > "$TRIM_LEN" )); then
  TITLE=`echo "$TITLE" | cut -c -$TRIM_LEN`
  TITLE+=...
fi

# todo: icons for some apps

if [ "$SENDER" = "front_app_switched" ]; then
  sketchybar --set "$NAME" label="${TITLE}" label.color=$DEFAULT_COLOUR
fi
