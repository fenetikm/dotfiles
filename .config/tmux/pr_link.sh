#!/usr/bin/env zsh

# Copy the URL of the open PR for the focused pane's branch and open it in the browser.
# Usage: pr_link.sh <path>   (bind with '#{pane_current_path}')

# run-shell doesn't source a profile, so gh/pbcopy need to be findable
export PATH="/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin"

DIR="${1:-$PWD}"

notify() {
  tmux display-message "$1"
  exit "${2:-0}"
}

cd "$DIR" 2>/dev/null || notify "No such path: $DIR" 1

git rev-parse --is-inside-work-tree &>/dev/null || notify "Not a git repo"

BRANCH=$(git symbolic-ref --quiet --short HEAD 2>/dev/null) \
  || notify "Detached HEAD - no branch"

URL=$(gh pr list --head "$BRANCH" --state open --limit 1 --json url --jq '.[0].url' 2>/dev/null)

if [[ -z "$URL" ]]; then
  notify "No PR open"
fi

print -rn -- "$URL" | pbcopy
tmux set-buffer -- "$URL"
open "$URL" &>/dev/null || notify "PR link copied (failed to open browser)" 1
notify "PR link copied and opened"
