#!/bin/bash

source commons/utils.sh

action "Remove existing files"
test -d ca || mkdir ca
rm -rf ca/* || true
action_done

# From https://kubernetes.io/docs/tasks/administer-cluster/certificates/
action "Generate pki and certificate"
cd ca
easyrsa init-pki
easyrsa --batch "--req-cn=${DOMAIN}" build-ca nopass
cd ..
action_done