#!/bin/bash

source commons/utils.sh

action "Create temp dir at $DIR"
test -d "$DIR" || mkdir -p "$DIR"
echo "Done"

# --- Main modules
source dns/deploy.sh
source cluster/deploy.sh
source cert-manager/deploy.sh
source kyverno/deploy.sh
source ingress-controller/deploy.sh

# --- Optional modules
# Waves provides a very very basic dependency management
# Wave 1
has_flag registry && source container-registry/deploy.sh
has_flag forgejo && source forgejo/deploy.sh
has_flag argocd && source argocd/deploy.sh
has_flag telepresence && source telepresence/deploy.sh

# Wave 2
has_flag kargo && source kargo/deploy.sh

# Wave 3

# Wave 4

# Wave 5
has_flag keycloak && source keycloak/deploy.sh