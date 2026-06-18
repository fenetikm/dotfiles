#!/usr/bin/env zsh

bot() {
  local NAME="${1:-${PWD##*/}}"
  NAME="${NAME// /-}"
  "$HOME/.config/sbx/launch.sh" "$NAME"
}
