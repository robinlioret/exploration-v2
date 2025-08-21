#!/bin/bash

source commons/utils.sh

action "Check security"
if [[ "$DIR" = "" ]] || [[ "$DIR" = "/" ]]; then
  action_failed "Dangerous value in DIR: $DIR"
  exit 1
fi
action_done

action "Delete files in $DIR"
test -d "$DIR" && rm -rf $DIR/*
action_done