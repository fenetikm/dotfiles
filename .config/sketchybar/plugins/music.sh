#!/bin/bash

source "$HOME/.config/sketchybar/vars.sh"

MAX_LEN=28
TRIM_LEN=`echo $(( $MAX_LEN - 3 ))`

MUSIC_TRACK=$(osascript <<EOF
on appIsRunning(appName)
    tell app "System Events" to (name of processes) contains appName
end appIsRunning

if appIsRunning("Music") then
  try
    tell app "Music"
      get the name of the current track
    end tell
  end try
end if
EOF)

if [[ ! -z "$MUSIC_TRACK" ]]; then
  MUSIC_ARTIST=$(osascript <<EOF
  on appIsRunning(appName)
      tell app "System Events" to (name of processes) contains appName
  end appIsRunning

  if appIsRunning("Music") then
    tell app "Music" to get the artist of the current track
  end if
EOF)

  FULL="${MUSIC_TRACK} - ${MUSIC_ARTIST}"
  FULL_LEN=${#FULL}
  if [[ "$FULL_LEN" > "$TRIM_LEN" ]]; then
    FULL=`echo "$FULL" | cut -c -$TRIM_LEN`
    FULL+=...
  fi

  ICON="󰺢 "
  sketchybar --set "$NAME" icon="$ICON" label="${FULL}" \
    label.padding_right=8 \
    drawing=on \
    label.max_chars=$MAX_LEN \
    icon.padding_left=8 icon.color=$ICON_COLOUR \
    background.drawing=on background.color=$BG1_COLOUR \
    background.shadow.drawing=on background.shadow.distance=1 \
    background.border_color=$BG1_BORDER_COLOUR background.border_width=1 \
    background.corner_radius=6 background.height=22
else
  sketchybar --set "$NAME" drawing=off
fi
