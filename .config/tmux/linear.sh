#!/usr/bin/env zsh

# usage: ./linear.sh
#        ./linear.sh --render <include_backlog:0|1>   (internal, for the toggle)
#
# shows a fzf picker of active Linear tickets (started + unstarted), with the
# ones assigned to me first, then ordered by priority
#
# the backlog is left out of the opening query because it is big and slow, and
# is fetched on demand the first time it is toggled in, then cached for the
# rest of the session; toggling it in also brings back the states that are
# hidden by default (see EXCLUDE_STATES)
#
# each line is: <display text>\t<identifier>\t<url>
# only the display text is shown by fzf, the hidden fields carry the identifier
# for the detail preview and the url for opening in a browser
#
# keys:
# - enter   toggle the ticket detail preview
# - ctrl-b  toggle the backlog in and out of the list
# - ctrl-o  open the ticket in a browser
#
# the team defaults to SUP, override with $LINEAR_TEAM

# --render prints the padded picker lines for one state set and exits, which is
# what fzf's reload calls to pull the backlog in
RENDER_ONLY=0
INCLUDE_BACKLOG=0
if [[ "$1" == --render ]]; then
  RENDER_ONLY=1
  INCLUDE_BACKLOG=${2:-0}
fi

# spaces between columns
GAP=2
# smallest title column worth rendering, below this the title is dropped
TITLE_MIN=20

ESC_DARK_GREY=$'\e[38;2;87;87;94m'
ESC_RESET=$'\e[0m'
ELLIPSIS=…

TEAM="${LINEAR_TEAM:-SUP}"

# states that are technically active but not worth looking at by default, they
# come back in with the backlog
typeset -a EXCLUDE_STATES
EXCLUDE_STATES=(
  'Ready for Prod'
)

# only the interactive run has a terminal to wait on
die() {
  print -u2 "$@"
  (( RENDER_ONLY )) || read -k1
  exit 1
}

if ! command -v linear >/dev/null; then
  die "Error: linear cli not found on PATH."
fi

WIDTH=$(tmux display-message -p '#{client_width}' 2>/dev/null)
[[ -z "$WIDTH" ]] && WIDTH=${COLUMNS:-80}

