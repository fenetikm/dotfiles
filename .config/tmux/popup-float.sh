#!/usr/bin/env zsh

# floating pane (tmux 3.8+) replacement for popup.sh, same arguments so a
# binding can be switched over by changing the script name only
#
# usage:
# - popup-float.sh <script> <title> [script args] [max_width]
# - popup-float.sh temp <name> <command|new-pane flags> [max_width]
# - popup-float.sh persist <name> <command|new-pane flags>
# - popup-float.sh --focus <any of the above>
#
# each popup is a floating pane in the current window, tagged with the pane
# option @popup=<name>; running the same binding again toggles it:
# - popup is focused        -> close it
# - popup open, not focused -> focus it and bring it to the front
# - another popup is open   -> close that one, open this one
#
# differences from popup.sh:
# - panes are per window, a popup stays in the window it was opened in
# - prefix bindings work inside a popup (it is a real pane, not a nested client)
# - `generic` and `temp` behave the same, the nested session in `temp` existed
#   to avoid resizes, a floating pane is created at its final size
#
# `persist` keeps the nested session from popup.sh: the command runs in a
# detached `<name>_popup_` session, the popup is a modal floating pane running
# `tmux attach` to it, closing the popup only detaches; this is because a modal
# pane can't be moved (break-pane / swap-pane refuse), so a stashed real pane
# could never be modal; -K sends all keys, prefix too, to the inner client, so
# bindings (copy mode, this toggle) act on the inner session like popup.sh did
#
# `--focus` opens the popup over a blank `_focus_` window so nothing shows
# behind it; this script runs as that window's only tiled pane, opens the
# popup, then waits for it, so the window closes once no popup is left

# set when running as the base pane of a `_focus_` window
FOCUS_BASE=0

if [[ "$1" == "--focus" ]]; then
  shift
  if [[ -n "$POPUP_FOCUS_BASE" ]]; then
    FOCUS_BASE=1
    # the popup takes focus, so this blank pane would get the inactive
    # window-style, give it the active one so it looks like the usual backdrop
    tmux set -p -t "$TMUX_PANE" window-style \
      "$(tmux display-message -p -t "$TMUX_PANE" '#{window-active-style}')"
  else
    # @popup last, it can be empty and tab is IFS whitespace, so it'd collapse
    IFS=$'\t' read -r FOCUS_SESSION FOCUS_PATH FOCUS_POPUP < <(
      tmux display-message -p -F $'#{session_name}\t#{pane_current_path}\t#{@popup}'
    )
    # already in a popup, so nothing of ours to hide, carry on as normal
    if [[ -z "$FOCUS_POPUP" && "$FOCUS_SESSION" != *_popup_* ]]; then
      # `_focus_` is matched by @sidebar_exclude_windows in ~/.tmux.conf
      # `A` for absolute path, `q` quotes each arg, `j` joins them
      FOCUS_ARGV=("${0:A}" --focus "$@")
      tmux new-window -n _focus_ -c "$FOCUS_PATH" -e POPUP_FOCUS_BASE=1 \
        "${(j: :)${(q)FOCUS_ARGV[@]}}"
      exit 0
    fi
  fi
fi

# Percentage of the window to take up
PERC=85

# ... but then take up more than that if less than these minimum values
MIN_WIDTH=140
MIN_HEIGHT=50

# Always have at least this margin from the edge
MARGIN=6

# solid bg, vs #020221 which is configured transparent in kitty
BG="#020223"

# border matches the solid bg, same as popup-border-style in the falcon theme
BORDER_STYLE="fg=#57575e,bg=$BG"

# modal: the popup keeps focus and the panes behind ignore input, like
# display-popup did; prefix bindings still work so the toggle can close it
MODAL=1

# the server can be older than the client binary (it keeps running across an
# upgrade until restarted), only use -O if this server's new-pane has it
if (( MODAL )) && [[ ! "$(tmux list-commands new-pane)" =~ '\[-[[:alpha:]]*O[[:alpha:]]*\]' ]]; then
  MODAL=0
