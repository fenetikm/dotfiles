#!/bin/bash

# it seems that sometimes current will be exist when no project from status
CURRENT=`watson log -c | grep current`
NO_PROJECT=0
if [[ -z "$CURRENT" ]] ; then
  NO_PROJECT=1
fi

PROJECT=`watson status -p`
if [[ "$PROJECT" == "No project started" ]]; then
  NO_PROJECT=1
fi

if [[ "$NO_PROJECT" == 1 ]]; then
  echo "#[fg=#89898c]No timer running"
  exit;
fi

# tags
TRIMMED=`echo "$CURRENT" | sed -e "s/^[[:space:]]*//" | xargs`
TAGS=""
if [[ "$TRIMMED" =~ \[(.*)\] ]] ; then
  # e.g. [jira]
  TAGS=" #[fg=#ff8000][#[fg=#8fa3bf]${BASH_REMATCH[1]}#[fg=#ff8000]]"
fi

# just get hours and minutes
TIME=`echo "$CURRENT" | cut -c 26-34 | xargs`
if [[ -z "$TIME" ]]; then
  TIME="0m"
fi

# falcon specific
# e.g. $ my_project 14h 10m
echo "#[fg=#8fa3bf]$ #[fg=#d4d4d9]$PROJECT$TAGS #[fg=yellow]$TIME"
