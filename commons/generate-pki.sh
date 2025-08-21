#!/bin/bash

source commons/utils.sh

# From https://kubernetes.io/docs/tasks/administer-cluster/certificates/
action "Generate pki and certificate"
easyrsa init-pki
easyrsa --batch "--req-cn=${DOMAIN}" build-ca nopass
action_done