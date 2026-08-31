#!/usr/bin/env zsh

# GitHub PR radar — buckets a repo's open PRs into what to review, what of mine
# needs a poke, and what can be ignored, so one glance answers "what next?".

: ${PR_RADAR_REPO:=GetSuperIT/subtechnica}
: ${PR_RADAR_STALE_DAYS:=7}

# jq program: takes $me and $requested (comma separated PR numbers waiting on
# me), emits sorted TSV rows of bucket/number/author/ci/age/title/note
#
# $(cat) rather than `read -r -d ''`, this file is sourced from .zshenv so it
# also runs in the throwaway shells fzf spawns for a --preview, and there the
# read never returns and the preview hangs on "Loading"
_PR_RADAR_JQ=$(cat <<'JQ'
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

def short_title:
  if (.title | length) > 52 then (.title[0:51] + "…") else .title end;

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
    | (if $mine then
         (if $ci == "fail" then ["CI red", 0]
          elif .reviewDecision == "CHANGES_REQUESTED" then ["address feedback", 1]
          elif .reviewDecision == "APPROVED" and .mergeable == "CONFLICTING" then ["rebase, then merge", 2]
          elif .reviewDecision == "APPROVED" then ["merge it", 2]
          elif .isDraft then ["", 4]
          else ["no review yet", 3] end)
       else
         [ ([ (if $asked then "asked you" else empty end),
            (if my_review($me) != "" then "you: " + (my_review($me) | ascii_downcase) else empty end),
            (if .reviewDecision == "CHANGES_REQUESTED" then "changes requested" else empty end),
            (if .mergeable == "CONFLICTING" then "conflicts" else empty end),
            (if $age > $stale then "stale" else empty end)
            ] | join(", ")),
           (if $asked then 0 else 1 end) ]
       end) as $note
    | { bucket: $bucket,
        rank: (if $bucket == "review" then 0 elif $bucket == "mine" then 1 else 2 end),
        sub: $note[1],
        number, author: .author.login,
        draft: (if .isDraft then "draft" else "ready" end),
        ci: $ci, age: $age,
        title: short_title, note: $note[0] }
  ]
| sort_by(.rank, .sub, -.number)
| .[]
| [ .bucket, (.number | tostring), .author, .draft, .ci, (.age | tostring), .title, .note ]
| @tsv
JQ
)

pr_radar() {
  local repo=${1:-$PR_RADAR_REPO}
  local me requested rows

  command -v gh >/dev/null || { print_red "pr_radar: gh not installed"; return 1 }
  command -v jq >/dev/null || { print_red "pr_radar: jq not installed"; return 1 }

  # gh pipes ANSI into its own json when CLICOLOR_FORCE is set, which breaks jq
  export CLICOLOR_FORCE= NO_COLOR=1

  me=$(gh api user --jq .login 2>/dev/null)
  [[ -n $me ]] || { print_red "pr_radar: gh not authenticated — run 'gh auth login'"; return 1 }

  # review requests here target teams, not people, so reviewRequests never names
  # me; the search index resolves team membership, so ask it instead
  requested=$(gh pr list -R "$repo" --limit 100 --search "review-requested:@me" \
    --json number --jq '[.[].number] | join(",")' 2>/dev/null)

  rows=$(gh pr list -R "$repo" --limit 100 \
    --json number,title,author,isDraft,reviewDecision,statusCheckRollup,updatedAt,mergeable,latestReviews \
    | jq -r --arg me "$me" --arg requested "$requested" \
           --arg stale_days "$PR_RADAR_STALE_DAYS" "$_PR_RADAR_JQ") || return 1

  local RED GRN YEL DIM BOLD RST
  if [[ -t 1 ]]; then
    RED=$'\e[31m' GRN=$'\e[32m' YEL=$'\e[33m' DIM=$'\e[2m' BOLD=$'\e[1m' RST=$'\e[0m'
  fi

  local -a review mine quiet
  local bucket num author draft ci age title note mark dmark line
  while IFS=$'\t' read -r bucket num author draft ci age title note; do
    if [[ $draft == draft ]]; then dmark="${YEL}d${RST}"; else dmark="${DIM}r${RST}"; fi
    case $ci in
      ok)   mark="${GRN}✓${RST}" ;;
      fail) mark="${RED}✗${RST}" ;;
      run)  mark="${YEL}◌${RST}" ;;
      *)    mark="${DIM}·${RST}" ;;
    esac
    line=$(printf '  %s#%-5s%s %-14s %s %s %3sd  %-52s %s%s%s' \
      "$BOLD" "$num" "$RST" "$author" "$dmark" \
      "$mark" "$age" "$title" "$DIM" "$note" "$RST")
    case $bucket in
      review) review+=("$line") ;;
      mine)   mine+=("$line") ;;
      *)      quiet+=("$line") ;;
    esac
  done <<< "$rows"

  print -r -- "${BOLD}PR RADAR${RST}  ${DIM}${repo} · $(date '+%a %d %b %H:%M')${RST}"

  if (( $#review )); then
    print; print -r -- "${BOLD}▶ YOU CAN REVIEW (${#review})${RST}"
    print -rl -- $review
  fi
  if (( $#mine )); then
    print; print -r -- "${BOLD}▶ YOUR PRs (${#mine})${RST}"
    print -rl -- $mine
  fi
  if (( $#quiet )); then
    print; print -r -- "${DIM}▶ QUIET (${#quiet})${RST}"
    print -rl -- $quiet
  fi
  if (( $#review + $#mine + $#quiet == 0 )); then
    print; print_green "No open PRs."
  else
    print; print -r -- "${DIM}gh pr view <n> --web · gh pr checkout <n>${RST}"
  fi
}

# gho [number] — open a PR in the browser. Bare `gho` opens the PR for the
# current branch. Outside a git repo it falls back to $PR_RADAR_REPO.
gho() {
  local -a repo_arg
  git rev-parse --git-dir >/dev/null 2>&1 || repo_arg=(-R "$PR_RADAR_REPO")

  if [[ -z $1 ]] && (( $#repo_arg )); then
    print_red "gho: not in a git repo — give a PR number"
    return 1
  fi

  CLICOLOR_FORCE= NO_COLOR=1 gh pr view $1 --web $repo_arg
}
