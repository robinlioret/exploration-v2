title "DESTROY KEYCLOAK"
NAMESPACE="keycloak"

if kubectl get namespaces | grep -q $NAMESPACE; then
  true
else
  action_done "Namespace release not detected."
  return 0
fi

action "Clean removal"
# kubectl delete namespace ${NAMESPACE}
helm uninstall --namespace ${NAMESPACE} keycloak
action_done