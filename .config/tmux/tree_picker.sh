#!/usr/bin/env zsh

"$HOME/.config/tmux/tree_rebuild.sh"

cat "$HOME/.config/tmux/tree_cache.txt" | fzf --reverse --ansi --preview "echo {} | sed -E 's/(.*)\((.*)\)/\2.1/' | xargs tmux capture-pane -p -t" | sed -E 's/(.*)\((.*)\)/\2/' | xargs tmux switch-client -t
