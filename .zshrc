# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Would you like to use another custom folder than $ZSH/custom?
ZSH_CUSTOM=~/.zsh-themes
ZSH_THEME="bullet-train"
BULLETTRAIN_DIR_BG='white'
BULLETTRAIN_DIR_FG='black'
BULLETTRAIN_GIT_BG='black'
BULLETTRAIN_GIT_FG='white'
BULLETTRAIN_STATUS_BG='cyan'
BULLETTRAIN_STATUS_FG='default'
BULLETTRAIN_GIT_UNTRACKED="%F{magenta}✭%F{black}"
BULLETTRAIN_PROMPT_SEPARATE_LINE='false'
BULLETTRAIN_PROMPT_ORDER=(
  context
  dir
  git
  status
)

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

source $ZSH/oh-my-zsh.sh

# User configuration

export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"
export PATH="$PATH:$HOME/.composer/vendor/bin"

#additions as per drbunsen.org
export EDITOR="nvim"
bindkey -v 

# vi style incremental search
bindkey '^R' history-incremental-search-backward
bindkey '^S' history-incremental-search-forward
bindkey '^P' history-search-backward
bindkey '^N' history-search-forward  

setopt AUTO_CD

alias l='ls -alhF'
alias uas='cd ~/Documents/Work/UofA/scholarships/ua-scholarships6/'
alias arop='cd ~/Documents/Work/UofA/arop/vms/ua-arop2/'
alias bd='cd ~/Documents/Work/UofA/bank_details/vms/ua-bank-details-1/'
alias docs='cd ~/Documents/Work/UofA/ua-docs/vms/ua-docs/'
alias sys='cd ~/Documents/Work/internal/vms/sys/'
alias cusoon='cd ~/Documents/Work/jubn_cusoon/vms/cusoon'

alias uakeys='ssh-add ~/.ssh/uofa/keys/ua_lamp_docker/id_rsa && ssh-add ~/.ssh/uofa/keys/jenkins_deployment_key/id_rsa'
alias ecd='~/Eclipse.app/Contents/Eclipse/eclimd'

alias -s php=nvim
alias -s module=nvim
alias -s scss=nvim
alias -s css=nvim
alias -s tpl=nvim
alias -s yml=nvim

alias nv='nvim'
alias v='nvim'

alias gs='git status'
alias gd='git diff'
alias gl='git log'
alias gffp='git flow feature publish'
alias gfff='git flow feature finish'

#vagrant exec binstubs
alias rb='vbin/robo'
alias dh='vbin/drush'
alias dr='vbin/drupal'
alias vs='vagrant ssh'
alias co='vbin/codecept'

alias wallissh='ssh -p 2223 root@103.21.48.192'
alias redyssh='ssh theoryz4@122.129.219.79 -p 2022 -i id_dsa'

alias de='eval $(docker-machine env default)'

# Make CTRL-Z background things and unbackground them.
function fg-bg() {
  if [[ $#BUFFER -eq 0 ]]; then
    fg
  else
    zle push-input
  fi
}
zle -N fg-bg
bindkey '^Z' fg-bg


stty start undef stop undef

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# setup fasd
 eval "$(fasd --init auto)"

# fasd z replacement using fzf
z() {
  local dir
  dir="$(fasd -Rdl "$1" | fzf -1 -0 --no-sort +m)" && cd "${dir}" || return 1
}
export PATH="/usr/local/opt/ncurses/bin:$PATH"
