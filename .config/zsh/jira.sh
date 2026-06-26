#!/bin/bash

source '~/.config/watson/watson_tools.zsh'

jira_edit() {
  if [ -z "$1" ]; then
    echo "Missing issue ID when trying to edit jira issue."
  else
    jira edit "$1"
  fi
  exit;
}

jira_comment() {
  if [ -z "$1" ]; then
    echo "Missing issue ID when trying to comment on jira issue."
  else
    jira comment "$1"
  fi
  exit;
}

jira_worklog() {
  # @todo check if timer running for current issue
  if [ -z "$1" ]; then
    echo "Missing issue ID when trying to add worklog for jira issue."
    exit;
  fi

  jira worklog add "$1"
}

jira_worklog_time() {
  if [ -z "$1" ]; then
    echo "Missing issue ID when trying to submit given time for issue."
    exit;
  fi
  # @todo get time spent here
  TIME=watson_time
  jira worklog add --time-spent="$1" --noedit "$1"
}

jira_submit() {
  # check for timer running
  RUNNING=`watson status | grep 'No project started'`
  if [[ -n $RUNNING ]] ; then
    # not running
    watson_start "$issue"
    tmux refresh-client -S
    exit;
  fi

  # ask whether to submit worklog
  echo 'running'
  exit;

  read -p "Submit running timer [y,n,?]" yn
  case $yn in
    [Yy]* ) jira_worklog_time "$issue"; watson stop;;
    [Nn]* ) watson stop;;
    [?]* ) echo "Yes [y], no [n]";;
    * ) echo "Please select an option.";;
  esac

  exit;
}

jira_command() {
  if [ -z "$1" ]; then
    echo "Missing jira command to run."
    exit;
  fi

  local out issue key
  IFS=$'\n' out=($(eval "$1" | fzf --expect=ctrl-e,ctrl-c,ctrl-w,ctrl-s --preview-window up:50% --preview 'jira view $(echo {} | tr -d "[:space:]" | cut -d ':' -f 1)'))
  key=$(head -1 <<< "$out")
  issue=$(head -2 <<< "$out" | tail -1 | tr -d "[:space:]" | cut -d '|' -f 1)

  if [ "$key" = ctrl-e ]; then
    jira_edit "$issue"
  fi

  if [ "$key" = ctrl-c ]; then
    jira_comment "$issue"
  fi

  if [ "$key" = ctrl-w ]; then
    jira_worklog "$issue"
  fi

  if [ "$key" = ctrl-s ]; then
    jira_submit "$issue"
  fi

  echo "Act on issue $issue: [e,c,s,w,q,?]"
  echo "Edit, comment, start/submit, worklog, quit:"
  read -p "[e,c,s,w,q ?] " com
    case $com in
      [Ee]* ) jira_edit "$issue";;
      [Cc]* ) jira_comment "$issue";;
      [Ss]* ) jira_submit "$issue";;
      [Ww]* ) jira_worklog "$issue";;
      [Qq]* ) exit;;
      [?]* ) echo "e - edit issue\nc - add comment to isse\ns - start timer / submit timer\nw - add worklog to issue\nq - quit";;
      * ) echo "Please select an option.";;
    esac
}

jira_command "$@"
