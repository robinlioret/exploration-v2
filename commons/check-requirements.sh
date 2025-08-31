#!/bin/bash

source commons/utils.sh

ALL_OK=true

fn_test() {
  if which $1 > /dev/null  2>&1; then
    display --right "Detected ✅" --left "$1" -e "." -w $GLOBAL_MAX_WIDTH
  else if [[ "$2" = "optional" ]]; then
      display --right "Not detected (Optional) 🟠" --left "$1" -e "." -w $GLOBAL_MAX_WIDTH
    else
      display --right "Missing ❌" --left "$1" -e "." -w $GLOBAL_MAX_WIDTH
      ALL_OK=false
    fi
  fi
}


title "CHECK REQUIREMENTS"

fn_test kind
fn_test kubectl
fn_test helm
fn_test docker
fn_test dig
fn_test easyrsa
fn_test telepresence optional
fn_test argocd optional

if ! $ALL_OK; then
  action_failed "There are missing requirements"
  exit 1
fi