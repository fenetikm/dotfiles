#!/bin/zsh

# ref: https://engineering.toggl.com/docs/api/time_entries/

# todo:
# - handle bad token / auth issues
# - diff colour depending on project
# - if after a week, refresh cache

source "$HOME/.config/sketchybar/vars.sh"

STORAGE_DIR=plugins
PROJECT_NAME=
PROJECT_COLOUR=
TASK_NAME=
TEXT=
COLOUR=$DEFAULT_COLOUR
# STYLE=contrast
STYLE=subtle

get_project() {
  local WORKSPACE_ID=$1
  local PROJECT_ID=$2
  if [[ ! -f "$STORAGE_DIR/project_$PROJECT_ID.json" ]]; then
    curl -s -u "$TOGGLAPIKEY":api_token \
      -o "$STORAGE_DIR/project_$PROJECT_ID.json" \
      -H "Content-Type: application/json" \
      -X GET https://api.track.toggl.com/api/v9/workspaces/"$WORKSPACE_ID"/projects/"$PROJECT_ID"
  fi
  local PROJECT=$(cat "$STORAGE_DIR/project_$PROJECT_ID.json")
  PROJECT_NAME=$(echo "$PROJECT" | jq -r .name)
  PROJECT_COLOUR=$(echo "$PROJECT" | jq -r .color)
}

get_task() {
  local WORKSPACE_ID=$1
  local PROJECT_ID=$2
  local TASK_ID=$3
  if [[ ! -f "$STORAGE_DIR/task_$TASK_ID.json" ]]; then
    curl -s -u "$TOGGLAPIKEY":api_token \
      -o "$STORAGE_DIR/task_$TASK_ID.json" \
      -H "Content-Type: application/json" \
      -X GET https://api.track.toggl.com/api/v9/workspaces/"$WORKSPACE_ID"/projects/"$PROJECT_ID"/tasks/"$TASK_ID"
  fi
  local TASK=$(cat "$STORAGE_DIR/task_$TASK_ID.json")
  TASK_NAME=$(echo "$TASK" | jq -r .name)
}

get_current() {
  local CURRENT=$(curl -s -u "$TOGGLAPIKEY":api_token \
      -H "Content-Type: application/json" \
      -X GET https://api.track.toggl.com/api/v9/me/time_entries/current)
  if [[ "$CURRENT" == "null" || "$CURRENT" == "" ]]; then
    return
  fi

  local WORKSPACE_ID=$(echo "$CURRENT" | jq -r .workspace_id)
  local PROJECT_ID=$(echo "$CURRENT" | jq -r .project_id)
  local TASK_ID=$(echo "$CURRENT" | jq -r .task_id)
  local DESCRIPTION=$(echo "$CURRENT" | jq -r .description)

  get_project "$WORKSPACE_ID" "$PROJECT_ID"
  if [[ ! "$TASK_ID" == "null" ]]; then
    get_task "$WORKSPACE_ID" "$PROJECT_ID" "$TASK_ID"
  fi

  local START=$(echo "$CURRENT" | jq -r .start | gsed 's/\+00:00/\+0000/')
  local NOW=$(date +"%s")
  local START_UNIX=$(date -j -f "%Y-%m-%dT%H:%M:%S%z" "$START" +"%s" 2>/dev/null)
  local CALC="$NOW - $START_UNIX"
  CALC="($CALC) / 60"
  local MINS=$(echo $CALC | bc)
  local HRS=$(echo "($MINS) / 60" | bc)
  MINS=$(echo "($MINS % 60)" | bc)
  local TIME="$MINS"m
  if [[ "$HRS" > 0 ]]; then
    TIME="$HRS"h"$TIME"
  fi

  if [[ -n "$TASK_NAME" ]]; then
    TEXT="$TIME $PROJECT_NAME:$TASK_NAME"
  elif [[ -n "$DESCRIPTION" ]]; then
    TEXT="$TIME $PROJECT_NAME:$DESCRIPTION"
  else
    TEXT="$TIME $PROJECT_NAME"
  fi
}

ICON=" "

get_current

if [[ -n "$TEXT" ]]; then
  PROJECT_COLOUR=$(echo "$PROJECT_COLOUR" | sed 's/^.//')
  if [[ "$STYLE" == "contrast" ]]; then
    BG_COLOUR="$BG1_COLOUR"
    PROJECT_COLOUR="0xff$PROJECT_COLOUR"
    FG_COLOUR="$PROJECT_COLOUR"
  else
    BG_COLOUR="0x50$PROJECT_COLOUR"
    FG_COLOUR="$DEFAULT_COLOUR"
  fi

  # haven't got the right balance here with respect to info vs colour
  # icon is kind of pointless
  sketchybar --set "$NAME" icon="$ICON" icon.color="${FG_COLOUR}" label="${TEXT}" label.color="${FG_COLOUR}" drawing=on \
    padding_right=7 \
    label.padding_right=8 \
    icon.padding_left=8 \
    icon.y_offset=-1 \
    y_offset=-1 \
    background.shadow.drawing=off \
    background.color=0x00000000 \
    background.drawing=on \
    background.border_color=$BG_COLOUR background.border_width=2 \
    background.corner_radius=$BG_RADIUS background.height=$BG_HEIGHT

  # sketchybar --set "$NAME" icon="$ICON" icon.color="${FG_COLOUR}" label="${TEXT}" label.color="${FG_COLOUR}" drawing=on \
  #   padding_right=7 \
  #   label.padding_right=8 \
  #   icon.padding_left=8 \
  #   icon.y_offset=-1 \
  #   y_offset=-1 \
  #   background.shadow.drawing=on background.shadow.distance=1 \
  #   background.drawing=on background.color=$BG_COLOUR \
  #   background.corner_radius=$BG_RADIUS background.height=$BG_HEIGHT
else
  sketchybar --set "$NAME" drawing=off
fi
