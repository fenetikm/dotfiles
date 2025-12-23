#!/usr/bin/env zsh

LOG_FILE=/tmp/yabai_michaelwelford.out.log

yd() {
  echo '################' >> "$LOG_FILE"
  if [[ "$2" != "" ]]; then
    echo "$2" >> "$LOG_FILE"
  fi
  echo "$1" >> "$LOG_FILE"
}
