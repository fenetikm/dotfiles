# disable the update prompt
DISABLE_UPDATE_PROMPT=true
DISABLE_AUTO_TITLE=true

# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh
source $ZSH/oh-my-zsh.sh

PROMPT_LEAN_VIMODE=1
PROMPT_LEAN_VIMODE_FORMAT="%F{10}  %f"
PROMPT_LEAN_TMUX=''
PROMPT_LEAN_COLOR1='249'
PROMPT_LEAN_COLOR2='245'
PROMPT_LEAN_COLOR3='#8859FF'
PROMPT_LEAN_GIT_STYLE='FAT'
PROMPT_LEAN_SEP=''
PROMPT_LEAN_SYMBOL='==>'
# PROMPT_LEAN_PATH_SED='s/Documents\/Work/\$/g'
PROMPT_LEAN_PATH_SED=''
source $HOME/.config/zsh/lean/lean.plugin.zsh

# exa colours
source $HOME/Documents/Work/internal/vim/colors/falcon/exa/EXA_COLORS_MODERN

# zsh falcon colouring
source $HOME/Documents/Work/internal/vim/colors/falcon/zsh/falcon.zsh

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
alias srm='sudo /bin/rm -i'

# reload
alias reload="source ~/.zshrc"

# directory hashes
# to use: e.g. cd ~aa
source ~/.config/zsh/directory_hashes.zsh
alias e='exa -algB --group-directories-first'
alias et='exa -algB --tree'
alias cat='bat'
alias c='bat'
alias ping='prettyping'
alias top='sudo htop'
alias du="ncdu --color dark -rr -x --exclude .git --exclude node_modules"

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
# Preview via fzf, edit with enter
alias -g P="| fzf --preview 'bat --color=always --line-range :500 {}' --bind 'enter:execute(nvim {})'"

# git aliases
alias gs='git s'
alias gd='git di'
alias gl='git l'
alias gp='git push'
alias gb='git branch'
alias g='_f() { if [[ $# == 0 ]]; then git status --short --branch; else git "$@"; fi }; _f'

# git dotfiles management
alias y='yadm'

# tmux aliases
alias ms='~/.config/tmux/split.sh'
alias mn='~/.config/tmux/new.sh'
alias mpc='~/.config/tmux/pc.sh'
alias ml='tmux ls'
alias ma='tmux attach-session'

# robo
# alias rb='./vendor/bin/robo'
alias rb='~pcp/vendor/bin/robo'
alias rbd='docker exec -it -w /app nginx-pc vendor/bin/robo'

#virtual box
alias vbox='vboxmanage'
alias vboxr='vboxmanage list runningvms'

#docker
alias docker-restart="osascript -e 'quit app \"Docker\"' && open -a Docker"

# ssh
alias redyssh='ssh theoryz4@122.129.220.5 -p 5123 -i $HOME/.ssh/id_dsa'
alias ventrassh='ssh theoryz4@s03de.syd6.hostingplatform.net.au -p 2683 -i $HOME/.ssh/id_dsa'

#ranger
alias r='ranger'

alias ..='cd ..'