# fetches the issues and lays them out as tab separated columns in $ROWS
# usage: fetch_rows <include_backlog:0|1>
fetch_rows() {
  local include_backlog=$1
  local -a STATES_ARG
  local JSON EXCLUDE_JSON ME

  STATES_ARG=(--state started --state unstarted)
  (( include_backlog )) && STATES_ARG+=(--state backlog)

  # the display name is what the query results carry, so it is what "mine" is
  # matched against
  ME=$(linear auth whoami 2>/dev/null | sed -n 's/^ *Display name: *//p')

  JSON=$(linear issue query \
    --team "$TEAM" \
    "${STATES_ARG[@]}" \
    --limit 0 \
    --json \
    --no-pager 2>&1) || die "Error: could not fetch issues." "$JSON"

  # the backlog view is the "everything" view, so nothing is excluded from it
  if (( include_backlog )); then
    EXCLUDE_JSON='[]'
  else
    EXCLUDE_JSON=$(print -rl -- "${EXCLUDE_STATES[@]}" | jq -R . | jq -s .)
  fi

  # priority 0 means "no priority" and belongs at the bottom, not the top, so
  # it is remapped before sorting
  # @tsv keeps one record per line even if a title contains a tab or newline
  ROWS=$(print -r -- "$JSON" | jq -r --arg me "$ME" --argjson exclude "$EXCLUDE_JSON" '
    [ .nodes[]
      | (.state.name // "") as $st
      | select(($exclude | index($st)) == null)
      | {
          id: .identifier,
          state: (.state.name // ""),
          prio: (if (.priority // 0) == 0 then "—" else (.priorityLabel // "") end),
          prank: (if (.priority // 0) == 0 then 5 else .priority end),
          who: (.assignee.initials // "--"),
          mine: (if (.assignee.displayName // "") == $me then 0 else 1 end),
          title: (.title // ""),
          url: (.url // "")
        }
    ]
    | sort_by(.mine, .prank, .id)
    | .[]
    | [.id, .state, .prio, .who, .title, .url]
    | @tsv
  ')
}

# renders $ROWS as padded picker lines
render_rows() {
  local ID STATE PRIO WHO TITLE URL META
  local ID_W=0 STATE_W=0 PRIO_W=0 WHO_W=0 TITLE_CAP i
  # measure every column before rendering, so the padding fits what is shown
  local -a IDS STATES PRIOS WHOS TITLES URLS

  while IFS=$'\t' read -r ID STATE PRIO WHO TITLE URL; do
    [[ -z "$ID" ]] && continue

    IDS+=("$ID")
    STATES+=("$STATE")
    PRIOS+=("$PRIO")
    WHOS+=("$WHO")
    TITLES+=("$TITLE")
    URLS+=("$URL")

    (( ${#ID} > ID_W )) && ID_W=${#ID}
    (( ${#STATE} > STATE_W )) && STATE_W=${#STATE}
    (( ${#PRIO} > PRIO_W )) && PRIO_W=${#PRIO}
    (( ${#WHO} > WHO_W )) && WHO_W=${#WHO}
  done <<< "$ROWS"

  (( ${#IDS} == 0 )) && return 0

  (( ID_W += GAP ))
  (( STATE_W += GAP ))
  (( PRIO_W += GAP ))
  (( WHO_W += GAP ))

  # what is left for the title once the fixed columns and fzf's own gutter are
  # accounted for
  TITLE_CAP=$(( WIDTH - ID_W - STATE_W - PRIO_W - WHO_W - 4 ))

  for i in {1..${#IDS}}; do
    TITLE="$TITLES[i]"

    if (( TITLE_CAP < TITLE_MIN )); then
      TITLE=""
    elif (( ${#TITLE} > TITLE_CAP )); then
      TITLE="${TITLE[1,TITLE_CAP - 1]}$ELLIPSIS"
    fi

    # pad the plain text first, colour after, otherwise the escapes are counted
    # as characters and the columns drift
    META="$ESC_DARK_GREY$(pad_string "$STATE_W" "$STATES[i]")$(pad_string "$PRIO_W" "$PRIOS[i]")$(pad_string "$WHO_W" "$WHOS[i]")$ESC_RESET"

    print -r -- "$(pad_string "$ID_W" "$IDS[i]" "$META$TITLE")"$'\t'"$IDS[i]"$'\t'"$URLS[i]"
  done
}

if (( RENDER_ONLY )); then
  fetch_rows "$INCLUDE_BACKLOG"
  render_rows
  exit 0
fi

ACTIVE_FILE=$(mktemp -t linear-active)
ALL_FILE=$(mktemp -t linear-all)
STATE_FILE=$(mktemp -t linear-state)
trap 'rm -f "$ACTIVE_FILE" "$ALL_FILE" "$ALL_FILE.part" "$STATE_FILE"' EXIT INT TERM

fetch_rows 0
render_rows > "$ACTIVE_FILE"

HEADER_OFF="$ESC_DARK_GREY  ctrl-b  show backlog    ctrl-o  open$ESC_RESET"
HEADER_ON="$ESC_DARK_GREY  ctrl-b  hide backlog    ctrl-o  open$ESC_RESET"

# nothing active means the picker would open empty, so pay for the backlog up
# front in that one case
START_FILE="$ACTIVE_FILE"
START_HEADER="$HEADER_OFF"
START_STATE=0

if [[ ! -s "$ACTIVE_FILE" ]]; then
  fetch_rows 1
  render_rows > "$ALL_FILE"

  if [[ ! -s "$ALL_FILE" ]]; then
    print "No tickets in $TEAM."
    read -k1
    exit 0
  fi

  START_FILE="$ALL_FILE"
  START_HEADER="$HEADER_ON"
  START_STATE=1
fi

print -rn -- "$START_STATE" > "$STATE_FILE"

if command -v glow >/dev/null; then
  PREVIEW='linear issue view {2} --no-pager 2>&1 | CLICOLOR_FORCE=1 glow - -s '${(q)GLOW_STYLE:-auto}' -w "$FZF_PREVIEW_COLUMNS"'
else
  PREVIEW='linear issue view {2} --no-pager 2>&1'
fi

# fzf has no state of its own, so the current mode lives in $STATE_FILE and the
# transform emits the actions for whichever mode is being switched to
# the backlog query only runs once, the reload reads the cache after that, and
# a failed fetch leaves the cache empty so the next toggle retries
TOGGLE="transform:
if [ \"\$(cat ${(q)STATE_FILE})\" = 0 ]; then
  printf 1 > ${(q)STATE_FILE}
  echo \"reload(if [ ! -s ${(q)ALL_FILE} ]; then zsh ${(q)${0:A}} --render 1 > ${(q)ALL_FILE}.part 2>/dev/null; [ -s ${(q)ALL_FILE}.part ] && mv ${(q)ALL_FILE}.part ${(q)ALL_FILE}; fi; cat ${(q)ALL_FILE})+change-header(${HEADER_ON})+first\"
else
  printf 0 > ${(q)STATE_FILE}
  echo \"reload(cat ${(q)ACTIVE_FILE})+change-header(${HEADER_OFF})+first\"
fi"

# --preview indexes the original line, so {2} is the identifier and {3} the url
# nothing is ever accepted, enter is the preview toggle, so fzf's selection
# output is discarded
fzf \
  --color=bg:#020223,bg+:#020223 \
  --no-scrollbar \
  --no-info \
  --reverse \
  --ansi \
  --no-multi \
  --delimiter=$'\t' \
  --with-nth='{1}' \
  --header "$START_HEADER" \
  --preview "$PREVIEW" \
  --preview-window='right,60%,hidden,noinfo,wrap' \
  --bind 'enter:toggle-preview' \
  --bind "ctrl-b:$TOGGLE" \
  --bind 'ctrl-o:execute-silent(open {3})' \
  < "$START_FILE" >/dev/null

exit 0
