#!/usr/bin/env zsh
#
# launch.sh - Create and run an sbx sandbox for the current project.
#
# Usage:
#   launch.sh <sandbox-name> [agent-type]
#
# Args:
#   - [agent-type]: optional, defaults to "claude"
#
# What it does:
#   1. Picks a free TCP port starting at 9999 for the status listener.
#   2. Seeds ./.local/sbx from $HOME/.config/sbx/template if it's missing.
#   3. Creates a sandbox named <sandbox-name> using ./.local/sbx for spec
#   4. Exports the tmux window id and chosen port into the sandbox.
#   5. Allows sandbox network access to localhost:<port>.
#   6. Starts the status listener and runs the sandbox, cleaning up on exit.
#
# Requires: tmux, sbx, jq, lsof.

WINDOW_ID=$(tmux display-message -p '#{window_id}')
BASE_PORT=9999
AGENT_TYPE="${2:claude}"
SANDBOX_NAME="sbx-$AGENT_TYPE-$1"

find_free_port() {
  local p=$BASE_PORT
  local MAX=$(( p + 20 ))
  while lsof -iTCP:"$p" -sTCP:LISTEN -nP >/dev/null 2>&1; do
    if [[ "$p" == "$MAX" ]]; then
      echo "Couldn't find a free port."
      exit 1
    fi
    (( p++ ))
  done
  echo "$p"
}

PORT=$(find_free_port)

ensure_kit() {
  if [[ ! -d "$HOME/.config/sbx/templates/$AGENT_TYPE" ]]; then
    echo "Agent type not supported."
    exit 1
  fi

  if [[ ! -d ./.local/sbx ]]; then
    echo "No sbx config directory found, using template."
    mkdir -p .local
    cp -r "$HOME/.config/sbx/template/$AGENT_TYPE" ".local/sbx/$AGENT_TYPE"
  fi
}

create_sandbox() {
  sbx create "$AGENT_TYPE" --kit "./.local/sbx/$AGENT_TYPE" --name "$1" .
}

set_sandbox_var() {
  sbx exec -d "$SANDBOX_NAME" bash -c "echo 'export $1=$2' >> /etc/sandbox-persistent.sh"
}

check_exists() {
  sbx ls --json | jq -e --arg n "$1" 'any(.sandboxes[]; .name == $n)' >/dev/null
}

cleanup() {
  # guard
  [[ -n "$CLEANED" ]] && return
  CLEANED=1
  echo "Cleaning up."
  [[ -n "$LISTENER_PID" ]] && kill "$LISTENER_PID" 2>/dev/null
  sbx rm -f "$SANDBOX_NAME" 2>/dev/null
}

if check_exists "$SANDBOX_NAME"; then
  echo "Sandbox '$SANDBOX_NAME' exists, remove it first with `sbx rm <name>`"
  exit 1
fi

ensure_kit

echo "Creating sandbox $SANDBOX_NAME"
create_sandbox "$SANDBOX_NAME"
echo "Setting sandbox vars"
set_sandbox_var TM_WINDOW_ID "$WINDOW_ID"
set_sandbox_var TM_PORT "$PORT"
sbx policy allow network --sandbox "$SANDBOX_NAME" localhost:"$PORT"
echo "Starting listener on $PORT"
"$HOME/.config/sbx/status_listener.sh" "$PORT" "$WINDOW_ID" &
LISTENER_PID=$!
trap cleanup EXIT INT TERM
sbx run "$SANDBOX_NAME"
