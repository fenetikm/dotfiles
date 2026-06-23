#!/usr/bin/env zsh

sbx_launch() {
  local NAME="${1:-${PWD##*/}}"
  NAME="${NAME// /-}"
  local AGENT_TYPE="${2:claude}"
  "$HOME/.config/sbx/launch.sh" "$NAME" "$AGENT_TYPE"
}
