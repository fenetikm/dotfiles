hugo-migrate-images() {
  local CONV="$1"
  if [[ "$CONV" == "" ]]; then
    CONV=$(find content/posts -name '*.md' -not -name 'index.md' | fzf --no-multi --preview 'bat --color=always --line-range :500 {}' | awk -F '/' '{print $3}' | gsed -E 's/\.md//g')
  fi
  # it will be empty if it was cancelled
  if [[ "$CONV" != "" ]]; then
    mkdir "content/posts/$CONV"
    cp "content/posts/$CONV.md" "content/posts/$CONV.bak"
    mv "content/posts/$CONV.md" "content/posts/$CONV/index.md"
    mkdir "content/posts/$CONV/images"
    echo "Migrated $CONV to support images."
  fi
}
