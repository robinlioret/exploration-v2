title "DEPLOY KEYCLOAK"
NAMESPACE="keycloak"

if kubectl get namespaces | grep -q $NAMESPACE; then
  action_done "Namespace release detected. It seems to be installed already."
  return 0
fi

action "Deploy Keycloak"
render_file "keycloak/keycloak.tpl.yaml" | kubectl apply --server-side -f -
action_done