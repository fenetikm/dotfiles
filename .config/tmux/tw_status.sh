#!/bin/bash

# assumes just the one project.
PROJECT=`task +ACTIVE _projects`
if [[ -z "$PROJECT" ]]; then
  echo "#[fg=#89898c]No timer running"
  exit;
fi

# again assuming one active item.
ID=`task +ACTIVE _ids`

# could be tags but is actually the ID - surprise!
TAGS=" #[fg=#ff8000][#[fg=#8fa3bf]$ID#[fg=#ff8000]]"

# remove seconds once there is a minute, reformat hours and minutes
TIME=`timew get dom.active.duration | sed -e "s/^PT//" | sed -e "s/S/s/" | sed -e "s/M.*/m/" | sed -e "s/H/h /"`
if [[ -z "$TIME" ]]; then
  TIME="0m"
fi

echo "#[fg=#8fa3bf]$ #[fg=#d4d4d9]$PROJECT$TAGS #[fg=yellow]$TIME"
