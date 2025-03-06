source ~/.config/zsh/directory_hashes.zsh

hugo-migrate-images() {
  local CONV="$1"
  if [[ "$CONV" == "" ]]; then
    CONV=$(find content \( -path '**/posts/**' -or -path '**/til/**' -or -path '**/devlog/**' \) -not -name 'index.md' -name '*.md' | fzf --no-multi --preview 'bat --color=always --line-range :500 {}' | gsed -E 's/\.md//g')
  fi
  # it will be empty if it was cancelled
  if [[ "$CONV" != "" ]]; then
    mkdir "$CONV"
    cp "$CONV.md" "$CONV.bak"
    mv "$CONV.md" "$CONV/index.md"
    mkdir "$CONV/images"
    echo "Migrated $CONV to support images."
  fi
}

. "$HOME/.cargo/env"
if [ -f "$HOME/.slackenv" ]; then
  . "$HOME/.slackenv"
fi
