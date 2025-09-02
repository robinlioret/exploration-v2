MODULES="$@"
DOMAIN="sandbox.local"
CLUSTER_NAME="sandbox"
CLUSTER_CONFIG="simple"
DIR="$HOME/.exploration"
IP=$(hostname -i | cut -d' ' -f1)
DNS_PORT="53"