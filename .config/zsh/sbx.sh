#!/usr/bin/env zsh

safe_bot() {
  local NAME="${1:-${PWD##*/}}"
  NAME="${NAME// /-}"
  "$HOME/.config/sbx/launch.sh" "$NAME"
}
