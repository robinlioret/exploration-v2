title "DEPLOY TELEPRESENCE"
NAMESPACE="telepresence"

if kubectl get namespaces | grep -q $NAMESPACE; then
  action_done "Namespace release detected. It seems to be installed already."
  return 0
fi


render_file telepresence/telepresence.values.tpl.yaml | helm install telepresence oci://ghcr.io/telepresenceio/telepresence-oss --hide-notes --wait --version 2.23.6 \
  --namespace $NAMESPACE --create-namespace -f -