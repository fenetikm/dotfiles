#!/bin/zsh

# ref: https://engineering.toggl.com/docs/api/time_entries/

# todo:
# - handle bad token / auth issues

source "$HOME/.config/sketchybar/vars.sh"

STORAGE_DIR=.
PROJECT_NAME=
PROJECT_COLOUR=
TASK_NAME=
TEXT=

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
  if [[ "$CURRENT" == "null" ]]; then
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

  local START=$(echo "$CURRENT" | jq -r .start | gsed 's/00:00/0000/')
  local NOW=$(date +"%s")
  local START_UNIX=$(date -j -f "%Y-%m-%dT%H:%M:%S%z" "$START" +"%s" 2>/dev/null)
  local CALC="$NOW-$START_UNIX"
  CALC="($CALC)/60"
  local MINS=$(echo $CALC | bc)
  local HRS=$(echo "($MINS)/60" | bc)
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
echo $ICON$TEXT
