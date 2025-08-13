source ~/.config/zsh/directory_hashes.zsh
source ~/.config/zsh/functions.sh
export $(grep -v '^#' "$HOME/.config/.env.keys" | xargs)
if [[ -f "$HOME/.env.keys"]]; then
  export $(grep -v '^#' "$HOME/.env.keys" | xargs)
fi

. "$HOME/.cargo/env"
if [ -f "$HOME/.slackenv" ]; then
  . "$HOME/.slackenv"
fi
