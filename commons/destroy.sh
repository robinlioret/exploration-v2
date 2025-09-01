#!/bin/bash

source commons/utils.sh

# source keycloak/destroy.sh # TODO: move out of Bitnami

source dns/destroy.sh
source cluster/destroy.sh

title "Done"