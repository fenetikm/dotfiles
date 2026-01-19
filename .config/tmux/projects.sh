#!/usr/bin/env zsh

ls -d -1 ~/Documents/Work/internal/projects/* |
  fzf |
  read f && echo "$f" |
  sed 's|.*/||' |
  xargs -I {} "$HOME"/.config/tmux/sesh.sh auto {} "$f"

