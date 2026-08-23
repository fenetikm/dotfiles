#!/usr/bin/env zsh

# usage:
# - popup.sh [--focus] <popup name|script> [script arg1] [script arg2] [max_width]

CURRENT="$(tmux display-message -p -F "#{session_name}")"

PANE_PATH="$(tmux display-message -p -F "#{pane_current_path}")"

# show a popup over a blank window by running this same script via new-window creation
# The `_focus_` name is matched by @sidebar_exclude_windows in ~/.tmux.conf
if [[ "$1" == "--focus" ]]; then
  shift
  # already inside a popup, so there is nothing of ours to hide - carry on as normal
  if [[ "$CURRENT" != *_popup_* ]]; then
    # `A` for absolute path of the script
    FOCUS_ARGV=("${0:A}" "$@")
    # `j` joins the array, `q` does backslash escaping
    tmux new-window -n _focus_ -c "$PANE_PATH" "${(j: :)${(q)FOCUS_ARGV[@]}}"
    exit 0
  fi
fi

# Percentage of the screen to take up
PERC=85

# ... but then take up more than that if less than these minimum values
MIN_WIDTH=140
MIN_HEIGHT=50

# Get full window metrics from kitty, most reliable
read -r CURRENT_WIDTH CURRENT_HEIGHT < <(
  kitten @ ls 2>/dev/null | jq -r '
    .[] | select(.is_focused) | .tabs[] | select(.is_focused)
    | .windows[] | select(.is_focused) | "\(.columns) \(.lines)"
  '
)

# Tmux fallback
if [[ -z "$CURRENT_WIDTH" || -z "$CURRENT_HEIGHT" ]]; then
  CURRENT_WIDTH=$(tmux display -p "#{client_width}")
  CURRENT_HEIGHT=$(tmux display -p "#{client_height}")
fi

# Always have at least this margin from the edge
MARGIN=6
WIDTH=$(( CURRENT_WIDTH * PERC / 100 ))

# fixed / max width specified in arg $4
if [[ "$4" != "" ]]; then
  if (( WIDTH > "$4" )); then
    WIDTH="$4"
  fi
fi

if (( WIDTH < MIN_WIDTH )); then
  if (( MIN_WIDTH + MARGIN > CURRENT_WIDTH )); then
    WIDTH=$(( CURRENT_WIDTH - MARGIN ))
  else
    WIDTH=$(( MIN_WIDTH ))
  fi
fi
HEIGHT=$(( CURRENT_HEIGHT * PERC / 100 ))
if (( HEIGHT < MIN_HEIGHT )); then
  if (( MIN_HEIGHT + MARGIN > CURRENT_HEIGHT )); then
    HEIGHT=$(( CURRENT_HEIGHT - MARGIN ))
  else
    HEIGHT=$(( MIN_HEIGHT ))
  fi
fi

create_popup_session() {
  local SESSION="$1"
  local INIT="$2"
  tmux has-session -t "=$SESSION" 2>/dev/null && return
  # below, why -2? the session being created is to be attached _inside_ the popup and the popup has a border (1 on each side)
  # this way whatever runs inside doesn't have to contend with any resizing that would happen
  tmux new-session -d -s "$SESSION" -x $(( WIDTH - 2 )) -y $(( HEIGHT - 2 )) -c "$PANE_PATH"
  tmux set -t "$SESSION:" status off
  tmux set -t "$SESSION:" detach-on-destroy on
  tmux set -w -t "$SESSION:" pane-border-status off
  # this colour makes the bg solid vs #020221 which is configured transparent in kitty
  tmux set -w -t "$SESSION:" window-active-style "bg=#020223"
  # respawn so that the command starts where the pty size is final
  # note: `init` may be a command _or_ bare `tmux new` flags (e.g. `-c <dir>`),
  [[ -n "$INIT" ]] && eval "tmux respawn-window -k -t '$SESSION:' $INIT"
}

show_popup() {
  create_popup_session "$1" "$2"
  tmux display-popup -d '#{pane_current_path}' -b rounded -w "$WIDTH" -h "$HEIGHT" -s "bg=#020223" -E "tmux attach -t '=$1'"
}

dismiss_popup() {
  if [[ "$1" = *_popup_temp_ ]]; then
    tmux detach-client -s "$1"
    tmux kill-session -t "$1"
  else
    tmux detach-client
  fi
}

# "persist" for sessions that are created once, then attach/detach from
if [[ "$1" == "persist" ]]; then
  SESSION="$2"_popup_
  INIT_CMD="$3"
  if [[ "$CURRENT" = "$SESSION" ]]; then
    tmux detach-client
  elif [[ "$CURRENT" = *_popup_* ]]; then
    # popup currently displaying, dismiss it and show ours
    dismiss_popup "$CURRENT"
    show_popup "$SESSION" "$INIT_CMD"
  else
    show_popup "$SESSION" "$INIT_CMD"
  fi
# "temp" for throwaway sessions
elif [[ "$1" == "temp" ]]; then
  SESSION="$2"_popup_temp_
  INIT_CMD="$3"
  if [[ "$CURRENT" = "$SESSION" ]]; then
    tmux detach-client -s "$SESSION"
    tmux kill-session -t "$SESSION"
  elif [[ "$CURRENT" = *_popup_* ]]; then
    dismiss_popup "$CURRENT"
    show_popup "$SESSION" "$INIT_CMD"
  else
    show_popup "$SESSION" "$INIT_CMD"
  fi
else
  tmux display-popup -b rounded -w "$WIDTH" -h "$HEIGHT" -T "$2" -s "bg=#020223" -E "$1 $3"
fi
