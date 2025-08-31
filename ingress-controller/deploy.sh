title "DEPLOY NGINX INGRESS CONTROLLER"

NAMESPACE="ingress-controller"

if kubectl get namespaces | grep -q $NAMESPACE; then
  action_done "Namespace release detected. It seems to be installed already."
  return 0
fi

action "Deploy nginx ingress controller"
render_file "ingress-controller/ingress-controller.tpl.yaml" | kubectl apply --server-side -f -
kubectl wait --for condition=ready --namespace $NAMESPACE \
  --selector app.kubernetes.io/name=ingress-nginx \
  --selector app.kubernetes.io/component=controller \
  --timeout 180s \
  pod
action_done