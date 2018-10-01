#!/usr/bin/env bash

ITUNES_TRACK=$(osascript <<EOF
if appIsRunning("iTunes") then
  tell app "iTunes" to get the name of the current track
end if

on appIsRunning(appName)
    tell app "System Events" to (name of processes) contains appName
end appIsRunning
EOF)

if [[ ! -z "$ITUNES_TRACK" ]]; then
  ITUNES_ARTIST=$(osascript <<EOF
  if appIsRunning("iTunes") then
      tell app "iTunes" to get the artist of the current track
  end if

  on appIsRunning(appName)
      tell app "System Events" to (name of processes) contains appName
  end appIsRunning
EOF)

  TRACK_LEN=${#ITUNES_TRACK}
  if [[ "$TRACK_LEN" -gt 30 ]]; then
    ITUNES_TRACK=`echo "$ITUNES_TRACK" | cut -c -30`
    ITUNES_TRACK+=...
  fi

  ARTIST_LEN=${#ITUNES_ARTIST}
  if [[ "$ARTIST_LEN" -gt 20 ]]; then
    ITUNES_ARTIST=`echo "$ITUNES_ARTIST" | cut -c -20`
    ITUNES_ARTIST+=...
  fi

  echo '#[fg=#99a4bc]♫#[fg=#b4b4b9]' "$ITUNES_TRACK" '#[fg=#787882]-#[fg=#b4b4b9]' "$ITUNES_ARTIST"
  exit
else
  echo "#[fg=#787882]No music playing"
fi
