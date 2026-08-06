#!/usr/bin/env bash

# focus an agent pane, used from the terminal notifier script

set -euo pipefail

PANE_ID="$1"
SESSION_ID="$2"
WINDOW_ID="$3"

# need the path to resolve tmux
export PATH="/opt/homebrew/bin:/usr/local/bin:${PATH:-/usr/bin:/bin:/usr/sbin:/sbin}"

TMUX_BIN="$(command -v tmux)"
if [[ -z "$TMUX_BIN" ]]; then
  echo "focus-agent: tmux not found (PATH=$PATH)" >&2
  exit 1
fi

osascript -e 'tell application "kitty" to activate'

# Jump to the pane that fired the notification.
"$TMUX_BIN" switch-client -t "$SESSION_ID" 2>/dev/null \
  || "$TMUX_BIN" switch-client -t "$PANE_ID" 2>/dev/null \
  || true
"$TMUX_BIN" select-window -t "$WINDOW_ID" 2>/dev/null || true
"$TMUX_BIN" select-pane -t "$PANE_ID"
