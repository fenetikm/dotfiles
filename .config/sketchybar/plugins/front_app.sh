#!/bin/zsh

# todo:
# - icons for some apps?
# - more yabai info? toggleable
# - get better info from kitty / tmux

source "$HOME/.config/sketchybar/vars.sh"

WINDOW_INFO=$(yabai -m query --windows --window)
ICON=""

TRIM_LEN=48

if [[ "$WINDOW_INFO" == *"could not retrieve"* ]]; then
  TITLE=
else
  TITLE=$(echo "$WINDOW_INFO" | jq -r '.title')
  APP=$(echo "$WINDOW_INFO" | jq -r '.app')
  IS_FLOAT=$(echo "$WINDOW_INFO" | jq -r '."is-floating"')
  if [[ "$APP" = "kitty" ]]; then
    TITLE="kitty // $TITLE"
  fi
  if [[ -z "$TITLE" ]]; then
      TITLE=$(echo "$WINDOW_INFO" | jq -r '.app')
  fi
  TITLE_LEN="${#TITLE}"
  if (( "$TITLE_LEN" > "$TRIM_LEN" )); then
    TITLE=`echo "$TITLE" | cut -c -"$TRIM_LEN"`
    TITLE+=…
  fi
  if [[ "$IS_FLOAT" == "true" ]]; then
    ICON="[F]"
  fi
fi

SPACE_INFO=$(yabai -m query --spaces --space)
if [[ "$SPACE_INFO" == *"could not retrieve"* ]]; then
  TITLE="$TITLE"
else
  SPACE=$(echo "$SPACE_INFO" | jq -r '.label')
  TITLE="[${SPACE}]  $TITLE"
fi

if [[ "$SENDER" = "front_app_switched" ]]; then
  sketchybar --set "$NAME" label="${TITLE}" label.color=$DEFAULT_COLOUR icon="${ICON}" padding_left=0
fi
