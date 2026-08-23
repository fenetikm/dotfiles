#!/usr/bin/env zsh

# some general fzf magical functions

# fzf for checking out a branch
fzf_git_checkout() {
  result=$(git branch -a | grep -v '/HEAD\s' | sort |
    fzf --ansi --height 50% --border --tac --preview-window right:70% \
      --preview 'git log --oneline --graph --date=short --pretty="format:%C(auto)%cd %h%d %s" $(sed s/^..// <<< {} | cut -d" " -f1) | head -'$LINES |
    sed 's/^..//' | cut -d' ' -f1)

  if [[ $result != "" ]]; then
    if [[ $result == remotes/* ]]; then
      git checkout --track $(echo $result | sed 's#remotes/##')
    else
      git checkout "$result"
    fi
  fi
}

# fkill - kill processes - list only the ones you can kill. Modified the earlier script.
fzf_kill_process() {
    local pid
    if [ "$UID" != "0" ]; then
        pid=$(ps -f -u $UID | sed 1d | fzf -m | awk '{print $2}')
    else
        pid=$(ps -ef | sed 1d | fzf -m | awk '{print $2}')
    fi

    if [ "x$pid" != "x" ]
    then
        echo $pid | xargs kill -${1:-9}
    fi
}

alias fkill='fzf_kill_process'
alias fco="fzf_git_checkout"
