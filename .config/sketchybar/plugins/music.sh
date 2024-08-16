#!/bin/bash

MUSIC_TRACK=$(osascript <<EOF
on appIsRunning(appName)
    tell app "System Events" to (name of processes) contains appName
end appIsRunning

if appIsRunning("Music") then
  tell app "Music" to get the name of the current track
end if
EOF)

# echo "$MUSIC_TRACK"

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
  if [[ "$TRACK_LEN" -gt 24 ]]; then
    MUSIC_TRACK=`echo "$MUSIC_TRACK" | cut -c -24`
    MUSIC_TRACK+=...
  fi

  ARTIST_LEN=${#MUSIC_ARTIST}
  if [[ "$ARTIST_LEN" -gt 16 ]]; then
    MUSIC_ARTIST=`echo "$MUSIC_ARTIST" | cut -c -16`
    MUSIC_ARTIST+=...
  fi

  ICON=" "
  sketchybar --set "$NAME" icon="$ICON" label="${MUSIC_TRACK} : ${MUSIC_ARTIST}" \
    label.padding_right=8 \
    drawing=on \
    icon.padding_left=8 icon.color=0xff99A4BC\
    background.drawing=on background.color=0xff2f2f3a \
    background.corner_radius=6 background.height=20 background.y_offset=0
else
  sketchybar --set "$NAME" drawing=off
fi

