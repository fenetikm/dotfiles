# {{{ profiling start
# for profiling
# simple profiling of zsh related things
# zmodload zsh/zprof

# complete profiling of everything loaded in new shell
# zmodload zsh/datetime
# setopt promptsubst
# PS4='+$EPOCHREALTIME %N:%i> '
# exec 3>&2 2> startlog.$$
# setopt xtrace prompt_subst
# }}}

# {{{ prompt
# disable the update prompt
DISABLE_UPDATE_PROMPT=true
DISABLE_AUTO_TITLE=true

# disable update checking entirely
zstyle ':omz:update' mode disabled

# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh
source $ZSH/oh-my-zsh.sh

# remove the right prompt extra space at the end
ZLE_RPROMPT_INDENT=0
eval "$(starship init zsh)"
# }}}
# the following is now called from ~/.zshenv
# source ~/.config/zsh/directory_hashes.zsh

# eza colours
source $HOME/Documents/Work/internal/vim/colors/falcon/exa/EXA_COLORS_MODERN

export PATH=":/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"
export PATH="$PATH:$HOME/.composer/vendor/bin"

# set how long to wait for a sequence
KEYTIMEOUT=1

export EDITOR="nvim"
bindkey -v

# vi style incremental search
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

# completion options
setopt AUTO_MENU
setopt ALWAYS_TO_END
setopt COMPLETE_IN_WORD
unsetopt FLOW_CONTROL
unsetopt MENU_COMPLETE
# activate menu (using tab) selection
zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z-_}={A-Za-z_-}' 'r:|=*' 'l:|=* r:|=*'
zstyle ':completion::complete:*' use-cache 1
zstyle ':completion::complete:*' cache-path $ZSH_CACHE_DIR
zstyle ':completion:*' list-colors ''
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'

# formatting
zstyle ':completion:*:descriptions' format "$fg[yellow]%B--- %d%b"
zstyle ':completion:*:messages' format '%d'
zstyle ':completion:*:warnings' format "$fg[red]No matches for:$reset_color %d"
zstyle ':completion:*:corrections' format '%B%d (errors: %e)%b'

# complete the suggestion
bindkey '^E' autosuggest-accept
# run the suggestion now (ctrl-enter)
bindkey '^[[13;5u' autosuggest-execute

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

# {{{ aliases
alias lc='claude -p'

# -i to stop overwrite
alias mv='/bin/mv -i'
# -i to always ask for confirmation
alias rm='/bin/rm -i'
alias srm='sudo /bin/rm -i'
alias cx='chmod +x'

# this thins local snapshots, 50gb, urgency of 4 (highest)
alias tmthin='tmutil thinlocalsnapshots / $((50 * 1024 * 1024 * 1024)) 4'

# eza
alias e='eza -algB --group-directories-first'
alias et='eza -algB --tree'
# just the file names
alias es='eza --oneline --group-directories-first'
# just directories
alias ed='eza -algBD'

alias cat='bat'
alias c='bat'
alias ping='prettyping'
alias top='sudo htop'
alias du="ncdu --color off -rr -x --exclude .git --exclude node_modules"
alias ld="lazydocker"

# this supports doing something like `vl et`
# which loads up the tmux config via the <leader>et mapping
run_vim_leader() {
  nvim -c "NormLead $1"
}

# nvim aliases
alias nv='nvim'
alias v='nvim'
alias sv='sudo nvim'
alias vl='run_vim_leader'
alias vt='nvim TODO.md'

# edit the latest file in the directory
edit-latest() {
  nvim `print -rl *(D^/Om[1])`
}
alias el="edit-latest"
alias eo="nvim -c \"Oil\""

# suffix aliases: typing name of file with suffix will use that program
alias -s php=nvim
alias -s module=nvim
alias -s scss=nvim
alias -s css=nvim
alias -s tpl=nvim
alias -s yml=nvim
alias -s md=glow -p
export CLICOLOR_FORCE=1

