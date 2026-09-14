#!/bin/sh
# pr-radar-panel — pr_radar, reshaped for the sidebar's custom bottom panel.
#
# Same buckets and same triage rules as the zsh `pr_radar`, but emitting NDJSON
# rows instead of ANSI columns, because the panel is ~40-60 columns wide and
# colours one row at a time.
#
# What changed from the zsh version, and why:
#   * No age column, no `d`/`r` draft column. At panel width the note ("merge
#     it", "CI red") is the part worth keeping; draft state became muted text
#     plus a note, age only appears once a PR is stale. The author survives as
#     initials after the number (`#412 MW`), which cost three columns.
#   * The per-row note moved in front of the title, in parens, so it survives
#     truncation: `✓ #412 (merge it) fix the flaky test`.
#   * ANSI escapes became colour names from the panel's vocabulary; the icon
#     carries CI state, the text colour carries urgency.
#   * Rows carry `url`, so they are clickable (OSC 8) instead of needing
#     `gh pr view <n> --web`.
#   * Bucket titles became `heading` rows, which the panel styles for us,
#     capped at $PR_RADAR_MAX_ROWS rows each and separated by a blank row.
#
# Repo selection: with no argument and no $PR_RADAR_REPO, it reports on the
# repo the sidebar handed us as cwd — the repository root of the focused pane.
# Set PR_RADAR_REPO (or pass owner/name) to pin it to one repo regardless of
# focus.
#
# Not wired up yet. When you want it:
#   set -g @sidebar_panel_command "~/bin/pr-radar-panel.sh"
#   set -g @sidebar_panel_name "PRs"
#   set -g @sidebar_panel_timeout 20    # three gh calls do not fit in 10s
#   set -g @sidebar_panel_interval 300  # see the cache note below

set -eu

: "${PR_RADAR_STALE_DAYS:=7}"
: "${PR_RADAR_CACHE_MINUTES:=5}"
# Rows shown per section. The heading keeps the full count, so a trimmed
# section reads "(5/8)" rather than silently hiding the rest.
: "${PR_RADAR_MAX_ROWS:=5}"

repo="${1:-${PR_RADAR_REPO:-}}"