fi

# extra new-pane flags for open_popup
POPUP_FLAGS=()

WIN_FORMAT=$'#{window_id}\t#{window_width}\t#{window_height}\t#{pane_id}'
# the focus base pane is not a run-shell from a binding, so target it directly
TARGET=()
(( FOCUS_BASE )) && TARGET=(-t "$TMUX_PANE")
IFS=$'\t' read -r WIN_ID WIN_W WIN_H CUR_PANE CUR_SESSION SOCKET < <(
  tmux display-message -p "${TARGET[@]}" -F "$WIN_FORMAT"$'\t#{session_name}\t#{socket_path}'
)

# run from inside a persistent popup (keys go to the inner client), so act as
# if from the outer pane hosting it
if [[ "$CUR_SESSION" == *_popup_* ]]; then
  HOST="$(tmux list-panes -a -f "#{==:#{@popup_session},$CUR_SESSION}" -F '#{pane_id}' | head -1)"
  if [[ -n "$HOST" ]]; then
    IFS=$'\t' read -r WIN_ID WIN_W WIN_H CUR_PANE < <(
      tmux display-message -p -t "$HOST" -F "$WIN_FORMAT"
    )
  fi
fi

# size: arg is the optional max width
calc_size() {
  local max_width="$1"

  WIDTH=$(( WIN_W * PERC / 100 ))
  if [[ -n "$max_width" ]] && (( WIDTH > max_width )); then
    WIDTH=$max_width
  fi
  if (( WIDTH < MIN_WIDTH )); then
    if (( MIN_WIDTH + MARGIN > WIN_W )); then
      WIDTH=$(( WIN_W - MARGIN ))
    else
      WIDTH=$MIN_WIDTH
    fi
  fi

  HEIGHT=$(( WIN_H * PERC / 100 ))
  if (( HEIGHT < MIN_HEIGHT )); then
    if (( MIN_HEIGHT + MARGIN > WIN_H )); then
      HEIGHT=$(( WIN_H - MARGIN ))
    else
      HEIGHT=$MIN_HEIGHT
    fi
  fi

  # -X / -Y position the border, which is included in the width / height
  POS_X=$(( (WIN_W - WIDTH) / 2 ))
  POS_Y=$(( (WIN_H - HEIGHT) / 2 ))
}

# id of the popup pane with this name in the current window, if any
find_popup() {
  tmux list-panes -t "$WIN_ID" -f "#{==:#{@popup},$1}" -F '#{pane_id}' 2>/dev/null | head -1
}

# close any popup in the current window
close_popups() {
  local pane
  for pane in ${(f)"$(tmux list-panes -t "$WIN_ID" -f '#{!=:#{@popup},}' -F '#{pane_id}')"}; do
    tmux kill-pane -t "$pane"
  done
}

# returns 0 if the toggle was handled and there is nothing left to do
toggle_existing() {
  local name="$1" pane
  pane="$(find_popup "$name")"
  [[ -z "$pane" ]] && return 1

  if [[ "$pane" == "$CUR_PANE" ]]; then
    tmux kill-pane -t "$pane"
  else
    tmux select-pane -t "$pane" \; move-pane -t "$pane" -P front
  fi
  return 0
}

# sets BASE and BASE_PATH, the pane a popup opens over and its directory
# call after close_popups: the pane that ran the binding may have been a (now
# closed) popup, the one beneath is the real target
read_base() {
  IFS=$'\t' read -r BASE BASE_PATH < <(
    tmux display-message -p -t "$WIN_ID" -F $'#{pane_id}\t#{pane_current_path}'
  )
}

