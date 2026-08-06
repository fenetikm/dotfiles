#!/usr/bin/env zsh

# the first letter of the active cswap account's email domain
# this ends up in the status.sh at the end e.g. ` ... | [M]`
claude_tag() {
  (( $+commands[cswap] )) && (( $+commands[jq] )) || return 0

  local TAG
  TAG=$(cswap list --json 2>/dev/null | jq -r '
    .activeAccountNumber as $n
    | .accounts[]
    | select(.number == $n)
    | .email
    | split("@")[1][0:1]
    | ascii_upcase
  ' 2>/dev/null)

  [[ $TAG == "null" ]] && return 0
  print -r -- "$TAG"
}

claude_tagged() {
  CLAUDE_TAG="$(claude_tag)" claude "$@"
}

# nv_agent - neovim on the left, an agent cli on the right
#
# usage:
#   nv_agent <agent> [nvim args...]
#
# e.g.:
#   nv_agent claude
#   nv_agent opencode README.md

# agents whose command isn't just their sidekick name
# these must be real binaries - the pane is spawned by tmux, which runs the
# command through sh, so zsh functions and aliases aren't visible to it
typeset -gA NV_AGENT_CMDS=(
  amazon_q 'q'
  copilot  'copilot --banner'
  cursor   'cursor-agent'
)

nv_agent() {
  local AGENT="$1"
  shift

  if [[ -z "$AGENT" ]]; then
    print_red "nv_agent: which agent?"
    return 1
  fi

  # resolve the agent to a command, absolute path so it doesn't depend on
  # whatever the tmux server has in its path
  local -a AGENT_CMD=(${=NV_AGENT_CMDS[$AGENT]:-$AGENT})
  local AGENT_BIN="${commands[$AGENT_CMD[1]]}"

  if [[ -z "$AGENT_BIN" ]]; then
    print_red "nv_agent: couldn't find $AGENT_CMD[1] on the path"
    return 1
  fi

  AGENT_CMD[1]="$AGENT_BIN"

  # create an environment (vars) passed to the running agent
  local -a AGENT_ENV=()
  [[ $AGENT == claude ]] && AGENT_ENV=("CLAUDE_TAG=$(claude_tag)")

  # `-d` leaves the focus here, keep a shell around when the agent exits
  tmux split-window -h -d -c "$PWD" -l 50% "${AGENT_ENV[*]} ${AGENT_CMD[*]}; exec $SHELL"

  SIDEKICK_ATTACH="$AGENT" nvim "$@"
}

alias ac='claude_tagged'
alias ao='opencode'
# cursor
alias ar='agent'
alias acs='sbx_start $(basename "$PWD") claude'

# claude swap (accounts), more specific go in .zshrc.local
alias cs='cswap switch'
alias csl='cswap list'

alias vac='nv_agent claude'
alias vao='nv_agent opencode'
alias var='nv_agent cursor'
