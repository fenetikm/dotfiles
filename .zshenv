source ~/.config/zsh/directory_hashes.sh
source ~/.config/zsh/functions.sh

export $(grep -v '^#' "$HOME/.config/.env.keys" | xargs)
if [[ -f "$HOME/.env.keys" ]]; then
  export $(grep -v '^#' "$HOME/.env.keys" | xargs)
fi

. "$HOME/.cargo/env"

export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"

if [[ -f "$HOME/.zshenv.local" ]]; then
  source "$HOME/.zshenv.local"
fi
