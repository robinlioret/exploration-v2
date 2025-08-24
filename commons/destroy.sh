#!/bin/bash

source commons/utils.sh

source keycloak/destroy.sh

source dns/destroy.sh
source cluster/destroy.sh