#hugo
hugo-new-post () {
  hugo new posts/"$1".md --editor nvim
}
hugo-open-post() {
  nvim $(find content -name '*.md' | fzf --no-multi --preview 'bat --color=always --line-range :500 {}')
}
hugo-open-latest() {
  nvim $(find ~blog/content -name '*.md' -type f -exec stat -lt \"%Y-%m-%d\" {} \+ | cut -d' ' -f6- | sort -n | tail -1 | cut -d' ' -f2-)
}
alias ho="hugo-open-post"
alias hn='hugo-new-post'
alias hl="hugo-open-latest"
alias hs="./save.sh"

#love framework
alias love="/Applications/love.app/Contents/MacOS/love"

# find up the directory hierarchy
find-up () {
  SWD=$(pwd)
  while [[ $PWD != / ]] ; do
    find "$PWD" -maxdepth 1 -name "$@"
    cd ..
  done
  cd $SWD
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
# alias ytbest="youtube-dl -f bestvideo+bestaudio --merge-output-format=mkv"
alias ytbest="yt-dlp -f bestvideo+bestaudio --merge-output-format=mkv"

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

# Use fd and fzf to get the args to a command.
# Works only with zsh
# Examples:
# f mv # To move files. You can write the destination after selecting the files.
# f 'echo Selected:'
# f 'echo Selected music:' --extension mp3
# fm rm # To rm files in current directory
# f() {
#     sels=( "${(@f)$(fd "${fd_default[@]}" "${@:2}"| fzf)}" )
#     test -n "$sels" && print -z -- "$1 ${sels[@]:q:q}"
# }
#
# # Like f, but not recursive.
# fm() f "$@" --max-depth 1

# using ripgrep combined with preview
# find-in-file - usage: fif <searchTerm>
# fif() {
#   if [ ! "$#" -gt 0 ]; then echo "Need a string to search for!"; return 1; fi
#   rg --files-with-matches --no-messages "$1" | fzf --bind "enter:execute(nvim {})" --preview "highlight -O ansi -l {} 2> /dev/null | rg --colors 'match:bg:yellow' --ignore-case --pretty --context 10 '$1' || rg --ignore-case --pretty --context 10 '$1' {}"
# }

# fifa() {
#   if [ ! "$#" -gt 0 ]; then echo "Need a string to search for!"; return 1; fi
#   rg --no-ignore --files-with-matches --no-messages "$1" | fzf --bind "enter:execute(nvim {})" --preview "highlight -O ansi -l {} 2> /dev/null | rg --no-ignore --colors 'match:bg:yellow' --ignore-case --pretty --context 10 '$1' || rg --no-ignore --ignore-case --pretty --context 10 '$1' {}"
# }

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

fstash() {
  local out q k sha
  while out=$(
    git stash list --pretty="%C(yellow)%h %>(14)%Cgreen%cr %C(blue)%gs" |
    fzf --ansi --no-sort --query="$q" --print-query \
        --expect=ctrl-d,ctrl-b);
  do
    mapfile -t out <<< "$out"
    q="${out[0]}"
    k="${out[1]}"
    sha="${out[-1]}"
    sha="${sha%% *}"
    [[ -z "$sha" ]] && continue
    if [[ "$k" == 'ctrl-d' ]]; then
      git diff $sha
    elif [[ "$k" == 'ctrl-b' ]]; then
      git stash branch "stash-$sha" $sha
      break;
    else
      git stash show -p $sha
    fi
  done
}
alias fs='fstash'

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
export GOPATH="$HOME/go"
export OCPATH="$HOME/.minishift/cache/oc/v3.9.0/darwin"
export PATH="$GOPATH/bin:$OCPATH:$PATH"
export PATH=/opt/local/bin:/opt/local/sbin:$PATH

# ripgrep configufation
export RIPGREP_CONFIG_PATH="$HOME/.rgrc"

# all files
alias rga="rg --hidden --no-ignore"
alias fda="fd --hidden --no-ignore"

#load nvm
export NVM_DIR="$HOME/.nvm"
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
# local_export

# the following is via brew handling of antidote
source /usr/local/opt/antidote/share/antidote/antidote.zsh
antidote load

#zsh-history-substring-search key bindings
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
export PATH="/usr/local/opt/php@8.0/bin:$PATH"
export PATH="/usr/local/opt/php@8.0/sbin:$PATH"
export JAVA_HOME="/Library/Java/JavaVirtualMachines/jdk-19.0.2.jdk/Contents/Home"
export PATH="/Library/Java/JavaVirtualMachines/jdk-19.0.2.jdk/Contents/Home:$PATH"
export PATH="/Users/mjw/tmp/apache-maven/bin:$PATH"

ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor)
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#787882'
# ZSH_HIGHLIGHT_STYLES[command]='fg=#DFDFE5'
# ZSH_HIGHLIGHT_STYLES[alias]='fg=#DFDFE5,bold'
# ZSH_HIGHLIGHT_STYLES[builtin]='fg=#DDCFBF'
# ZSH_HIGHLIGHT_STYLES[suffix-alias]='fg=#FF761A'

# switchPhp() {
#   brew unlink php@$1 && brew link php@$2
# }

alias luamake=$HOME/tmp/lua-language-server/3rd/luamake/luamake

# fasd setup
eval "$(fasd --init auto)"
