# kubernetes exploration v2

## Setup

### Requirements

Run `make check-requirements` and install the missing mandatory requirements (kind, kubectl...).

### Set up DNS

Modify your reslov configuration to prioritize the nameserver 127.0.0.1

The actual actions to modify this configuration depends on your OS. Google's your friend.

### Generate PKI

Run `make pki/`, this will create a CA root certificate and its key for the Cert-manager.

- Add the pki/ca.crt to your system trusted CA certificates (depending on your browser, it could automaticaly imports it)
- (If not automated) Add the pki/ca.crt to your browser trusted CA certificates

### Configure environment variables (Optional)

You can create a `.env` file that will overwrite the default variables defined in `commons/variables.sh`.

## Create your exploration cluster

Let's try to create a cluster with a registry and a forgejo:

`make deploy registry forgejo`

If everything is well deployed, you should be able to access forgejo at https://forgejo.sandbox.local (with HTTPS).

## Finding modules

The available modules appears in the commons/deploy.sh script

## Deleting the cluster

`make destroy`

## Note on persistency

Amongst the variables there is `DIR`. This variable defines where, on the disk, the services should store their data (forgejo's repo, keycloak's db, registry's images...). You can clear it at any time (preferably not when the cluster is up) with `make clear-storage` or simply by deleting the `${DIR}/.exploration` directory.

## Usefule documentation

* CA certificate injection using trust-manager and kyverno

https://medium.com/@ugomignon/injecting-certificates-into-kubernetes-workloads-64f00a5496dc