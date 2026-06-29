#!/usr/bin/env zsh

usage() {
  cat <<'EOF'
start_sandbox.sh - Create and run an sbx sandbox for the current project.

Usage:
  launch.sh <sandbox-name> [agent-type]

Args:
  - [agent-type]: optional, defaults to "claude"

What it does:
1. Picks a free TCP port starting at 9999 for the status listener.
2. Seeds ./.sbx from $HOME/.config/sbx/templates if it's missing.
3. Creates a sandbox named <sandbox-name> using .sbx/$AGENT_TYPE/spec.yaml
4. Exports the tmux window id and chosen port into the sandbox.
5. Allows sandbox network access to localhost:<port>.
6. Starts the status listener and runs the sandbox, cleaning up on exit.

Requires: tmux, sbx, jq, lsof.
EOF
}

if [[ "$1" == "--help" || "$1" == "-h" ]]; then
  usage
  exit 0
fi

GREEN=$'\033[32m'
RESET=$'\033[0m'

WINDOW_ID=$(tmux display-message -p '#{window_id}')
BASE_PORT=9999
AGENT_TYPE="${2:-claude}"
SANDBOX_NAME="sbx-$AGENT_TYPE-$1"

find_free_port() {
  local p=$BASE_PORT
  local MAX=$(( p + 20 ))
  while lsof -iTCP:"$p" -sTCP:LISTEN -nP >/dev/null 2>&1; do
    if [[ "$p" == "$MAX" ]]; then
      echo "${GREEN}Couldn't find a free port.${RESET}"
      exit 1
    fi
    (( p++ ))
  done
  echo "$p"
}

PORT=$(find_free_port)

check_sbx_auth() {
  local diag auth
  diag=$(sbx diagnose -o json 2>/dev/null)
  auth=$(echo "$diag" | jq -r '.checks[] | select(.name == "Authentication") | .status')

  if [[ "$auth" == "pass" ]]; then
    return 0
  fi

  echo "Not logged into sbx, run 'sbx login' first."
  echo "$diag" | jq -r '.checks[] | select(.status != "pass") | "  ✗ \(.name): \(.message)\(if .hint != "" then " → \(.hint)" else "" end)"'
  exit 1
}

ensure_kit() {
  if [[ ! -d "$HOME/.config/sbx/templates/$AGENT_TYPE" ]]; then
    echo "${GREEN}Agent type not supported.${RESET}"
    exit 1
  fi

  if [[ ! -d ./.sbx ]]; then
    echo "${GREEN}No sbx config directory found, using template.${RESET}"
    mkdir -p .sbx
    cp -r "$HOME/.config/sbx/templates/$AGENT_TYPE" ".sbx/$AGENT_TYPE"
  fi
}

create_sandbox() {
  sbx create "$AGENT_TYPE" --kit "./.sbx/$AGENT_TYPE" --name "$1" .
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
  echo "${GREEN}Cleaning up.${RESET}"
  [[ -n "$LISTENER_PID" ]] && kill "$LISTENER_PID" 2>/dev/null
  sbx rm -f "$SANDBOX_NAME" 2>/dev/null
  echo "${GREEN}Done.${RESET}"
}

check_sbx_auth

if check_exists "$SANDBOX_NAME"; then
  echo "${GREEN}Sandbox '$SANDBOX_NAME' exists, remove it first with `sbx rm <name>`${RESET}"
  exit 1
fi

ensure_kit

echo "${GREEN}Creating sandbox $SANDBOX_NAME...${RESET}"
echo "\n"

create_sandbox "$SANDBOX_NAME"

echo "${GREEN}Setting sandbox vars...${RESET}"
echo "\n"

set_sandbox_var TM_WINDOW_ID "$WINDOW_ID"
set_sandbox_var TM_PORT "$PORT"
sbx policy allow network --sandbox "$SANDBOX_NAME" localhost:"$PORT"

echo "${GREEN}Starting listener on $PORT.${RESET}"
"$HOME/.config/sbx/status_listener.sh" "$PORT" "$WINDOW_ID" &
LISTENER_PID=$!
trap cleanup EXIT INT TERM

echo "${GREEN}Running sandbox...${RESET}"
sbx run --name "$SANDBOX_NAME"
