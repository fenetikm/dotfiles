#!/usr/bin/env zsh

# agent_picker.sh — pick a running agent with fzf and switch the client to it
#
#   agent_picker.sh          run the picker
#   agent_picker.sh --list   print the rows only, used by the ctrl-r reload
#
# each line is: <display text>\t<session name>\t<window id>\t<pane id>
# only the display text is shown by fzf, the ids are the switch target
# two agents can share a window, so the pane id is part of the target

SIDEBAR_BIN=${commands[tmux-agent-sidebar]:-$HOME/Documents/Work/internal/projects/my-agent-sidebar/bin/tmux-agent-sidebar}

# column lengths before truncation
REPO_CAP=20
BRANCH_CAP=30
# spaces between columns
GAP=3

# glyph shape is the pane state, glyph colour is the agent
GLYPH_ATTENTION='●'
GLYPH_RUNNING='◐'
GLYPH_IDLE='·'

typeset -A AGENT_ESC=(
  claude   $'\e[38;2;217;119;87m'
  cursor   $'\e[38;2;122;162;247m'
  opencode $'\e[38;2;158;206;106m'
)
ESC_AGENT=$'\e[38;2;87;87;94m'
# colour of the tmux location
ESC_LOC=$'\e[38;2;87;87;94m'
ESC_RESET=$'\e[0m'

# stands in for the list so the picker still opens rather than blinking shut
# also covers a missing binary or unparseable json, the ids are left empty
emit_empty() {
  printf '%s%s%s\t\t\t\n' "$ESC_LOC" '<no agents>' "$ESC_RESET"
}

