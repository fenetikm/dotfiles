#!/bin/bash

# ref: https://engineering.toggl.com/docs/api/time_entries/

# todo:
# - handle bad token / auth issues
# - diff colour depending on project
# - project and task caching

get_project() {
  local WORKSPACE_ID=$1
  local PROJECT_ID=$2
  local PROJECT=$(curl -s -u "$TOGGLAPIKEY":api_token \
    -H "Content-Type: application/json" \
    -X GET https://api.track.toggl.com/api/v9/workspaces/"$WORKSPACE_ID"/projects/"$PROJECT_ID")
  local PROJECT_NAME=$(echo "$PROJECT" | jq -r .name)
  local PROJECT_COLOUR=$(echo "$PROJECT" | jq -r .color)
}

get_task() {
  local WORKSPACE_ID=$1
  local PROJECT_ID=$2
  local TASK_ID=$3
  local TASK=$(curl -s -u "$TOGGLAPIKEY":api_token \
    -H "Content-Type: application/json" \
    -X GET https://api.track.toggl.com/api/v9/workspaces/"$WORKSPACE_ID"/projects/"$PROJECT_ID"/tasks/"$TASK_ID")
      local TASK_NAME=$(echo "$TASK" | jq -r .name)
}

get_current() {
  local CURRENT=$(curl -s -u "$TOGGLAPIKEY":api_token \
      -H "Content-Type: application/json" \
      -X GET https://api.track.toggl.com/api/v9/me/time_entries/current)

  local WORKSPACE_ID=$(echo "$CURRENT" | jq -r .workspace_id)
  local PROJECT_ID=$(echo "$CURRENT" | jq -r .project_id)
  local TASK_ID=$(echo "$CURRENT" | jq -r .task_id)

  # echo $(get_project "$WORKSPACE_ID" "$PROJECT_ID")
  echo $(get_task "$WORKSPACE_ID" "$PROJECT_ID" "$TASK_ID")

  local START=$(echo "$CURRENT" | jq -r .start | gsed 's/00:00/0000/')
  local NOW=$(date +"%s")
  local START_UNIX=$(date -j -f "%Y-%m-%dT%H:%M:%S%z" "$START" +"%s" 2>/dev/null)
  local CALC="$NOW-$START_UNIX"
  CALC="($CALC)/60"
  local DIFF=$(echo $CALC | bc)
  echo "$DIFF"
}

get_current
