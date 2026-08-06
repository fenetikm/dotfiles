#!/usr/bin/env zsh

# vim_agent - neovim on the left, an agent cli on the right
#
# usage:
#   vim_agent <agent> [nvim args...]
#
# e.g.:
#   vim_agent claude
#   vim_agent opencode README.md

# agents whose command isn't just their sidekick name
typeset -gA VIM_AGENT_CMDS=(
  amazon_q 'q'
  copilot  'copilot --banner'
  cursor   'cursor-agent'
)

vim_agent() {
  local AGENT="$1"
  shift

  if [[ -z "$AGENT" ]]; then
    print_red "vim_agent: which agent?"
    return 1
  fi

  # resolve the agent to a command, absolute path so it doesn't depend on
  # whatever the tmux server has in its path
  local -a AGENT_CMD=(${=VIM_AGENT_CMDS[$AGENT]:-$AGENT})
  local AGENT_BIN="${commands[$AGENT_CMD[1]]}"

  if [[ -z "$AGENT_BIN" ]]; then
    print_red "vim_agent: couldn't find $AGENT_CMD[1] on the path"
    return 1
  fi

  AGENT_CMD[1]="$AGENT_BIN"

  # `-d` leaves the focus here, keep a shell around when the agent exits
  tmux split-window -h -d -c "$PWD" -l 50% "${AGENT_CMD[*]}; exec $SHELL"

  SIDEKICK_ATTACH="$AGENT" nvim "$@"
}

alias vac='vim_agent claude'
alias vao='vim_agent opencode'