# jq program: takes $me and $requested (comma separated PR numbers waiting on
# me) and emits panel rows — a heading per bucket, then one row per PR.
JQ=$(cat <<'JQ'
def ci:
  [ (.statusCheckRollup // [])[] | (.conclusion // .state // .status) ]
  | if length == 0 then "none"
    elif any(. == "FAILURE" or . == "ERROR" or . == "TIMED_OUT"
             or . == "STARTUP_FAILURE" or . == "ACTION_REQUIRED") then "fail"
    elif any(. == "IN_PROGRESS" or . == "QUEUED" or . == "PENDING"
             or . == "WAITING" or . == "EXPECTED") then "run"
    else "ok"
    end;

def age: ((now - (.updatedAt | fromdateiso8601)) / 86400) | floor;

def my_review($me):
  ([ .latestReviews[]? | select(.author.login == $me) | .state ] | last) // "";

def ci_icon($ci):
  if $ci == "fail" then "✗" elif $ci == "run" then "◌"
  elif $ci == "ok" then "✓" else "·" end;

# "Andrew Coulton" -> AC. gh fills .name from the GitHub profile, which is
# blank for plenty of accounts, so fall back to the login: one-word sources
# ("williammartin", "山田太郎") give their first two characters instead.
def initials($a):
  (if ($a.name // "") != "" then $a.name else ($a.login // "") end) as $src
  | [ $src | splits("[^\\p{L}\\p{N}]+") | select(length > 0) ] as $parts
  | (if ($parts | length) >= 2 then $parts[0][0:1] + $parts[1][0:1]
     elif ($parts | length) == 1 then $parts[0][0:2]
     else "" end)
  | ascii_upcase;

def ci_color($ci):
  if $ci == "fail" then "danger" elif $ci == "run" then "warning"
  elif $ci == "ok" then "success" else "muted" end;

($requested | split(",") | map(select(length > 0) | tonumber)) as $req
| ($stale_days | tonumber) as $stale
| [ .[]
    | (.author.login == $me) as $mine
    | .number as $n
    | (($req | index($n)) != null) as $asked
    | ci as $ci
    | age as $age
    # approved PRs of other people are their problem, drafts nobody asked me
    # about are not yet reviewable
    | (if $mine then "mine"
       elif $asked then "review"
       elif .isDraft or .reviewDecision == "APPROVED" then "quiet"
       else "review" end) as $bucket
    # [note, sort key within the bucket, text colour]
    | (if $mine then
         (if $ci == "fail" then ["CI red", 0, "danger"]
          elif .reviewDecision == "CHANGES_REQUESTED" then ["address feedback", 1, "warning"]
          elif .reviewDecision == "APPROVED" and .mergeable == "CONFLICTING" then ["rebase, then merge", 2, "warning"]
          elif .reviewDecision == "APPROVED" then ["merge it", 2, "success"]
          elif .isDraft then ["draft", 4, "muted"]
          else ["no review yet", 3, "default"] end)
       else
         ([ (if $asked then "you" else empty end),
            # why it is quiet; redundant once "you: approved" says it
            (if .reviewDecision == "APPROVED" and my_review($me) == "" then "A" else empty end),
            (if my_review($me) != "" then "you: " + (my_review($me) | ascii_downcase) else empty end),
            (if .reviewDecision == "CHANGES_REQUESTED" then "changes" else empty end),
            (if .mergeable == "CONFLICTING" then "conflicts" else empty end),
            (if $age > $stale then "stale \($age)d" else empty end)
          ] | join(", ")) as $text
         # no accent for "you": a section called "To review" is already the
         # signal, and accent on most of its rows just reads as glare
         | [ $text,
             (if $asked then 0 else 1 end),
             "default" ]
       end) as $note
    | { rank: (if $bucket == "review" then 0 elif $bucket == "mine" then 1 else 2 end),
        label: (if $bucket == "review" then "To review"
                elif $bucket == "mine" then "Yours" else "Quiet" end),
        sub: $note[1],
        number: $n,
        row: {
          text: ("#\($n) "
                 + (initials(.author) | if . == "" then "" else . + " " end)
                 + (if $note[0] == "" then "" else "(" + $note[0] + ") " end)
                 + .title),
          # a draft is not actionable by anyone yet, so it recedes even when
          # it is mine with red CI or one I was asked to look at
          text_color: (if .isDraft then "muted" else $note[2] end),
          icon: ci_icon($ci),
          icon_color: (if .isDraft then "muted"
                       else ci_color($ci) end),
          url: .url
        } }
  ]
| ($max_rows | tonumber) as $cap
| sort_by(.rank, .sub, -.number)
# group_by re-sorts on the same primary key, so bucket order and the order
# within each bucket both survive
| group_by(.rank)
| map(
    length as $total
    # "(3)" when everything fits, "(5/8)" when the tail is trimmed — the
    # second number is what stops a capped section reading as the whole list
    | (if $total > $cap then "(\($cap)/\($total))" else "(\($total))" end) as $count
    | [ { text: "\(.[0].label) \($count)", heading: true } ] + (.[0:$cap] | map(.row))
  )
# a blank row before every section but the first; the panel renders an empty
# text as an empty line, which is cheaper than a spacer glyph
| to_entries
| map(if .key > 0 then [ { text: "" } ] + .value else .value end)
| flatten
| .[]
JQ
)

# Cache the whole rendered payload, not just the gh call: one sidebar process
# runs per tmux window, so ten windows on this repo means ten invocations per
# interval. Keyed by repo so two repos do not evict each other.
key=$(printf '%s' "${repo:-${SIDEBAR_REPO_PATH:-$PWD}}" | cksum | cut -d' ' -f1)
cache="${TMPDIR:-/tmp}/sidebar-pr-radar-$(id -u)-$key"
# PR_RADAR_NO_CACHE=1 forces a fetch, for running this by hand. Setting
# PR_RADAR_CACHE_MINUTES=0 does not: BSD `find -mmin -0` still matches a file
# written seconds ago.
if [ -z "${PR_RADAR_NO_CACHE:-}" ] &&
   [ -f "$cache" ] && [ -n "$(find "$cache" -mmin -"$PR_RADAR_CACHE_MINUTES")" ]; then
  cat "$cache"
  exit 0
fi

# stderr + non-zero exit is the panel's error channel: it keeps the last good
# rows on screen and shows the first stderr line as `exit 1: <message>`.
command -v gh >/dev/null 2>&1 || { echo "gh not installed" >&2; exit 1; }
command -v jq >/dev/null 2>&1 || { echo "jq not installed" >&2; exit 1; }

# With no explicit repo, gh infers one from the cwd's git remotes. The panel
# runs us in the focused pane's directory, which is often not a repo at all
# (~/.config/tmux, ~, a scratch dir) — an ordinary state, not a failure, so
# say so in a row instead of exiting non-zero and painting a red footer over
# the last repo's PRs. Both checks are local; no network call happens here.
if [ -z "$repo" ]; then
  if ! git rev-parse --git-dir >/dev/null 2>&1; then
    printf '%s\n' '{"text":"Not a git repository","text_color":"muted","centered":true}'
    exit 0
  fi
  if ! git remote -v 2>/dev/null | grep -q 'github\.'; then
    printf '%s\n' '{"text":"No GitHub remote here","text_color":"muted","centered":true}'
    exit 0
  fi
fi

# gh pipes ANSI into its own json when CLICOLOR_FORCE is set, which breaks jq
export CLICOLOR_FORCE='' NO_COLOR=1

if [ -n "$repo" ]; then set -- -R "$repo"; else set --; fi

me=$(gh api user --jq .login 2>/dev/null) || me=""
[ -n "$me" ] || { echo "gh not authenticated — run 'gh auth login'" >&2; exit 1; }

# review requests here target teams, not people, so reviewRequests never names
# me; the search index resolves team membership, so ask it instead
requested=$(gh pr list "$@" --limit 100 --search "review-requested:@me" \
  --json number --jq '[.[].number] | join(",")' 2>/dev/null) || requested=""

# Written step by step rather than as one pipeline: under `set -e` only the
# last command of a pipeline is checked, and a failing gh must abort before mv
# and cat, so the panel reports gh's error instead of a missing cache file.
raw="$cache.$$.json"
tmp="$cache.$$"
trap 'rm -f "$raw" "$tmp"' EXIT

gh pr list "$@" --limit 100 \
  --json number,title,url,author,isDraft,reviewDecision,statusCheckRollup,updatedAt,mergeable,latestReviews \
  > "$raw"

jq -c --arg me "$me" --arg requested "$requested" \
      --arg stale_days "$PR_RADAR_STALE_DAYS" --arg max_rows "$PR_RADAR_MAX_ROWS" \
      "$JQ" < "$raw" > "$tmp"

mv "$tmp" "$cache"
cat "$cache"
