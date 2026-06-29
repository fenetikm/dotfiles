#!/usr/bin/env zsh

sbx_start() {
  local NAME="${1:-${PWD##*/}}"
  NAME="${NAME// /-}"
  local AGENT_TYPE="${2:-claude}"
  "$HOME/.config/sbx/start_sandbox.sh" "$NAME" "$AGENT_TYPE"
}
