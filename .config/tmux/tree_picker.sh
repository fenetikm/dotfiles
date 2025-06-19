#!/usr/bin/env zsh

"$HOME/.config/tmux/tree_rebuild.sh"

cat "$HOME/.config/tmux/tree_cache.txt" |
  fzf --color=bg:#020223,bg+:#020223 --reverse --ansi --preview "echo {} | sed -E 's/(.*)\((.*)\)/\2.1/' | xargs tmux capture-pane -p -t" |
  sed -E 's/(.*)\((.*)\)/\2/' |
  xargs tmux switch-client -t
