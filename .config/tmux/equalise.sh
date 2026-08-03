#!/bin/zsh -f
#
# Equalise pane sizes in the current window (including nested splits).
#
# Note: this is a vibe script created by Cursor Composer 2.5
#       it works, but it's firmly in the "do not care" bucket
#       maybe I'll rewrite it one day or atleast get it into better shape
#
# Handles:
#   - stacked rows (pane above two panes) via full-width row bands
#   - T-layouts (full-height column beside a vertical stack) via column/stack passes
#   - flat horizontal splits beside a sidebar
#
# Usage:
#   equalise.sh                     # current window, sidebar width from @sidebar_width
#   equalise.sh --window @5         # specific window
#   equalise.sh --passes 2          # repeat row/column passes for stubborn layouts
#   equalise.sh --no-sidebar        # ignore sidebar role, equalise everything
#
# Limitations:
#   - Skips zoomed windows
#   - Assumes sidebar spans full window height on left or right edge

emulate -LR zsh
setopt localoptions no_unset
unsetopt verbose xtrace
setopt NOVERBOSE NOXTRACE

typeset -a args=("$@")
typeset target="" passes=1 respect_sidebar=1 sidebar_width=""

while (( $# )); do
  case "$1" in
    --window|-w)
      target="$2"; shift 2 ;;
    --passes|-p)
      passes="$2"; shift 2 ;;
    --no-sidebar)
      respect_sidebar=0; shift ;;
    --sidebar-width)
      sidebar_width="$2"; shift 2 ;;
    -h|--help)
      sed -n '2,20p' "$0"; exit 0 ;;
    *)
      echo "equalise.sh: unknown option: $1" >&2; exit 2 ;;
  esac
done

[[ -n "$target" ]] || target="$(tmux display-message -p '#{window_id}')"

if [[ "$(tmux display-message -p -t "$target" '#{window_zoomed_flag}')" == 1 ]]; then
  exit 0
fi

typeset -i win_w win_h
win_w=$(tmux display-message -p -t "$target" '#{window_width}')
win_h=$(tmux display-message -p -t "$target" '#{window_height}')

# --- pane snapshot: id|left|top|width|height|role --------------------------------

typeset -a pane_lines=()
pane_lines=("${(@f)$(tmux list-panes -t "$target" -F '#{pane_id}|#{pane_left}|#{pane_top}|#{pane_width}|#{pane_height}|#{@pane_role}')}")

# id -> "left top width height role"
typeset -A geo role
typeset -a ids=()

