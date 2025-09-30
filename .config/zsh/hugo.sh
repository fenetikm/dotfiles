#!/usr/bin/env zsh

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

hugo-rename-tag() {
  TAG=$1
  REPLACE=$2
  if [[ "$TAG" == "" ]]; then
    echo "Missing tag to replace."
    return 1
  fi

  if [[ "$REPLACE" == "" ]]; then
    echo "Missing replacement."
    return 1
  fi

  FILES=$(ls -1 content/(posts|til|link)/**/*.md)
  for FILE in $(echo "$FILES"); do
    yq --front-matter=process '.tags |= map(select(. == "'"$TAG"'") = "'"$REPLACE"'" // .)' "$FILE" | sponge "$FILE"
  done

  echo "Tags updated."
}
alias htag="hugo-rename-tag"

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
  find content -name '*.md' P
}

hugo-open-latest() {
  nvim $(find content -name '*.md' -print0 | xargs -0 stat -f "%m %N" | sort -rn | head -1 | cut -f2- -d" ")
}

hugo-select-latest() {
  grep -l "draft: false" **/*.md(.omr) G content P
}

hugo-open-drafts() {
  grep -l "draft: true" **/*.md(.omr) G content P
}

hugo-start-server() {
  local PORT="$1"
  if [[ "$PORT" == "" ]]; then
    PORT=1337
  fi
  hugo server -D -F --navigateToChanged --disableFastRender --renderToMemory --port $PORT
}

# todo re hugo opener:
# - options: all, ordered by modified, maybe we throw whether draft or not in there?
# - ordered by published?
# - other binds: view in browser?

# note: hugo-migrate-images is in .zshenv so it works in neovim shell command

alias hi="hugo-migrate-images"
alias hd="hugo-open-drafts"
alias hl="hugo-open-latest"
alias hlp="rg --files-with-matches 'draft: false' **/*.md(.omr) R 'content' P"
alias hld="rg --files-with-matches 'draft: true' **/*.md(.omr) R 'content' P"
alias ho="hugo-open-post"
alias hn='hugo-new-post'
alias ht='hugo-new-til'
alias hk='hugo-new-link'
