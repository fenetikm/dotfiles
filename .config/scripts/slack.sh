#!/bin/bash

# todo:
# - pull bearer token from lastpass cli, which sets .env var

if [[ "$SLACKPCUSERKEY" == "" ]]; then
  echo "Slack user token missing from environment."
  exit 1
fi

slack_dnd_on() {
  local MINUTES="$1"
  if [[ "$MINUTES" == "" ]]; then
    MINUTES="5"
  fi
  curl --location 'https://slack.com/api/dnd.setSnooze?num_minutes='"$MINUTES"'' \
    --header 'Authorization: Bearer '"$SLACKPCUSERKEY"''
}

slack_dnd_off() {
  curl --location 'https://slack.com/api/dnd.endSnooze' \
    --header 'Authorization: Bearer '"$SLACKPCUSERKEY"''
}

slack_status() {
  local TEXT="$1"
  local EMOJI="$2"
  local EXP="$3"
  if [[ "$EXP" == "" ]]; then
    EXP="0"
  fi

  curl --location 'https://slack.com/api/users.profile.set' \
  --header 'Authorization: Bearer '"$SLACKPCUSERKEY"'' \
  --header 'Content-Type: application/json; charset=utf-8' \
  --data '{
      "profile": {
          "status_emoji": "'"$EMOJI"'",
          "status_text": "'"$TEXT"'",
          "status_expiration": "'"$EXP"'"
      }
  }'
}

slack_status_clear() {
  slack_status "" "" ""
}

slack_afk() {
  local TIMER="$1"
  if [[ "$TIMER" == "" ]]; then
    TIMER="5"
  fi
  local NOW=$(date +%s)
  local END=$(($NOW + $TIMER * 60))
  local ENDTEXT=`echo $(date -r "$END" +"%l:%M %p")`
  local TEXT="AFK until $ENDTEXT, SMS if urgent"

  slack_status "$TEXT" ":no_entry:" "$END"
  slack_dnd_on $TIMER
}

# commands
# - status
# - afk
# - dnd

ACTION="afk"


slack_afk $1