# open_popup <name> <title> <new-pane args...>
# extra new-pane flags can be given in the POPUP_FLAGS array, sets POPUP_PANE
open_popup() {
  local name="$1" title="$2"
  shift 2

  read_base

  local flags=(-P -F '#{pane_id}' -t "$BASE" -c "$BASE_PATH"
    -x "$WIDTH" -y "$HEIGHT" -X "$POS_X" -Y "$POS_Y"
    -s "bg=$BG" -S "$BORDER_STYLE" -R "$BORDER_STYLE")
  (( MODAL )) && flags+=(-O)
  flags+=("${POPUP_FLAGS[@]}")

  POPUP_PANE="$(tmux new-pane "${flags[@]}" "$@")" || return 1

  # the title lives in a user option, apps are allowed to set the pane title
  tmux set -p -t "$POPUP_PANE" @popup "$name" \; \
    set -p -t "$POPUP_PANE" @popup_title "$title" \; \
    set -p -t "$POPUP_PANE" pane-border-format ' #{@popup_title} ' \; \
    set -p -t "$POPUP_PANE" pane-border-status top
}

# create_popup_session <session> <command|new-pane flags>, if not already there
create_popup_session() {
  local session="$1" init="$2"
  tmux has-session -t "=$session" 2>/dev/null && return

  # -2 for the popup border, so the size is final and nothing resizes on attach
  tmux new-session -d -s "$session" -x $(( WIDTH - 2 )) -y $(( HEIGHT - 2 )) -c "$BASE_PATH"
  tmux set -t "$session:" status off \; \
    set -t "$session:" detach-on-destroy on \; \
    set -w -t "$session:" pane-border-status off \; \
    set -w -t "$session:" window-active-style "bg=$BG"
  # respawn so that the command starts where the pty size is final
  # note: `init` may be a command _or_ bare flags (e.g. `-c <dir>`)
  [[ -n "$init" ]] && eval "tmux respawn-window -k -t '$session:' $init"
}

if [[ "$1" == "persist" ]]; then
  # persist <name> <command|new-pane flags>
  NAME="$2"
  SESSION="$2"_popup_
  toggle_existing "$NAME" && exit 0
  close_popups
  # one view of a session at a time, two clients of different sizes would
  # fight over the window size
  for pane in ${(f)"$(tmux list-panes -a -f "#{==:#{@popup_session},$SESSION}" -F '#{pane_id}')"}; do
    tmux kill-pane -t "$pane"
  done
  calc_size
  read_base
  create_popup_session "$SESSION" "$3"
  (( MODAL )) && POPUP_FLAGS=(-K)
  # TMUX unset, it is a nested client of this same server, so name the socket
  open_popup "$NAME" "$NAME" env -u TMUX tmux -S "$SOCKET" attach-session -t "=$SESSION" || exit 1
  tmux set -p -t "$POPUP_PANE" @popup_session "$SESSION"
elif [[ "$1" == "temp" ]]; then
  # temp <name> <command|new-pane flags> [max_width]
  NAME="$2"
  INIT="$3"
  toggle_existing "$NAME" && exit 0
  close_popups
  calc_size "$4"
  # init is either a command or bare new-pane flags (e.g. `-c <dir>`), and is
  # pre-quoted by the binding, so it is split with eval like popup.sh did
  eval "INIT_ARGS=($INIT)"
  open_popup "$NAME" "$NAME" "${INIT_ARGS[@]}"
else
  # <script> <title> [script args] [max_width]
  NAME="$2"
  toggle_existing "$NAME" && exit 0
  close_popups
  calc_size "$4"
  # one string, so it runs via the shell like display-popup -E did
  open_popup "$NAME" "$NAME" "$1 $3"
fi

# as the focus base pane, wait while any popup is open in this window; a few
# misses in a row are needed, so swapping one popup for another doesn't count
if (( FOCUS_BASE )); then
  MISSES=0
  while (( MISSES < 3 )); do
    sleep 0.2
    if [[ -n "$(tmux list-panes -t "$WIN_ID" -f '#{!=:#{@popup},}' -F 1 2>/dev/null)" ]]; then
      MISSES=0
    else
      (( MISSES++ ))
    fi
  done
fi
