title "DEPLOY HARBOR"
NAMESPACE="harbor"

if kubectl get namespaces | grep -q $NAMESPACE; then
  action_done "Namespace release detected. It seems to be installed already."
  return 0
fi

add_helm_repo harbor https://helm.goharbor.io

action "Deploy Harbor"
render_file "harbor/harbor.values.tpl.yaml" | helm install harbor harbor/harbor --version 1.17.2 \
    --hide-notes --wait --namespace ${NAMESPACE} --create-namespace -f -
action_done