#!/bin/bash

source commons/utils.sh

action "Remove existing files"
rm ca/ca.crt || true
rm ca/ca.key || true
action_done

action "Generate ca.key"
openssl ecparam -name prime256v1 -genkey -noout -out ca/ca.key
action_done

action "Generate ca.crt"
openssl req -new -x509 -sha256 -key ca/ca.key -out ca/ca.crt
action_done