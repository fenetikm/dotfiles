source ~/.config/zsh/directory_hashes.sh
source ~/.config/zsh/functions.sh

export $(grep -v '^#' "$HOME/.config/.env.keys" | xargs)
if [[ -f "$HOME/.env.keys" ]]; then
  export $(grep -v '^#' "$HOME/.env.keys" | xargs)
fi

if [[ -f "$HOME/.cargo/env" ]]; then
  . "$HOME/.cargo/env"
fi

if [[ -f "$HOME/.zshenv.local" ]]; then
  source "$HOME/.zshenv.local"
fi
