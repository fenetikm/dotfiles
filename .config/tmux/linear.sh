#!/usr/bin/env zsh

# usage: ./linear.sh
#
# shows a fzf picker of active Linear tickets (started + unstarted), with the
# ones assigned to me first, then ordered by priority
#
# each line is: <display text>\t<identifier>\t<url>
# only the display text is shown by fzf, the hidden fields carry the identifier
# for the detail preview and the url for opening in a browser
#
# keys:
# - enter   toggle the ticket detail preview
# - ctrl-o  open the ticket in a browser
#
# the team defaults to SUP, override with $LINEAR_TEAM

# spaces between columns
GAP=2
# smallest title column worth rendering, below this the title is dropped
TITLE_MIN=20

ESC_DARK_GREY=$'\e[38;2;87;87;94m'
ESC_RESET=$'\e[0m'
ELLIPSIS=…

TEAM="${LINEAR_TEAM:-SUP}"

# states that are technically active but not worth looking at here
typeset -a EXCLUDE_STATES
EXCLUDE_STATES=(
  'Ready for Prod'
)

if ! command -v linear >/dev/null; then
  print -u2 "Error: linear cli not found on PATH."
  read -k1
  exit 1
fi

# the display name is what the query results carry, so it is what "mine" is
# matched against
ME=$(linear auth whoami 2>/dev/null | sed -n 's/^ *Display name: *//p')

JSON=$(linear issue query \
  --team "$TEAM" \
  --state started \
  --state unstarted \
  --limit 0 \
  --json \
  --no-pager 2>&1)

if (( $? != 0 )); then
  print -u2 "Error: could not fetch issues."
  print -u2 "$JSON"
  read -k1
  exit 1
fi

EXCLUDE_JSON=$(print -rl -- "${EXCLUDE_STATES[@]}" | jq -R . | jq -s .)

# priority 0 means "no priority" and belongs at the bottom, not the top, so it
# is remapped before sorting
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

if [[ -z "$ROWS" ]]; then
  print "No active tickets in $TEAM."
  read -k1
  exit 0
fi

# measure every column before rendering, so the padding fits what is shown
typeset -a IDS STATES PRIOS WHOS TITLES URLS
ID_W=0 STATE_W=0 PRIO_W=0 WHO_W=0

while IFS=$'\t' read -r ID STATE PRIO WHO TITLE URL; do
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

(( ID_W += GAP ))
(( STATE_W += GAP ))
(( PRIO_W += GAP ))
(( WHO_W += GAP ))

WIDTH=$(tmux display-message -p '#{client_width}' 2>/dev/null)
[[ -z "$WIDTH" ]] && WIDTH=${COLUMNS:-80}

# what is left for the title once the fixed columns and fzf's own gutter are
# accounted for
TITLE_CAP=$(( WIDTH - ID_W - STATE_W - PRIO_W - WHO_W - 4 ))

# note: LINES is a special zsh parameter (terminal height), hence ROWS_OUT
typeset -a ROWS_OUT

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

  ROWS_OUT+=("$(pad_string "$ID_W" "$IDS[i]" "$META$TITLE")"$'\t'"$IDS[i]"$'\t'"$URLS[i]")
done

if command -v glow >/dev/null; then
  PREVIEW='linear issue view {2} --no-pager 2>&1 | CLICOLOR_FORCE=1 glow - -s '${(q)GLOW_STYLE:-auto}' -w "$FZF_PREVIEW_COLUMNS"'
else
  PREVIEW='linear issue view {2} --no-pager 2>&1'
fi

# --preview indexes the original line, so {2} is the identifier and {3} the url
# nothing is ever accepted, enter is the preview toggle, so fzf's selection
# output is discarded
print -rl -- "${ROWS_OUT[@]}" |
  fzf \
    --color=bg:#020223,bg+:#020223 \
    --no-scrollbar \
    --no-info \
    --reverse \
    --ansi \
    --no-multi \
    --delimiter=$'\t' \
    --with-nth='{1}' \
    --preview "$PREVIEW" \
    --preview-window='right,60%,hidden,noinfo,wrap' \
    --bind 'enter:toggle-preview' \
    --bind 'ctrl-o:execute-silent(open {3})' >/dev/null

exit 0
