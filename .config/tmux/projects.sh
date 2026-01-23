#!/usr/bin/env zsh

FILE=$(ls -d -1 ~/Documents/Work/internal/projects/* |
  fzf --no-multi)
if [[ "$FILE" != "" ]]; then
  "$HOME"/.config/tmux/sesh.sh auto "$FILE"
fi

