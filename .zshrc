# disable the update prompt
DISABLE_UPDATE_PROMPT=true

# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh
source $ZSH/oh-my-zsh.sh

PROMPT_LEAN_VIMODE=1
PROMPT_LEAN_VIMODE_FORMAT="%F{10}  %f"
PROMPT_LEAN_TMUX=''
PROMPT_LEAN_COLOR1='249'
PROMPT_LEAN_COLOR2='245'
PROMPT_LEAN_COLOR3='207'
PROMPT_LEAN_GIT_STYLE='FAT'
PROMPT_LEAN_SEP=''
PROMPT_LEAN_SYMBOL='==>'
# PROMPT_LEAN_PATH_SED='s/Documents\/Work/\$/g'
PROMPT_LEAN_PATH_SED=''
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

# change directory by just typing it's name
setopt AUTO_CD
# use the hash in the prompt
setopt AUTO_NAME_DIRS
# push previous directory on to the stack
setopt AUTO_PUSHD
# don't ignore dups in stack
unsetopt PUSHD_IGNORE_DUPS
# exchage meanings of + and -
setopt PUSHD_MINUS

# completion
setopt AUTO_MENU
setopt ALWAYS_TO_END
setopt COMPLETE_IN_WORD
unsetopt FLOW_CONTROL
unsetopt MENU_COMPLETE
zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z-_}={A-Za-z_-}' 'r:|=*' 'l:|=* r:|=*'
zstyle ':completion::complete:*' use-cache 1
zstyle ':completion::complete:*' cache-path $ZSH_CACHE_DIR
zstyle ':completion:*' list-colors ''
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'

# darkish grey suggestion colour
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=242'
# complete the suggestion
bindkey '^E' autosuggest-accept
# run the suggestion now
bindkey '^[[25~' autosuggest-execute

# history options
# save timestamp and duration
setopt EXTENDED_HISTORY
# get rid of duplicate items when needed
setopt HIST_EXPIRE_DUPS_FIRST
# ignore putting duplicates in the history
setopt HIST_IGNORE_DUPS
# ignore spaces
setopt HIST_IGNORE_SPACE
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY

alias l='ls -alhF'
alias lvr='ls -alR > /dev/null'

alias mv='/bin/mv -i'
alias rm='/bin/rm -i'

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
alias top='sudo htop'
alias du="ncdu --color dark -rr -x --exclude .git --exclude node_modules"

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
alias gs='git s'
alias gd='git di'
alias gl='git l'
alias gffp='git flow feature publish'
alias gffs='git flow feature start'
alias gp='git push'
alias gb='git branch'
alias g='_f() { if [[ $# == 0 ]]; then git status --short --branch; else git "$@"; fi }; _f'

# git dotfiles management
alias y='yadm'

# tmux aliases
alias ms='~/.config/tmux/split.sh'
alias mn='~/.config/tmux/new.sh'
alias mnd='~/.config/tmux/drupal.sh'
alias mnw='~/.config/tmux/tw.sh'
alias mpc='~/.config/tmux/pc.sh'
alias mtest='~/.config/tmux/testing.sh'
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

# robo
# alias rb='./vendor/bin/robo'
alias rb='~pcp/vendor/bin/robo'

#virtual box
alias vbox='vboxmanage'
alias vboxr='vboxmanage list runningvms'

#docker
alias docker-restart="osascript -e 'quit app \"Docker\"' && open -a Docker"

#specific ssh
alias wallissh='ssh -p 2223 root@103.21.48.192'
alias redyssh='ssh theoryz4@122.129.219.79 -p 2022 -i id_dsa'

#ranger
alias r='ranger'

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

#rando
alias dr2='run-drush'
alias dbd='rb db:dump --path="dump.sql" --sed=gsed --dirty'
alias dbl='rb db:load --path="dump.sql"'
alias dblp='rb db:load --path="patient.sql"'

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
do_z() {
  local dir
  dir="$(fasd -Rdl "$1" | fzf --bind 'ctrl-j:down,ctrl-k:up' -1 -0 --no-sort +m)" && cd "${dir}" || return 1
}
alias z="do_z"

# fzf for checking out a branch
fzf_git_checkout() {
  result=$(git branch -a --color=always | grep -v '/HEAD\s' | sort |
    fzf --height 50% --border --ansi --tac --preview-window right:70% \
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
alias fco="fzf_git_checkout"

# fzf git log
fzf_git_log() {
    local commits=$(
      git ll --color=always "$@" |
        fzf --ansi --no-sort --height 100% \
            --preview "echo {} | grep -o '[a-f0-9]\{7\}' | head -1 |
                       xargs -I@ sh -c 'git show --color=always @'"
      )
    if [[ -n $commits ]]; then
        local hashes=$(printf "$commits" | cut -d' ' -f2 | tr '\n' ' ')
        git show $hashes
    fi
}
alias fgl="fzf_git_log"

# fzf find a file by name and edit
fzf_find_edit() {
    local file=$(
      fzf --no-multi --preview 'bat --color=always --line-range :500 {}'
      )
    if [[ -n $file ]]; then
        $EDITOR $file
    fi
}
alias ffe='fzf_find_edit'

# fzf find a file with text and edit
fzf_grep_edit(){
    if [[ $# == 0 ]]; then
        echo 'Error: search term was not provided.'
        return
    fi
    local match=$(
      rg --color=never --line-number "$1" |
        fzf --no-multi --delimiter : \
            --preview "bat --color=always --line-range {2}: {1}"
      )
    local file=$(echo "$match" | cut -d':' -f1)
    if [[ -n $file ]]; then
        $EDITOR $file +$(echo "$match" | cut -d':' -f2)
    fi
}
alias fge='fzf_grep_edit'

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
export PATH=/opt/local/bin:/opt/local/sbin:$PATH

# ripgrep configufation
export RIPGREP_CONFIG_PATH="/Users/mjw/.rgrc"

#load nvm
export NVM_DIR="/Users/mjw/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm

lpass_export() {
  LPASS=`lpass status`
  if [[ "$LPASS" != *"Logged in"* ]]; then
    lpass login michael@theoryz.com.au
  fi
  KEYS=`lpass show --notes keys`
  while read -r key; do
      export "$key"
  done <<< "$KEYS"
}

#load local env keys
local_export() {
  KEYS=`cat ~/.env`
  while read -r key; do
      export "$key"
  done <<< "$KEYS"
}
local_export

source <(antibody init)
source ~/.zsh_plugins.sh
# antibody bundle < ~/.zsh_plugins.txt
# antibody bundle < ~/.zsh_plugins.txt > ~/.zsh_plugins.sh

#zsh-history-substring-search key bindings
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
export PATH="/usr/local/opt/php@7.3/bin:$PATH"
export PATH="/usr/local/opt/php@7.3/sbin:$PATH"
