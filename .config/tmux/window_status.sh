#!/usr/bin/env zsh

# window_status.sh
#
# Sets tmux window-level variable @window_status then refreshes
# status line.
#
# Usage:
#   window_status.sh [running|waiting|stop|done|idle]
#
# Arguments:
#   running   Program is actively working
#   waiting   Program is waiting for user input
#   stop      Program is idle
#   done      Alias for stop
#   idle      Alias for stop
#   end       Program ended / exited, unsets @window_status

[[ -z "$TMUX" ]] && exit 0

STATUS=${1:-end}

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
  stop|done|idle)
    tmux set -wq -t "${TARGET[@]}" @window_status "stop"
    ;;
  end)
    tmux set -wq -t "${TARGET[@]}" @window_status ""
    ;;
esac

tmux refresh-client -S