build_list() {
  local json rows
  local -a GLYPHS STATUSES REPOS BRANCHES SESH_COL LOCS SESH_NAMES WIN_IDS PANE_IDS
  local -A WIN_IDX
  local STATUS_W=0 REPO_W=0 BRANCH_W=0 SESH_W=0
  local wid widx i line
  local -a f
  # pstatus, not status, zsh reserves that one
  local attention pstatus agent repo branch sesh win_id pane_id glyph esc

  json=$("$SIDEBAR_BIN" list --json --all-panes 2>/dev/null)

  if [[ -z "$json" ]]; then
    emit_empty
    return
  fi

  # attention first, then session so same-session rows still cluster,
  # then the sidebar's own ordering
  rows=$(print -r -- "$json" | jq -r '
    .panes
    | sort_by([(.attention | not), .tmux_session, .index])
    | .[]
    | [ (.attention | tostring), .status, .agent, .repo, .branch,
        .tmux_session, .window_id, .pane_id ]
    | @tsv
  ' 2>/dev/null)

  if [[ -z "$rows" ]]; then
    emit_empty
    return
  fi

  # the json carries window ids but not window indexes, and the location
  # column wants the index, so one tmux call rather than one per row
  while IFS=$'\t' read -r wid widx; do
    WIN_IDX[$wid]=$widx
  done < <(tmux list-windows -a -F $'#{window_id}\t#{window_index}')

  # print -r rather than echo, echo would expand a backslash in a branch name
  print -r -- "$rows" | while IFS= read -r line; do
    # split with ps rather than IFS=$'\t' read, tab counts as IFS whitespace
    # so read would collapse a run of tabs and an empty branch would shift
    # every field after it
    f=("${(@ps:\t:)line}")
    attention=$f[1] pstatus=$f[2] agent=$f[3] repo=$f[4]
    branch=$f[5] sesh=$f[6] win_id=$f[7] pane_id=$f[8]

    # ignore _popup_
    # filtered here so hidden rows can't widen the columns
    if [[ "$sesh" == *_popup_* ]]; then
      continue
    fi

    if [[ "$attention" == "true" ]]; then
      glyph=$GLYPH_ATTENTION
    elif [[ "$pstatus" == "running" ]]; then
      glyph=$GLYPH_RUNNING
    else
      glyph=$GLYPH_IDLE
    fi
    esc=${AGENT_ESC[$agent]:-$ESC_AGENT}

    if (( ${#repo} > REPO_CAP )); then
      repo="${repo[1,REPO_CAP - 1]}…"
    fi

    if (( ${#branch} > BRANCH_CAP )); then
      branch="${branch[1,BRANCH_CAP - 1]}…"
    fi

    (( ${#pstatus} > STATUS_W )) && STATUS_W=${#pstatus}
    (( ${#repo} > REPO_W )) && REPO_W=${#repo}
    (( ${#branch} > BRANCH_W )) && BRANCH_W=${#branch}
    (( ${#sesh} + 2 > SESH_W )) && SESH_W=$(( ${#sesh} + 2 ))

    # the glyph is pre-coloured, it is a fixed single character so printf
    # never has to pad it
    GLYPHS+=("$esc$glyph$ESC_RESET")
    STATUSES+=("$pstatus")
    REPOS+=("$repo")
    BRANCHES+=("$branch")
    SESH_COL+=("[$sesh]")
    LOCS+=("$sesh:$WIN_IDX[$win_id]")
    SESH_NAMES+=("$sesh")
    WIN_IDS+=("$win_id")
    PANE_IDS+=("$pane_id")
  done

  if (( ${#PANE_IDS} == 0 )); then
    emit_empty
    return
  fi

  (( STATUS_W += GAP ))
  (( REPO_W += GAP ))
  (( BRANCH_W += GAP ))
  (( SESH_W += GAP ))

  # the colour escapes go after the padded fields, printf pads by character
  # count and would otherwise measure the escape bytes as visible width
  for i in {1..${#PANE_IDS}}; do
    printf '%s %-*s%-*s%-*s%-*s%s(%s)%s\t%s\t%s\t%s\n' \
      "$GLYPHS[i]" \
      "$STATUS_W" "$STATUSES[i]" \
      "$REPO_W" "$REPOS[i]" \
      "$BRANCH_W" "$BRANCHES[i]" \
      "$SESH_W" "$SESH_COL[i]" \
      "$ESC_LOC" "$LOCS[i]" "$ESC_RESET" \
      "$SESH_NAMES[i]" "$WIN_IDS[i]" "$PANE_IDS[i]"
  done
}

if [[ "$1" == "--list" ]]; then
  build_list
  exit 0
fi

SELF=${0:A}

CLIENT_WIDTH=$(tmux display-message -p '#{client_width}')

# field 1 is the display text, 2 is the session name, 3 the window id,
# 4 the pane id
# --with-nth hides the ids, they stay in the line fzf prints on accept
FZF_ARGS=(
  --color=bg:#020223,bg+:#020223
  --no-scrollbar
  --no-info
  --reverse
  --ansi
  --delimiter=$'\t'
  --with-nth='{1}'
  --bind "ctrl-r:reload('$SELF' --list)"
)

if (( CLIENT_WIDTH >= 160 )); then
  # no preview when not much space
  # --preview indexes the original line, so {4} is the pane id
  # the pane rather than the window, two agents can share a window
  FZF_ARGS+=(
    --preview-window=right,noinfo
    --preview '"$HOME/.config/tmux/pane_preview.sh" {4}'
  )
fi

SELECTED=$(build_list | fzf "${FZF_ARGS[@]}")

# nothing picked, esc'd out
if [[ -z "$SELECTED" ]]; then
  exit 0
fi

FIELDS=("${(@ps:\t:)SELECTED}")

# the <no agents> row carries no target
if [[ -z "$FIELDS[2]" ]]; then
  exit 0
fi

# switch-client won't take a window or pane as a session target, so the
# session is switched by name and the window and pane selected after
tmux switch-client -t "$FIELDS[2]"
tmux select-window -t "$FIELDS[3]"
tmux select-pane -t "$FIELDS[4]"
