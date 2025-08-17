title "DEPLOY KARGO"
NAMESPACE="argo"
KARGO_NAMESPACE="kargo"

if kubectl get namespaces | grep -q $KARGO_NAMESPACE="kargo"; then
  echo "Namespace release detected. It seems to be installed already."
  return 0
fi

action "Check ArgoCD presence"
if ! kubectl get crds applications.argoproj.io > /dev/null; then
  echo "ArgoCD is not installed!"
  return 1
fi

render_file "kargo/kargo.tpl.yaml" | kubectl apply --server-side -f -
action_done