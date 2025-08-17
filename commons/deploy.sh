#!/bin/bash

source commons/utils.sh

action "Create temp dir at $DIR"
test -d "$DIR" || mkdir -p "$DIR"
echo "Done"

source dns/deploy.sh
source cluster/deploy.sh
source cert-manager/deploy.sh
source ingress-controller/deploy.sh

has_flag registry && source container-registry/deploy.sh
has_flag forgejo && source forgejo/deploy.sh
has_flag argocd && source argocd/deploy.sh
has_flag kargo && source kargo/deploy.sh
has_flag telepresence && source telepresence/deploy.sh
has_flag keycloak && source keycloak/deploy.sh
