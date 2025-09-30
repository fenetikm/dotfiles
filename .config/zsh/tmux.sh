#!/usr/bin/env zsh

# used in .config/tmux/sesh.sh
tmux_setup() {
  # either use the .tmux.setup in current directory or from root
  if [[ -x ./.tmux.setup ]]; then
    ./.tmux.setup $1
  elif [[ -x ~/.tmux.setup ]]; then
    ~/.tmux.setup $1
  else
    echo "Oh noes! Couldn't find a .tmux.setup file."
  fi
}

# tmux aliases
alias mn='~/.config/tmux/sesh.sh'
alias ma='tmux attach-session'
alias mw='tmux new-window -n'
