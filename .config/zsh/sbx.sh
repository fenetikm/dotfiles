#!/usr/bin/env zsh

# safe bot
sbot() {
  local NAME="${1:-${PWD##*/}}"
  NAME="${NAME// /-}"
  "$HOME/.config/sbx/launch.sh" "$NAME"
}
