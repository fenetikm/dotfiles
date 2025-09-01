#!/usr/bin/env zsh

"$HOME/.config/tmux/tree_rebuild.sh"

CLIENT_WIDTH=$(tmux display-message -p '#{client_width}')

if (( "$CLIENT_WIDTH" < 160 )); then
  # no preview when not much space
  cat "$HOME/.config/tmux/tmp_tree_cache.txt" |
    fzf --color=bg:#020223,bg+:#020223 --no-scrollbar --no-info --reverse --ansi |
      sed -E 's/(.*)\((.*)\)/\2/' |
      xargs tmux switch-client -t
else
  cat "$HOME/.config/tmux/tmp_tree_cache.txt" |
    fzf --color=bg:#020223,bg+:#020223 --no-scrollbar --no-info --reverse --ansi --preview-window=right,noinfo --preview "echo {} | sed -E 's/(.*)\((.*)\)/\2.1/' | xargs tmux capture-pane -p -t" |
      sed -E 's/(.*)\((.*)\)/\2/' |
      xargs tmux switch-client -t
fi
