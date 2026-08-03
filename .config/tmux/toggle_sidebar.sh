#!/bin/zsh -f
#
# Note: vibed by Cursor Composer 2.5
#       can see myself rewriting this one to match existing script style
#
# Toggle the agent sidebar, then equalise mains on close.
#   toggle_sidebar.sh       — current window (prefix+e)
#   toggle_sidebar.sh --all — all windows (prefix+E)

emulate -LR zsh
unsetopt verbose xtrace

typeset EQUALISE="$HOME/.config/tmux/equalise.sh"
typeset BIN
typeset -i all_windows=0

[[ "$1" == --all ]] && all_windows=1

BIN=$(tmux show-options -gv @agent_sidebar_bin 2>/dev/null) || exit 0
[[ -n "$BIN" && -x "$BIN" ]] || exit 0

equalise_windows() {
  typeset -a windows=("$@")
  typeset win
  [[ -x "$EQUALISE" ]] || return 0
  for win in "${windows[@]}"; do
    [[ -n "$win" ]] || continue
    /bin/zsh -f "$EQUALISE" --window "$win"
  done
}

sidebar_windows() {
  typeset -A seen=()
  typeset -a windows=()
  typeset line win role
  for line in "${(@f)$(tmux list-panes -a -F '#{window_id}|#{@pane_role}')}"; do
    [[ -n "$line" ]] || continue
    win=${line%%|*}
    role=${line#*|}
    [[ "$role" == sidebar ]] || continue
    [[ -n "${seen[$win]:-}" ]] && continue
    seen[$win]=1
    windows+=("$win")
  done
  print -lr -- "${windows[@]}"
}

if (( all_windows )); then
  typeset -a close_windows=($(sidebar_windows))
  typeset -i closing=${#close_windows[@]}

  "$BIN" toggle-all

  if (( closing )) && [[ -x "$EQUALISE" ]]; then
    equalise_windows "${close_windows[@]}"
  fi
else
  typeset WINDOW PANE_PATH
  WINDOW=$(tmux display-message -p '#{window_id}')
  PANE_PATH=$(tmux display-message -p '#{pane_current_path}')

  typeset -i had_sidebar=0
  tmux list-panes -t "$WINDOW" -F '#{@pane_role}' 2>/dev/null | grep -qx sidebar && had_sidebar=1

  "$BIN" toggle "$WINDOW" "$PANE_PATH"

  if (( had_sidebar )) && [[ -x "$EQUALISE" ]]; then
    /bin/zsh -f "$EQUALISE" --window "$WINDOW"
  fi
fi
