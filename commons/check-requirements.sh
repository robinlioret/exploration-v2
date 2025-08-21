#!/bin/bash

source commons/utils.sh

ALL_OK=true

fn_test() {
  if which $1 > /dev/null  2>&1; then
    info "\t✅ $1" 
  else if [[ "$2" = "optional" ]]; then
      info "\t🟠 $1 not detected. Can be required by specific modules or is simply recommanded."
    else
      info "\t❌ $1 not detected, please install it"
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
fn_test telepresence optional
fn_test argocd optional
fn_test easyrsa

if ! $ALL_OK; then
  action_failed "There are missing requirements"
  exit 1
fi