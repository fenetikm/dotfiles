#!/usr/bin/env zsh

SNAME="$1"
WINDOW_ID=$(tmux display-message -p '#{window_id}')
BASE_PORT=9999

find_free_port() {
  local p=$BASE_PORT
  local MAX=$(( p + 20 ))
  while lsof -iTCP:"$p" -sTCP:LISTEN -nP >/dev/null 2>&1; do
    if [[ "$p" == "$MAX" ]]; then
      echo "Couldn't find a free port"
      exit 1
    fi
    (( p++ ))
  done
  echo "$p"
}

PORT=$(find_free_port)

create_sandbox() {
  sbx create claude --kit ./.local/sbx --name "$1" .
}

set_sandbox_var() {
  sbx exec -d "$SNAME" bash -c "echo 'export $1=$2' >> /etc/sandbox-persistent.sh"
}

check_exists() {
  sbx ls --json | jq -e --arg n "$1" 'any(.sandboxes[]; .name == $n)' >/dev/null
}

cleanup() {
  [[ -n "$CLEANED" ]] && return
  CLEANED=1
  echo "Cleaning up"
  [[ -n "$LISTENER_PID" ]] && kill "$LISTENER_PID" 2>/dev/null
  sbx rm -f "$SNAME" 2>/dev/null
}

if check_exists "$SNAME"; then
  echo "Sandbox exists, remove it first"
  exit 0
fi

echo "Creating sandbox $SNAME"
create_sandbox "$SNAME"
echo "Setting sandbox vars"
set_sandbox_var TM_WINDOW_ID "$WINDOW_ID"
set_sandbox_var TM_PORT "$PORT"
sbx policy allow network --sandbox "$SNAME" localhost:"$PORT"
echo "Starting listener on $PORT"
"$HOME/.config/sbx/status_listener.sh" "$PORT" "$WINDOW_ID" &
LISTENER_PID=$!
trap cleanup EXIT INT TERM
sbx run "$SNAME"
