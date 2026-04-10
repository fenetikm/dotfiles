#!/usr/bin/env zsh

# window_status.sh — update the tmux @window_status window option
#
# Sets a tmux window-level option that statusline components can read to display
# the current state of programs running. Refreshes the tmux client status line after each change.
# Exits immediately if run outside of a tmux session.
#
# Usage:
#   window_status.sh [running|waiting|stop|done|idle]
#
# Arguments:
#   running   Program is actively working — sets @window_status to "running"
#   waiting   Program is waiting for user input — sets @window_status to "waiting"
#   stop      Program has finished or is idle — unsets @window_status (default)
#   done      Alias for stop
#   idle      Alias for stop

[[ -z "$TMUX" ]] && exit 0

STATUS=${1:-stop}

TARGET=()
[[ -n "$TMUX_PANE" ]] && TARGET="$TMUX_PANE"

case $STATUS in
  running)
    tmux set -wq -t "${TARGET[@]}" @window_status "running"
    ;;
  waiting)
    tmux set -wq -t "${TARGET[@]}" @window_status "waiting"
    ;;
  error)
    tmux set -wq -t "${TARGET[@]}" @window_status "error"
    ;;
  stop|done|idle|end)
    tmux set -uwq -t "${TARGET[@]}" @window_status
    ;;
esac

tmux refresh-client -S
