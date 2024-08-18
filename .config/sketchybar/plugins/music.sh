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

  TRACK_LEN=${#MUSIC_TRACK}
  # if [[ "$TRACK_LEN" -gt 24 ]]; then
  #   MUSIC_TRACK=`echo "$MUSIC_TRACK" | cut -c -24`
  #   MUSIC_TRACK+=...
  # fi

  ARTIST_LEN=${#MUSIC_ARTIST}
  # if [[ "$ARTIST_LEN" -gt 16 ]]; then
  #   MUSIC_ARTIST=`echo "$MUSIC_ARTIST" | cut -c -16`
  #   MUSIC_ARTIST+=...
  # fi

  # ICON="󰝚 "
  ICON="󰺢 "
  sketchybar --set "$NAME" icon="$ICON" label="${MUSIC_TRACK} : ${MUSIC_ARTIST}" \
    label.padding_right=8 \
    drawing=on \
    label.max_chars=64 \
    icon.padding_left=8 icon.color=0xffb4b4b9 \
    background.drawing=on background.color=0x20ffffff \
    background.shadow.drawing=on background.shadow.distance=1 \
    background.border_color=0x07ffffff background.border_width=1 \
    background.corner_radius=6 background.height=22
else
  sketchybar --set "$NAME" drawing=off
fi
