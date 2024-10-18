#!/bin/zsh

if ! git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
  exit 1
fi

$(git diff-files --no-ext-diff --quiet)
unstaged=$?

$(git diff-index --no-ext-diff --quiet --cached HEAD)
uncommited=$?

untracked=$(git ls-files -o --exclude-standard)

if [[ $unstaged -eq 1 || $uncommited -eq 1 || -n $untracked ]]; then
  exit 0
fi
exit 1
