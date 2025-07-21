#!/usr/bin/env zsh

yd() {
  echo '################' >> /tmp/yabai_michael.out.log
  if [[ "$2" != "" ]]; then
    echo "$2" >> /tmp/yabai_michael.out.log
  fi
  echo "$1" >> /tmp/yabai_michael.out.log
}