for line in "${pane_lines[@]}"; do
  [[ -n "$line" ]] || continue
  typeset -a f=("${(@s:|:)line}")
  (( ${#f} >= 6 )) || continue
  ids+=("$f[1]")
  geo[$f[1]]="$f[2] $f[3] $f[4] $f[5]"
  role[$f[1]]="$f[6]"
done

(( ${#ids} <= 1 )) && exit 0

# --- helpers ---------------------------------------------------------------------

geo_field() {
  # geo_field ID left|top|width|height
  typeset -a g=(${=geo[$1]})
  case "$2" in
    left)   print -r -- "$g[1]" ;;
    top)    print -r -- "$g[2]" ;;
    width)  print -r -- "$g[3]" ;;
    height) print -r -- "$g[4]" ;;
  esac
}

geo_right() {
  typeset -i l w
  l=$(geo_field "$1" left)
  w=$(geo_field "$1" width)
  print -r -- $(( l + w ))
}

geo_bottom() {
  typeset -i t h
  t=$(geo_field "$1" top)
  h=$(geo_field "$1" height)
  print -r -- $(( t + h ))
}

refresh_geo() {
  typeset id raw
  for id in "${ids[@]}"; do
    raw="$(tmux display-message -p -t "$id" '#{pane_left}|#{pane_top}|#{pane_width}|#{pane_height}')"
    geo[$id]="${raw//|/ }"
  done
}

is_sidebar() {
  [[ "$respect_sidebar" -eq 1 && "${role[$1]}" == sidebar ]]
}

# --- sidebar width ---------------------------------------------------------------

resolve_sidebar_cols() {
  if [[ -n "$sidebar_width" ]]; then
    print -r -- "$sidebar_width"
    return
  fi

  typeset setting
  setting=$(tmux show-options -gv @sidebar_width 2>/dev/null || true)
  [[ -n "$setting" ]] || setting="15%"

  if [[ "$setting" == *% ]]; then
    typeset -i pct cols
    pct=${setting%%%}
    cols=$(( win_w * pct / 100 ))
    (( cols < 1 )) && cols=1
    print -r -- "$cols"
  else
    print -r -- "$setting"
  fi
}

pin_sidebars() {
  typeset -a sidebars=()
  typeset id
  for id in "${ids[@]}"; do
    is_sidebar "$id" && sidebars+=("$id")
  done
  (( ${#sidebars[@]} == 0 )) && return

  typeset -i cols
  cols=$(resolve_sidebar_cols)

  typeset position
  position=$(tmux show-options -gv @sidebar_position 2>/dev/null || echo left)
  position=${${position:l}// /}

  for id in "${sidebars[@]}"; do
    tmux resize-pane -t "$id" -x "$cols" 2>/dev/null
  done

  refresh_geo
}

# main-area bounds (excluding pinned sidebar strip)
main_bounds() {
  typeset -i left=0 width=$win_w
  typeset -a sidebars=()

  typeset id
  for id in "${ids[@]}"; do
    is_sidebar "$id" && sidebars+=("$id")
  done

  if (( ${#sidebars[@]} )); then
    typeset position
    position=$(tmux show-options -gv @sidebar_position 2>/dev/null || echo left)
    position=${${position:l}// /}

    if [[ "$position" == right ]]; then
      typeset -i s_left
      s_left=$(geo_field "${sidebars[1]}" left)
      width=$s_left
    else
      typeset -i s_right
      s_right=$(geo_right "${sidebars[1]}")
      left=$s_right
      width=$(( win_w - s_right ))
    fi
  fi

  print -r -- "$left $width"
}

pane_in_main() {
  typeset -i p_left p_right m_left m_width
  p_left=$(geo_field "$1" left)
  p_right=$(geo_right "$1")
  typeset -a mb=(${=$(main_bounds)})
  m_left=$mb[1]
  m_width=$mb[2]
  typeset -i m_right=$(( m_left + m_width ))

  # mostly inside main strip (allow 1-col border slack)
  (( p_left >= m_left - 1 && p_right <= m_right + 1 ))
}

sort_panes_by() {
  # sort_panes_by left|top  pane_id...
  typeset key=$1; shift
  typeset -a pairs=() id
  for id in "$@"; do
    pairs+=("$(geo_field "$id" "$key") $id")
  done
  pairs=(${(on)pairs})
  for pair in "${pairs[@]}"; do
    print -r -- "${pair#* }"
  done
}

main_pane_ids() {
  typeset id
  for id in "${ids[@]}"; do
    is_sidebar "$id" && continue
    pane_in_main "$id" || continue
    print -r -- "$id"
  done
}

# Fill MAIN_PANES without subshells (safe for downstream grouping).
typeset -a MAIN_PANES=()
collect_main_panes() {
  MAIN_PANES=()
  typeset id
  for id in "${ids[@]}"; do
    is_sidebar "$id" && continue
    pane_in_main "$id" || continue
    MAIN_PANES+=("$id")
  done
}

row_spans_main_width() {
  typeset -a panes=("$@")
  typeset -a mb=(${=$(main_bounds)})
  typeset -i main_w=$mb[2] total_w=0
  typeset id
  for id in "${panes[@]}"; do
    total_w=$(( total_w + $(geo_field "$id" width) ))
  done
  typeset -i borders=$(( ${#panes[@]} > 1 ? ${#panes[@]} - 1 : 0 ))
  (( total_w + borders >= main_w - 1 ))
}

# --- equal split helpers ---------------------------------------------------------

# Split usable space into equal integer sizes; distribute +1 remainder first-to-last.
equal_sizes() {
  typeset -i usable=$1 count=$2
  (( count >= 1 && usable >= count )) || return 1

  typeset -i base=$(( usable / count )) rem=$(( usable % count ))
  typeset -i i extra=$rem
  for (( i = 1; i <= count; i++ )); do
    if (( extra > 0 )); then
      print -r -- $(( base + 1 ))
      extra=$(( extra - 1 ))
    else
      print -r -- "$base"
    fi
  done
}

# Returns one line per row:  top|height|pane_id ...
# Rows are panes sharing the same top and height (one horizontal band).
find_rows() {
  typeset -A row_map row_top
  typeset id key

  collect_main_panes
  for id in "${MAIN_PANES[@]}"; do
    key="$(geo_field "$id" top):$(geo_field "$id" height)"
    row_map[$key]+="$id "
    row_top[$key]=$(geo_field "$id" top)
  done

  typeset -a keys=(${(on)${(k)row_map}})
  typeset -a sorted=()
  typeset k
  for k in "${keys[@]}"; do
    sorted+=("${row_top[$k]}|$k")
  done
  sorted=(${(on)sorted})

  for k in "${sorted[@]##*|}"; do
    typeset top=${k%%:*} height=${k##*:}
    typeset -a panes=(${(ps: :)${row_map[$k]}})
    row_spans_main_width "${panes[@]}" || continue
    print -r -- "${top}|${height}|${(j: :)panes}"
  done
}

# Vertical stacks: panes sharing left edge and width (column splits).
find_vertical_stacks() {
  typeset -A stack_map
  typeset id key

  collect_main_panes
  for id in "${MAIN_PANES[@]}"; do
    key="$(geo_field "$id" left):$(geo_field "$id" width)"
    stack_map[$key]+="$id "
  done

  for key in ${(on)${(k)stack_map}}; do
    typeset -a panes=($(sort_panes_by top ${(ps: :)stack_map[$key]}))
    (( ${#panes[@]} >= 2 )) || continue
    print -r -- "${key}|${(j:|:)panes}"
  done
}

# Side-by-side columns that each span (nearly) the full window height.
find_full_height_columns() {
  typeset -A stack_map
  typeset id key

  collect_main_panes
  for id in "${MAIN_PANES[@]}"; do
    key="$(geo_field "$id" left):$(geo_field "$id" width)"
    stack_map[$key]+="$id "
  done

  typeset -a columns=()
  for key in ${(on)${(k)stack_map}}; do
    typeset -i min_top=999999 max_bottom=0
    for id in ${(ps: :)stack_map[$key]}; do
      min_top=$(( min_top < $(geo_field "$id" top) ? min_top : $(geo_field "$id" top) ))
      max_bottom=$(( max_bottom > $(geo_bottom "$id") ? max_bottom : $(geo_bottom "$id") ))
    done
    (( max_bottom - min_top >= win_h - 1 )) || continue
    columns+=("$key")
  done

  (( ${#columns[@]} >= 2 )) || return

  typeset -a sorted=()
  for key in "${columns[@]}"; do
    sorted+=("${key%%:*}|$key")
  done
  sorted=(${(on)sorted})

  typeset -a chain=()
  typeset -i prev_right=-1
  typeset -a stack_panes=()
  typeset pane_id
  for key in "${sorted[@]##*|}"; do
    stack_panes=($(sort_panes_by left ${(ps: :)stack_map[$key]}))
    pane_id=$stack_panes[1]
    [[ -n "$pane_id" ]] || continue
    if (( prev_right >= 0 && $(geo_field "$pane_id" left) - prev_right > 1 )); then
      (( ${#chain[@]} >= 2 )) && print -r -- "${(j:|:)chain}"
      chain=()
      prev_right=-1
    fi
    chain+=("$key")
    prev_right=$(geo_right "$pane_id")
  done
  (( ${#chain[@]} >= 2 )) && print -r -- "${(j:|:)chain}"
}

equalise_vertical_stack_heights() {
  typeset -a stack_lines=("${(@f)$(find_vertical_stacks)}")
  typeset line stack_key panes_str
  for line in "${stack_lines[@]}"; do
    [[ -n "$line" ]] || continue
    stack_key=${line%%|*}
    panes_str=${line#*|}
    typeset -a panes=(${(s:|:)panes_str})
    typeset -i n=${#panes[@]}
    (( n >= 2 )) || continue

    typeset -i min_top=999999 max_bottom=0
    typeset id
    for id in "${panes[@]}"; do
      min_top=$(( min_top < $(geo_field "$id" top) ? min_top : $(geo_field "$id" top) ))
      max_bottom=$(( max_bottom > $(geo_bottom "$id") ? max_bottom : $(geo_bottom "$id") ))
    done

    typeset -i usable=$(( (max_bottom - min_top) - (n - 1) ))
    (( usable >= n )) || continue

    typeset -a heights=("${(@f)$(equal_sizes $usable $n)}")
    (( ${#heights[@]} == n )) || continue

    typeset -i i
    for (( i = 1; i < n; i++ )); do
      id=$panes[i]
      [[ -n "$id" ]] || continue
      typeset -i cur=$(geo_field "$id" height) new_h=$heights[i]
      (( new_h != cur )) && tmux resize-pane -t "$id" -y "$new_h" 2>/dev/null
    done
  done
}

equalise_full_height_column_widths() {
  typeset -A stack_map
  typeset id key

  collect_main_panes
  for id in "${MAIN_PANES[@]}"; do
    key="$(geo_field "$id" left):$(geo_field "$id" width)"
    stack_map[$key]+="$id "
  done

  typeset -a groups=("${(@f)$(find_full_height_columns)}")
  typeset group
  for group in "${groups[@]}"; do
    [[ -n "$group" ]] || continue
    typeset -a stack_keys=("${(@s:|:)group}")
    typeset -i n=${#stack_keys[@]}
    (( n >= 2 )) || continue

    typeset -a mb=(${=$(main_bounds)})
    typeset -i usable=$(( mb[2] - (n - 1) ))
    (( usable >= n )) || continue

    typeset -a widths=("${(@f)$(equal_sizes $usable $n)}")
    (( ${#widths[@]} == n )) || continue

    typeset -i i cur new_w
    typeset stack_key
    typeset -a stack_panes=()
    typeset pane_id
    for (( i = 1; i < n; i++ )); do
      stack_key=$stack_keys[i]
      stack_panes=($(sort_panes_by left ${(ps: :)stack_map[$stack_key]}))
      pane_id=$stack_panes[1]
      [[ -n "$pane_id" ]] || continue
      cur=$(geo_field "$pane_id" width)
      new_w=$widths[i]
      (( new_w != cur )) && tmux resize-pane -t "$pane_id" -x "$new_w" 2>/dev/null
    done
  done
}

rebalance_row_heights() {
  typeset -a row_lines=("${(@f)$(find_rows)}")
  typeset -i nrows=${#row_lines[@]}
  (( nrows >= 1 )) || return

  typeset -i usable=$(( win_h - (nrows - 1) ))
  (( usable >= nrows )) || return

  typeset -a heights=("${(@f)$(equal_sizes $usable $nrows)}")
  (( ${#heights[@]} == nrows )) || return

  # Only resize the top row downward; lower rows absorb the remainder.
  # Resizing every pane in a row fights the layout tree.
  typeset -i i
  typeset id
  for (( i = 1; i < nrows; i++ )); do
    typeset -a parts=("${(@s:|:)row_lines[i]}")
    typeset -a panes=($(sort_panes_by left ${(ps: :)parts[3]}))
    id=$panes[1]
    [[ -n "$id" ]] || continue
    typeset -i cur=$(geo_field "$id" height) new_h=$heights[i]
    (( new_h != cur )) && tmux resize-pane -t "$id" -y "$new_h" 2>/dev/null
  done
}

rebalance_row_widths() {
  typeset -a mb=(${=$(main_bounds)})
  typeset -i main_w=$mb[2]
  (( main_w >= 1 )) || return

  typeset -a row_lines=("${(@f)$(find_rows)}")
  typeset line
  for line in "${row_lines[@]}"; do
    [[ -n "$line" ]] || continue
    typeset -a parts=("${(@s:|:)line}")
    typeset -a panes=($(sort_panes_by left ${(ps: :)parts[3]}))
    typeset -i ncols=${#panes[@]}
    (( ncols >= 1 )) || continue

    typeset -i usable=$(( main_w - (ncols - 1) ))
    (( usable >= ncols )) || continue

    typeset -a widths=("${(@f)$(equal_sizes $usable $ncols)}")
    (( ${#widths[@]} == ncols )) || continue

    # Resize leftmost panes only; rightmost column absorbs the remainder.
    typeset -i j cur new_w
    for (( j = 1; j < ncols; j++ )); do
      [[ -n "${panes[j]:-}" ]] || continue
      cur=$(geo_field "${panes[j]}" width)
      new_w=$widths[j]
      (( new_w != cur )) && tmux resize-pane -t "${panes[j]}" -x "$new_w" 2>/dev/null
    done
  done
}

# --- main loop -------------------------------------------------------------------

pin_sidebars

typeset -i pass
for (( pass = 1; pass <= passes; pass++ )); do
  refresh_geo
  equalise_full_height_column_widths
  refresh_geo
  equalise_vertical_stack_heights
  refresh_geo
  rebalance_row_heights
  refresh_geo
  rebalance_row_widths
done

pin_sidebars
