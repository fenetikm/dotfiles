#!/usr/bin/env zsh

# used in .config/tmux/sesh.sh
tmux_setup() {
  if [[ "$1" == "auto" ]]; then
    if [[ -x ./.tmux.setup ]]; then
      # either use the .tmux.setup in current directory or from root
      ./.tmux.setup $2
    elif [[ -x ~/.tmux.setup ]]; then
      ~/.tmux.setup $2
    else
      echo "Oh noes! Couldn't find a .tmux.setup file."
    fi
  else
    if [[ -x "$HOME/.config/tmux/templates/$1/.tmux.setup" ]]; then
      ~/.config/tmux/templates/$1/.tmux.setup
    else
      echo "Oh noes! Couldn't find a matching template .tmux.setup file."
    fi
  fi
}

# tmux aliases
alias mn='~/.config/tmux/sesh.sh'
alias ma='tmux attach-session'
alias mw='tmux new-window -n'
alias mnphp='~/.config/tmux/sesh.sh php'
