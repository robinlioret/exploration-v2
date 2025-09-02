#!/bin/bash

source commons/utils.sh

ALL_OK=true
title "CHECK REQUIREMENTS: GLOBAL"
check_requirement -c easyrsa -u https://easy-rsa.readthedocs.io/en/latest/ || ALL_OK=false
check_requirement -c docker -u https://docs.docker.com/engine/install/ || LOCAL_ALL_OK=false
check_requirement -c helm -u https://helm.sh/docs/intro/install/ || LOCAL_ALL_OK=false
check_requirement -c kubectl -u https://kubernetes.io/docs/tasks/tools/ || LOCAL_ALL_OK=false

# ADD EXTRA REQUIREMENTS HERE
source dns/check-requirements.sh || ALL_OK=false
source cluster/check-requirements.sh || ALL_OK=false
source argocd/check-requirements.sh || ALL_OK=false
source telepresence/check-requirements.sh || ALL_OK=false
source minio/check-requirements.sh || ALL_OK=false

title "RESULT"
if $ALL_OK; then
  action_done "Requirements fulfilled"
  exit 0
else
  action_failed "There are missing requirements"
  exit 1
fi