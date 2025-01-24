# Setup fzf
# ---------
if [[ ! "$PATH" == */usr/local/opt/fzf/bin* ]]; then
  PATH="${PATH:+${PATH}:}/usr/local/opt/fzf/bin"
fi

export FZF_DEFAULT_OPTS=$FZF_DEFAULT_OPTS'
  --color=fg:#787882,fg+:#a1a1a9,bg:-1,bg+:#020221
  --color=hl:#a1a1a9,hl+:#dfdfe5,info:#99a4bc,marker:#dfdfe5
  --color=prompt:#a1a1a9,spinner:#5521d9,pointer:#847161,header:#dfdfe5
  --color=border:#262626,label:#aeaeae,query:#787882'

# Auto-completion
# ---------------
source "/usr/local/opt/fzf/shell/completion.zsh"

# Key bindings
# ------------
source "/usr/local/opt/fzf/shell/key-bindings.zsh"
