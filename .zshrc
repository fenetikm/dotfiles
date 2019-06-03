# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh
source $ZSH/oh-my-zsh.sh

PROMPT_LEAN_VIMODE=1
PROMPT_LEAN_VIMODE_FORMAT="%F{red}[VI] %f"
PROMPT_LEAN_TMUX=''
PROMPT_LEAN_COLOR1='249'
PROMPT_LEAN_COLOR2='245'
PROMPT_LEAN_COLOR3='207'
PROMPT_LEAN_GIT_STYLE='FAT'
PROMPT_LEAN_SEP=''
PROMPT_LEAN_SYMBOL='==>'
PROMPT_LEAN_PATH_SED='s/Documents\/Work/\$/g'
source ~/.config/zsh/lean/lean.plugin.zsh

# exa colours
source ~/Documents/Work/internal/vim/colors/falcon/exa/EXA_COLORS

# zsh falcon colouring
source ~/Documents/Work/internal/vim/colors/falcon/zsh/falcon.zsh

# User configuration.
export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"
export PATH="$PATH:$HOME/.composer/vendor/bin"

# set how long to wait for a sequence
KEYTIMEOUT=1

#additions as per drbunsen.org
export EDITOR="nvim"
bindkey -v

# vi style incremental search
# bindkey '^R' history-incremental-search-backward
# bindkey '^S' history-incremental-search-forward
bindkey '^P' history-search-backward
bindkey '^N' history-search-forward

setopt AUTO_CD

alias l='ls -alhF'
alias lvr='ls -alR > /dev/null'

# reload
alias reload="source ~/.zshrc"

# directory hashes
# to use: e.g. cd ~aa
source ~/.config/zsh/directory_hashes.zsh
alias e='exa -algB'
alias et='exa -algB --tree'
alias cat='bat'
alias c='bat'
alias ping='prettyping'

# keys
alias uakeys='ssh-add ~/.ssh/uofa/keys/ua_lamp_docker/id_rsa && ssh-add ~/.ssh/uofa/keys/jenkins_deployment_key/id_rsa'

run_vim_leader() {
  com="NormLead $1"
  nvim -c "$com"
}

# nvim aliases
alias nv='nvim'
alias v='nvim'
alias sv='sudo nvim'
alias vl='run_vim_leader'

# suffix aliases: typing name of file with suffix will use that program
alias -s php=nvim
alias -s module=nvim
alias -s scss=nvim
alias -s css=nvim
alias -s tpl=nvim
alias -s yml=nvim

#global aliases, substitute anywhere
alias -g L="| less"
alias -g T="| tail"
alias -g TL="| tail -20"
alias -g C="| wc -l"
alias -g G="| grep"

# git aliases
alias g='git'
alias gs='git s'
alias gd='git di'
alias gl='git l'
alias gffp='git flow feature publish'
alias gffs='git flow feature start'
alias gp='git push'
alias gb='git branch'

# git dotfiles management
alias y='yadm'

# tmux aliases
alias ms='~/.config/tmux/split.sh'
alias mn='~/.config/tmux/new.sh'
alias mnd='~/.config/tmux/drupal.sh'
alias mnw='~/.config/tmux/tw.sh'
alias ma='tmux attach -t'
alias ml='tmux ls'

#jira aliases
alias j='jira'
alias ji="~/.config/zsh/jira.zsh 'jira mine'"
alias jo="~/.config/zsh/jira.zsh 'jira open'"
alias ja="~/.config/zsh/jira.zsh 'jira all_mine'"

# Taskwarrior aliases
source ~/.config/task/commands.zsh

# vagrant exec binstubs
alias vr='vbin/robo'
alias vb='vbin/bash'
alias vd='vbin/drush'
alias vc='ls -alR > /dev/null && vbin/robo build:clean'

alias rb='./vendor/bin/robo'

#virtual box
alias vbox='vboxmanage'
alias vboxr='vboxmanage list runningvms'

#specific ssh
alias wallissh='ssh -p 2223 root@103.21.48.192'
alias redyssh='ssh theoryz4@122.129.219.79 -p 2022 -i id_dsa'

#ranger
alias r='ranger'

# alias de='eval $(docker-machine env default)'

alias ..='cd ..'

# find up the directory hierarchy
find-up () {
  SWD=$(pwd)
  while [[ $PWD != / ]] ; do
    find "$PWD" -maxdepth 1 -name "$@"
    cd ..
  done
  cd $SWD
}

run-drush () {
  ssh -F .vagrant/ssh_config -q -t default "bash -l -c 'cd /vagrant/app && /home/vagrant/.composer/vendor/bin/drush $@'"
}

alias dr2='run-drush'

# add in looking for the command down the tree...
# the idea begin:
# use the vbin version if it exists, or
# if in Vagrant directory do vagrant ssh -c, or
# run it if command, or
# throw error
vbb () {
  if [ -f vbin/$1 ]
  then
    vbin/$1
  elif [ -f Vagrantfile ]
  then
    vagrant ssh -c "cd /vagrant && $1 ${@:2}"
  else
    echo "echo"
  fi
}

alias dr='vbb bin/drush -r app'

# function to toggle fg/bg on control z
fancy-ctrl-z () {
  if [[ $#BUFFER -eq 0 ]]; then
    BUFFER="fg"
    zle accept-line
  else
    zle push-input
    zle clear-screen
  fi
}
zle -N fancy-ctrl-z
bindkey '^Z' fancy-ctrl-z

stty start undef stop undef

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# setup fasd
eval "$(fasd --init auto)"

# fasd z replacement using fzf
z() {
  local dir
  dir="$(fasd -Rdl "$1" | fzf -1 -0 --no-sort +m)" && cd "${dir}" || return 1
}

set_cursor_color() {
  # Plain iTerm2, no tmux
  if [[ -n $ITERM_SESSION_ID ]] && [[ -z $TMUX ]]; then
      printf '\033]Pl%s\033\\' "${1#\#}"
  else  # Plain xterm or tmux, sequence is the same
      printf '\033]12;%s\007' "$1"
  fi
}

export PATH="/usr/local/opt/ncurses/bin:$PATH"
export GOPATH="/Users/mjw/go"
export OCPATH="/Users/mjw/.minishift/cache/oc/v3.9.0/darwin"
export PATH="$GOPATH/bin:$OCPATH:$PATH"

# ripgrep configufation
export RIPGREP_CONFIG_PATH="/Users/mjw/.rgrc"

# OPAM configuration
. /Users/mjw/.opam/opam-init/init.zsh > /dev/null 2> /dev/null || true
