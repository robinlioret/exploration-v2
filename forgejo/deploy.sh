title "DEPLOY FORGEJO"
NAMESPACE="forgejo"

if kubectl get namespaces | grep -q $NAMESPACE; then
  action_done "Namespace release detected. It seems to be installed already."
  return 0
fi

render_file "forgejo/forgejo.tpl.yaml" | kubectl apply --server-side -f -
kubectl wait --for condition=ready --namespace $NAMESPACE \
  --selector app.kubernetes.io/name=forgejo \
  --timeout 180s \
  pod
action_done