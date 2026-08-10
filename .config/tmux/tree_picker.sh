#!/usr/bin/env zsh

"$HOME/.config/tmux/tree_rebuild.sh"

CACHE="$HOME/.config/tmux/tmp_tree_cache.txt"

CLIENT_WIDTH=$(tmux display-message -p '#{client_width}')

# field 1 is the display text, 2 is the session id, 3 is the window id
# --with-nth hides the ids, they stay in the line fzf prints on accept
FZF_ARGS=(
  --color=bg:#020223,bg+:#020223
  --no-scrollbar
  --no-info
  --reverse
  --ansi
  --delimiter=$'\t'
  --with-nth='{1}'
  --bind 'ctrl-r:execute-silent("$HOME/.config/tmux/tree_rebuild.sh 1")'
  --bind 'ctrl-r:+reload(cat "$HOME/.config/tmux/tmp_tree_cache.txt")'
)

if (( CLIENT_WIDTH >= 160 )); then
  # no preview when not much space
  # --preview indexes the original line, so {3} is the window id
  FZF_ARGS+=(
    --preview-window=right,noinfo
    --preview 'tmux capture-pane -p -t {3}'
  )
fi

SELECTED=$(fzf "${FZF_ARGS[@]}" < "$CACHE")

# nothing picked, esc'd out
if [[ -z "$SELECTED" ]]; then
  exit 0
fi

FIELDS=("${(@ps:\t:)SELECTED}")

# target-session won't take a window id, so the session is switched by its
# own id and the window selected after
tmux switch-client -t "$FIELDS[2]"
tmux select-window -t "$FIELDS[3]"
