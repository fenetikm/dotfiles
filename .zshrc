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

# Specify zsh plugins.
plugins=(git colored-man)

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

# directory aliases
alias aa='cd ~/Documents/Work/UofA/aa/vms/ua-aa-1'
alias uas='cd ~/Documents/Work/UofA/scholarships/ua-scholarships6/'
alias uacs='cd ~/Documents/Work/UofA/api/vms/ua-content-store/'
alias arop='cd ~/Documents/Work/UofA/arop/vms/ua-arop2/'
alias ccsp='cd ~/Documents/Work/UofA/ccsp/vms/ua-ccsp'
alias refactor='cd ~/Documents/Work/UofA/refactor/vms/refactor'
alias stui='cd ~/Documents/Work/UofA/stui/vms/ua-stui'
alias bd='cd ~/Documents/Work/UofA/bank_details/vms/ua-bank-details-1/'
alias docs='cd ~/Documents/Work/UofA/ua-docs/vms/ua-docs/'
alias sys='cd ~/Documents/Work/internal/vms/sys/'
alias cusoon='cd ~/Documents/Work/jubn_cusoon/vms/cusoon'
alias e='exa -algB'
alias c='pygmentize'

alias uakeys='ssh-add ~/.ssh/uofa/keys/ua_lamp_docker/id_rsa && ssh-add ~/.ssh/uofa/keys/jenkins_deployment_key/id_rsa'
alias ecd='~/Eclipse.app/Contents/Eclipse/eclimd'

# nvim aliases
alias nv='nvim'
alias v='nvim'
alias -s php=nvim
alias -s module=nvim
alias -s scss=nvim
alias -s css=nvim
alias -s tpl=nvim
alias -s yml=nvim

# git aliases
alias g='git'
alias gs='git status'
alias gd='git diff'
alias gl='git log'
alias gffp='git flow feature publish'
alias gffs='git flow feature start'
alias gp='git push'
alias gb='git branch'

# tmux aliases
alias txd='~/.config/tmux/drupal.sh'
alias txs='~/.config/tmux/split.sh'
alias txn='~/.config/tmux/new.sh'
alias txa='tmux attach -t'
alias txl='tmux ls'

#jira aliases
alias j='jira'
alias ji="~/.config/zsh/jira.zsh 'jira mine'"
alias jo="~/.config/zsh/jira.zsh 'jira open'"
alias ja="~/.config/zsh/jira.zsh 'jira all_mine'"

#taskwarrior aliases
tw_filter_project() { 
  task project:"$1" "${@:2}"
}
tw_add_with_project() {
  task add project:"$1" "${@:2}"
}
tw_add() {
  task add $@
}
alias tw='task'
alias twp='tw_filter_project'
alias twa='tw_add'
alias twap='tw_add_with_project'
alias tws='task +ACTIVE stop'
alias twd='task +ACTIVE done'

# vagrant exec binstubs
alias rb='vbin/robo'
alias rbc='ls -alR > /dev/null && vbin/robo build:clean'
# alias dr='vbin/drush'
alias dc='vbin/drupal'
alias vs='vagrant ssh'
alias co='vbin/codecept'

#virtual box
alias vbox='vboxmanage'
alias vboxr='vboxmanage list runningvms'

alias wallissh='ssh -p 2223 root@103.21.48.192'
alias redyssh='ssh theoryz4@122.129.219.79 -p 2022 -i id_dsa'

alias de='eval $(docker-machine env default)'

alias ..='cd ..'

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
export PATH="$GOPATH/bin:$PATH"

# OPAM configuration
. /Users/mjw/.opam/opam-init/init.zsh > /dev/null 2> /dev/null || true