# Global aliases, substitute anywhere
# e.g. `cat tmp.txt L`
alias -g L="| less"
alias -g T="| tail"
alias -g TL="| tail -20"
alias -g C="| pbcopy"
alias -g G="| grep"
alias -g R="| rg"

# Preview via fzf, edit with enter
alias -g P="| fzf --preview 'bat --color=always --line-range :500' --bind 'enter:execute(nvim {})'"
alias -g PMD="| fzf --preview 'echo {} | cut -d\" \" -f1 | sed \"s/://\" | xargs cat | bat --color=always --line-range :500 --language=md' --bind 'enter:execute(nvim {})'"
alias -g PG="| fzf --preview 'export CLICOLOR_FORCE=1; echo {} | cut -d\" \" -f1 | sed \"s/://\" | xargs cat | glow -s dark | cat' --bind 'enter:execute(nvim {})'"

# git aliases
alias gs='git s'
alias gd='git di'
alias gl='git l'
alias gp='git push'
alias gb='git branch'
alias g='_f() { if [[ $# == 0 ]]; then git status --short --branch; else git "$@"; fi }; _f'

# todo: shift these into a local thing
# robo
alias rb='~pcp/vendor/bin/robo'
alias rbd='docker exec -it -w /app nginx-pc vendor/bin/robo'

# redis
# see ~/.config/zsh/redis.sh

# tmux
# see ~/.config/zsh/tmux.sh

# todo: shift to local
new-fortnightly () {
  cd ~pcp/../../video/product_weekly
  local YEAR=$(date -u +%Y)
  local MONTH=$(date -u +%m)
  local DAY=$(date -u +%d)
  local FN=fortnightly_"$DAY"_"$MONTH"_"$YEAR".html
  cp template.html "$FN"
  nvim "$FN"
}

# todo: shift into local stuffs
# ssh
alias ventrassh='ssh theoryz4@s03de.syd6.hostingplatform.net.au -p 2683 -i $HOME/.ssh/id_dsa'

alias ..='cd ..'

# hugo stuff
# see ~/.config/zsh/hugo.sh

# love framework
alias love="/Applications/love.app/Contents/MacOS/love"

# majyk
devlog() {
  local MON=$(date -v -Mon +"%Y-%m-%d")
  if [[ -e "./content/devlog/$MON.md" ]]; then
    nvim "./content/devlog/$MON.md"
  elif [[ -e "./content/devlog/$MON/index.md" ]]; then
    nvim "./content/devlog/$MON/index.md"
  else
    hugo new "devlog/$MON.md" --editor nvim
  fi
}

# todo: shift to local
# rando
alias dbd='rb db:dump --path="tmp/dump.sql" --sed=gsed --dirty'
alias dbl='rb db:load --path="tmp/dump.sql"'
alias dbd2='rb db:dump --path="tmp/dump2.sql" --sed=gsed --dirty'
alias dbl2='rb db:load --path="tmp/dump2.sql"'
alias dbd3='rb db:dump --path="tmp/dump3.sql" --sed=gsed --dirty'
alias dbl3='rb db:load --path="tmp/dump3.sql"'
alias pcload='(cd ~pcp && rb db:load)'
alias pcup='docker-compose -f misc/docker/docker-compose.yml -f misc/docker/docker-compose.override.yml up -d'
alias pcdown='docker container stop $(docker container ls -aq)'

# yt things
alias ytbest='yt-dlp -f bestvideo+bestaudio --merge-output-format=mkv -4 --sleep-requests 2 --sleep-interval 2 --extractor-args "youtube:player-client=web_embedded"'
alias yt1080='yt-dlp -S "height:1080" --merge-output-format=mkv -4 --sleep-requests 2 --sleep-interval 2 --extractor-args "youtube:player-client=web_embedded"'
alias yt720='yt-dlp -S "height:720" --merge-output-format=mkv -4 --sleep-requests 2 --sleep-interval 2 --extractor-args "youtube:player-client=web_embedded"'
alias ytaudio='yt-dlp --extract-audio -4 --sleep-requests 2 --sleep-interval 2 --extractor-args "youtube:player-client=web_embedded" --audio-format mp3 --audio-quality 0'

