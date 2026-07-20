#!/usr/bin/env zsh

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

# only update when the app is switched
if [[ "$SENDER" = "front_app_switched" ]]; then
  sketchybar \
    --set "$NAME" \
      icon="${ICON}" \
      label="${TITLE}" \
      label.color=$PASSIVE_COLOUR \
      padding_left=0
fi
