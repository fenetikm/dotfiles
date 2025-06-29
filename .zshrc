# todo: modularise this into separate files e.g. prompt, aliases, fzf etc.
# for profiling
# simple profiling of zsh related things
# zmodload zsh/zprof

# complete profiling of everything loaded in new shell
# zmodload zsh/datetime
# setopt promptsubst
# PS4='+$EPOCHREALTIME %N:%i> '
# exec 3>&2 2> startlog.$$
# setopt xtrace prompt_subst

# disable the update prompt
DISABLE_UPDATE_PROMPT=true
DISABLE_AUTO_TITLE=true

# disable update checking entirely
zstyle ':omz:update' mode disabled

# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh
source $ZSH/oh-my-zsh.sh

# remove the right prompt extra space
ZLE_RPROMPT_INDENT=0
eval "$(starship init zsh)"

# the following is now called from ~/.zshenv
# source ~/.config/zsh/directory_hashes.zsh

# exa colours
source $HOME/Documents/Work/internal/vim/colors/falcon/exa/EXA_COLORS_MODERN

# User configuration.
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

# completion
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

timezsh() {
  shell=${1-$SHELL}
  for i in $(seq 1 10); do /usr/bin/time $shell -i -c exit; done
}

alias l='llm -m my-openai'
alias lq='llm -m mlx-community/Qwen2.5-Coder-14B-Instruct-4bit'
# alias l='ls -alhF'
# alias lvr='ls -alR > /dev/null'

alias mv='/bin/mv -i'
alias rm='/bin/rm -i'
alias srm='sudo /bin/rm -i'
alias cx='chmod +x'

# this thins local snapshots, 50gb, urgency of 4 (highest)
alias tmthin='tmutil thinlocalsnapshots / $((50 * 1024 * 1024 * 1024)) 4'

# reload
alias reload="source ~/.zshrc"

# eza (was exa)
alias e='eza -algB --group-directories-first'
alias et='eza -algB --tree'
alias es='eza --oneline --group-directories-first'
alias cat='bat'
alias c='bat'
alias ping='prettyping'
alias top='sudo htop'
alias du="ncdu --color off -rr -x --exclude .git --exclude node_modules"

copy_contents() {
  cat $1 | pbcopy
}
alias copy='copy_contents'

paste_contents() {
  pbpaste >> $1
}
alias paste='paste_contents'

run_vim_leader() {
  com="NormLead $1"
  nvim -c "$com"
}

# nvim aliases
alias nv='nvim'
alias v='nvim'
alias sv='sudo nvim'
alias vl='run_vim_leader'

edit-latest() {
  nvim "$(find . -type f \( -name '*.md' -o -name '*.txt' -o -name '*.json' -o -name '*.csv' -o -name '*.yml' \) -print0 -maxdepth 1 | xargs -0 stat -f "%m %N" | sort -rn | head -1 | cut -f2- -d" ")"
}
alias el="edit-latest"

# yazi alias
function y() {
  local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
  yazi "$@" --cwd-file="$tmp"
  if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
    builtin cd -- "$cwd"
  fi
  rm -f -- "$tmp"
}

# suffix aliases: typing name of file with suffix will use that program
alias -s php=nvim
alias -s module=nvim
alias -s scss=nvim
alias -s css=nvim
alias -s tpl=nvim
alias -s yml=nvim
alias -s md=glow -p

# Global aliases, substitute anywhere
alias -g L="| less"
alias -g T="| tail"
alias -g TL="| tail -20"
alias -g C="| pbcopy"
alias -g G="| grep"
# Preview via fzf, edit with enter
alias -g P="| fzf --preview 'bat --color=always --line-range :500 {}' --bind 'enter:execute(nvim {})'"

# git aliases
alias gs='git s'
alias gd='git di'
alias gl='git l'
alias gp='git push'
alias gb='git branch'
alias g='_f() { if [[ $# == 0 ]]; then git status --short --branch; else git "$@"; fi }; _f'

# used in new_session
# either use the .tmux.setup in current directory or from root
tmux_setup() {
  if [[ -x ./.tmux.setup ]]; then
    ./.tmux.setup $1
  elif [[ -x ~/.tmux.setup ]]; then
    ~/.tmux.setup $1
  else
    echo "Oh noes! Couldn't find a .tmux.setup file."
  fi
}

alias mn='~/.config/tmux/sesh.sh'
alias ma='tmux attach-session'
alias mw='tmux new-window -n'

# robo
# alias rb='./vendor/bin/robo'
alias rb='~pcp/vendor/bin/robo'
alias rbd='docker exec -it -w /app nginx-pc vendor/bin/robo'

new-fortnightly () {
  cd ~pcp/../../video/product_weekly
  local YEAR=$(date -u +%Y)
  local MONTH=$(date -u +%m)
  local DAY=$(date -u +%d)
  local FN=fortnightly_"$DAY"_"$MONTH"_"$YEAR".html
  cp template.html "$FN"
  nvim "$FN"
}

#virtual box
alias vbox='vboxmanage'
alias vboxr='vboxmanage list runningvms'

#docker
alias docker-restart="osascript -e 'quit app \"Docker\"'"

# ssh
alias ventrassh='ssh theoryz4@s03de.syd6.hostingplatform.net.au -p 2683 -i $HOME/.ssh/id_dsa'

#ranger
alias r='ranger'

alias ..='cd ..'

#hugo
hugo-new-post () {
  hugo new posts/"$1".md
  nvim "content/posts/$1.md"
}

hugo-new-til () {
  hugo new til/"$1".md --editor nvim
}

hugo-new-link () {
  hugo new link/"$1".md --editor nvim
}

