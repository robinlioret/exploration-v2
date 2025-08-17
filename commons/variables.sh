MODULES="$@"
DOMAIN=${DOMAIN:-sandbox.local}
CLUSTER_NAME=${CLUSTER_NAME:-sandbox}
CLUSTER_CONFIG=${CLUSTER_CONFIG:-simple}
DIR=${DIR:-$HOME/.exploration}
IP=${IP:-$(hostname -i | cut -d' ' -f1)}