#!/usr/bin/env zsh

"$HOME/.config/tmux/tree_rebuild.sh"

CLIENT_WIDTH=$(tmux display-message -p '#{client_width}')

if (( "$CLIENT_WIDTH" < 160 )); then
  # no preview when not much space
  cat "$HOME/.config/tmux/tmp_tree_cache.txt" |
    fzf \
      --color=bg:#020223,bg+:#020223 \
      --no-scrollbar \
      --no-info \
      --reverse \
      --bind 'ctrl-r:execute-silent("$HOME/.config/tmux/tree_rebuild.sh 1")' \
      --bind 'ctrl-r:+reload(cat "$HOME/.config/tmux/tmp_tree_cache.txt")' \
      --ansi |
      sed -E 's/(.*)\((.*)\)/\2/' |
      xargs tmux switch-client -t
else
  cat "$HOME/.config/tmux/tmp_tree_cache.txt" |
    fzf \
      --color=bg:#020223,bg+:#020223 \
      --no-scrollbar \
      --no-info \
      --reverse \
      --preview-window=right,noinfo \
      --preview "echo {} | sed -E 's/(.*)\((.*)\)/\2.1/' | xargs tmux capture-pane -p -t" \
      --bind 'ctrl-r:execute-silent("$HOME/.config/tmux/tree_rebuild.sh 1")' \
      --bind 'ctrl-r:+reload(cat "$HOME/.config/tmux/tmp_tree_cache.txt")' \
      --ansi |
      sed -E 's/(.*)\((.*)\)/\2/' |
      xargs tmux switch-client -t
fi
