#!/bin/bash

get_time() {
  TIME=`timew get dom.active.duration | sed -e "s/^PT//" | sed -e "s/S/s/" | sed -e "s/M.*/m/" | sed -e "s/H/h /"`
  if [[ -z "$TIME" ]]; then
    TIME="0m"
  fi

  echo "$TIME"
}

TIME=`get_time`
if [[ "$TIME" == "0m" ]]; then
  echo "#[fg=#787882]No timer running"
  exit;
fi

# assumes just the one project.
PROJECT=`task +ACTIVE _projects`
if [[ -z "$PROJECT" ]]; then
  # no project running, just report the time
  echo "#[fg=yellow]$TIME "
  exit;
fi

# again assuming one active item.
ID=`task +ACTIVE _ids`

# could be tags but is actually the ID - surprise!
TAGS=" #[fg=magenta][#[fg=#99a4bc]$ID#[fg=magenta]]"

# remove seconds once there is a minute, reformat hours and minutes

echo "#[fg=#99a4bc]$ #[fg=white]$PROJECT$TAGS #[fg=yellow]$TIME "
