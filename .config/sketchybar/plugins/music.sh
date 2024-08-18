#!/bin/bash

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
  if [[ "$FULL_LEN" > 29 ]]; then
    FULL=`echo "$FULL" | cut -c -29`
    FULL+=...
  fi

  ICON="󰺢 "
  sketchybar --set "$NAME" icon="$ICON" label="${FULL}" \
    label.padding_right=8 \
    drawing=on \
    label.max_chars=32 \
    icon.padding_left=8 icon.color=0xffb4b4b9 \
    background.drawing=on background.color=0x20ffffff \
    background.shadow.drawing=on background.shadow.distance=1 \
    background.border_color=0x07ffffff background.border_width=1 \
    background.corner_radius=6 background.height=22
else
  sketchybar --set "$NAME" drawing=off
fi