# }}}

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

# what does this do?!
stty start undef stop undef

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# fzf
# see ~/.config/zsh/fzf.sh

# todo: update re new mac
# export PATH="/usr/local/opt/ncurses/bin:$PATH"
export GOPATH="$HOME/go"
export PATH="$GOPATH/bin:$PATH"
export PATH=/opt/local/bin:/opt/local/sbin:$PATH
export PATH=/Applications/kitty.app/Contents/MacOS:$PATH
export PATH="$HOME/tmp/google-cloud-sdk/bin":$PATH

# ripgrep config
# ripgrep configufation
export RIPGREP_CONFIG_PATH="$HOME/.rgrc"

# all files
alias rga="rg --hidden --no-ignore"
alias fda="fd --hidden --no-ignore"

# kitty
alias ki="kitty +kitten icat --align=left" #view image
alias kiw="kitty +kitten icat --align=left --background=#ffffff" #view image
# generate a clean, up to date kitty config, see https://sw.kovidgoyal.net/kitty/conf/
alias kc="kitty +runpy 'from kitty.config import *; print(commented_out_default_config())'"

# load local env keys
local_export() {
  KEYS=`cat ~/.env`
  while read -r key; do
      export "$key"
  done <<< "$KEYS"
}
# local_export

# fast antidote loading from the page
# Set the root name of the plugins files (.txt and .zsh) antidote will use.
zsh_plugins=${ZDOTDIR:-~}/.zsh_plugins

# Ensure the .zsh_plugins.txt file exists so you can add plugins.
[[ -f ${zsh_plugins}.txt ]] || touch ${zsh_plugins}.txt

# Lazy-load antidote from its functions directory.
# fpath=(~/.antidote/functions $fpath)
fpath=(/opt/homebrew/share/antidote/functions $fpath)
autoload -Uz antidote

# Generate a new static file whenever .zsh_plugins.txt is updated.
if [[ ! ${zsh_plugins}.zsh -nt ${zsh_plugins}.txt ]]; then
  antidote bundle <${zsh_plugins}.txt >|${zsh_plugins}.zsh
fi

# Source the static plugins file
source ${zsh_plugins}.zsh

# zsh-history-substring-search key bindings
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# change these depending on version
# export PATH="/usr/local/opt/php@8.3/bin:$PATH"
# export PATH="/usr/local/opt/php@8.3/bin:$PATH"
export PATH="/usr/local/opt/php@8.1/sbin:$PATH"
export PATH="/usr/local/opt/php@8.1/sbin:$PATH"
# export PATH="/usr/local/opt/php@8.0/bin:$PATH"
# export PATH="/usr/local/opt/php@8.0/sbin:$PATH"
# then after doing the above, run:
# `brew unlink php && brew link --force php@8.1`
export JAVA_HOME="/Library/Java/JavaVirtualMachines/adoptopenjdk-22.jdk/Contents/Home"
export PATH="$JAVA_HOME:$PATH"
export PATH="/Users/mjw/tmp/apache-maven/bin:$PATH"
export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"
export PATH="$PATH:/Users/michael/.local/bin"

# zsh falcon colouring
source $HOME/Documents/Work/internal/vim/colors/falcon/zsh/falcon.zsh

ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern)

alias luamake=$HOME/tmp/lua-language-server/3rd/luamake/luamake

# fasd setup
# eval "$(fasd --init auto)"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

eval "$(zoxide init zsh)"

# todo: some more general way of doing this
if [[ -f ~pc/.aliases.zsh ]]; then
  source ~pc/.aliases.zsh
fi

if [[ -f "$HOME/.local/bin/env" ]]; then
  . "$HOME/.local/bin/env"
fi

# Added by LM Studio CLI (lms)
export PATH="$PATH:/Users/michaelwelford/.lmstudio/bin"
# End of LM Studio CLI section

# {{{
# profiling end
# simple profiling and output
# zprof > ~/tmp/prof.txt

# more complete profiling
# unsetopt xtrace
# exec 2>&3 3>&-
# }}}
