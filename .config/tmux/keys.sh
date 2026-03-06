#!/usr/bin/env zsh

# show all the tmux key bindings
tmux list-keys |
  fzf \
    --color=bg:#020223,bg+:#020223 \
    --no-scrollbar \
    --no-info \
    --reverse \
    --ansi \
    --no-preview \
    --bind 'enter:ignore' || true
