title "DEPLOY ARGOCD"
NAMESPACE="argo"

if kubectl get namespaces | grep -q $NAMESPACE; then
  action_done "Namespace release detected. It seems to be installed already."
  return 0
fi

add_helm_repo argo https://argoproj.github.io/argo-helm

action "Deploy ArgoCD"
render_file "argocd/argocd.values.tpl.yaml" | helm install argocd argo/argo-cd --hide-notes --wait --version 8.0.15 \
    --namespace ${NAMESPACE} --create-namespace -f -
action_done