hugo-open-post() {
  nvim $(find content -name '*.md' | fzf --no-multi --preview 'bat --color=always --line-range :500 {}')
}

hugo-open-latest() {
  nvim $(find content -name '*.md' -print0 | xargs -0 stat -f "%m %N" | sort -rn | head -1 | cut -f2- -d" ")
}

hugo-open-drafts() {
  nvim $(hugo list drafts | cut -d"," -f1 | grep content | fzf --no-multi --preview 'bat --color=always --line-range :500 {}')
}

hugo-start-server() {
  local PORT="$1"
  if [[ "$PORT" == "" ]]; then
    PORT=1337
  fi
  hugo server -D -F --navigateToChanged --disableFastRender --renderToMemory --port $PORT
}

# note: hugo-migrate-images is in .zshenv so it works in neovim shell command
alias hi="hugo-migrate-images"
alias hd="hugo-open-drafts"
alias hl="hugo-open-latest"
alias ho="hugo-open-post"
alias hn='hugo-new-post'
alias ht='hugo-new-til'
alias hk='hugo-new-link'

#love framework
alias love="/Applications/love.app/Contents/MacOS/love"

#majyk
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

#rando
alias dbd='rb db:dump --path="tmp/dump.sql" --sed=gsed --dirty'
alias dbl='rb db:load --path="tmp/dump.sql"'
alias dbd2='rb db:dump --path="tmp/dump2.sql" --sed=gsed --dirty'
alias dbl2='rb db:load --path="tmp/dump2.sql"'
alias dbd3='rb db:dump --path="tmp/dump3.sql" --sed=gsed --dirty'
alias dbl3='rb db:load --path="tmp/dump3.sql"'
alias pcload='(cd ~pcp && rb db:load)'
alias pcup='docker-compose -f misc/docker/docker-compose.yml -f misc/docker/docker-compose.override.yml up -d'
alias pcdown='docker container stop $(docker container ls -aq)'
alias ytbest='yt-dlp -f bestvideo+bestaudio --merge-output-format=mkv -4 --sleep-requests 2 --sleep-interval 2 --extractor-args "youtube:player-client=web_embedded"'
alias yt1080='yt-dlp -S "height:1080" --merge-output-format=mkv -4 --sleep-requests 2 --sleep-interval 2 --extractor-args "youtube:player-client=web_embedded"'
alias yt720='yt-dlp -S "height:720" --merge-output-format=mkv -4 --sleep-requests 2 --sleep-interval 2 --extractor-args "youtube:player-client=web_embedded"'
alias ytaudio='yt-dlp --extract-audio -4 --sleep-requests 2 --sleep-interval 2 --extractor-args "youtube:player-client=web_embedded" --audio-format mp3 --audio-quality 0'

secret_add() {
  local FILE=$(realpath $1)
  local FILEPATH="${FILE/"$HOME"\//}"
  echo "$FILEPATH filter=crypt diff=crypt merge=crypt" >> ~/.gitattributes
  yadm add "$1"
  yadm add ~/.gitattributes
  yadm commit -m "Added encrypted file"
}

# yabai
yabai_windows () {
  yabai -m query --windows --space "$1" | jq -c -re '.[] | select(."is-visible" == true) | {id, title, app, "is-floating"}'
}

yabai_spaces () {
  yabai -m query --spaces --space "$1" | jq -c -re '{id, index, label, type}'
}

alias ys="yabai_spaces"
alias yw="yabai_windows"

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
# source < (fzf --zsh)

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

# fzf git log
fzf_git_log() {
    local commits=$(
      git ll --color=always "$@" |
        fzf --no-sort --height 100% \
            --preview "echo {} | grep -o '[a-f0-9]\{7\}' | head -1 |
                       xargs -I@ sh -c 'git show --color=always @'"
      )
    if [[ -n $commits ]]; then
        local hashes=$(printf "$commits" | cut -d' ' -f2 | tr '\n' ' ')
        git show $hashes
    fi
}

# fzf find a file by name and edit
fzf_find_edit() {
    local file=$(
      fzf --no-multi --preview 'bat --color=always --line-range :500 {}'
      )
    if [[ -n $file ]]; then
        $EDITOR $file
    fi
}

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
alias fge='fzf_grep_edit'
alias ffe='fzf_find_edit'
alias fgl="fzf_git_log"
alias fco="fzf_git_checkout"

# todo: update re new mac
# export PATH="/usr/local/opt/ncurses/bin:$PATH"
export GOPATH="$HOME/go"
export PATH="$GOPATH/bin:$PATH"
export PATH=/opt/local/bin:/opt/local/sbin:$PATH
export PATH=/Applications/kitty.app/Contents/MacOS:$PATH

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

# nvm - replaced with volta

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

# Source your static plugins file.
source ${zsh_plugins}.zsh

#zsh-history-substring-search key bindings
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# change these depending on version
export PATH="/usr/local/opt/php@8.1/bin:$PATH"
export PATH="/usr/local/opt/php@8.1/sbin:$PATH"
# export PATH="/usr/local/opt/php@8.0/bin:$PATH"
# export PATH="/usr/local/opt/php@8.0/sbin:$PATH"
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

if [[ -f ~pc/.aliases.zsh ]]; then
  source ~pc/.aliases.zsh
fi

if [[ -f "$HOME/.local/bin/env" ]]; then
  . "$HOME/.local/bin/env"
fi

# simple profiling and output
# zprof > ~/tmp/prof.txt

# more complete profiling
# unsetopt xtrace
# exec 2>&3 3>&-

# Added by LM Studio CLI (lms)
export PATH="$PATH:/Users/michaelwelford/.lmstudio/bin"
# End of LM Studio CLI section

