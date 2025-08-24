title "DEPLOY KEYCLOAK"
NAMESPACE="keycloak"
ARGOCD_NAMESPACE="argo"

if kubectl get namespaces | grep -q $NAMESPACE; then
  action_done "Namespace release detected. It seems to be installed already."
  return 0
fi

# FIXME: Keycloak data persistency
action "Deploy Keycloak"
render_file "keycloak/keycloak.tpl.yaml" | kubectl apply --server-side -f -
action_done

# --- Work In Progress
if has_flag argocd ; then
  if [[ -z "$KEYCLOAK_ARGOCD_SECRET" ]]; then
    action_skip "Skip ArgoCD OIDC configuration: missing KEYCLOAK_ARGOCD_SECRET variable.\nCreate a Keycloak client, store the secret in the .env file of this repo with the variable KEYCLOAK_ARGOCD_SECRET. Then redeploy."
  else
    action "Configure OIDC on ArgoCD"

    fname="argocd-secret"
    render_file "keycloak/argocd-patches/${fname}.tpl.yaml" > .temp/${fname}.keycloak.patch.yaml
    kubectl -n $ARGOCD_NAMESPACE patch secret ${fname} --patch-file .temp/${fname}.keycloak.patch.yaml

    fname="argocd-cm"
    render_file "keycloak/argocd-patches/${fname}.tpl.yaml" > .temp/${fname}.keycloak.patch.yaml
    kubectl -n $ARGOCD_NAMESPACE patch configmap ${fname} --patch-file .temp/${fname}.keycloak.patch.yaml

    fname="argocd-rbac-cm"
    render_file "keycloak/argocd-patches/${fname}.tpl.yaml" > .temp/${fname}.keycloak.patch.yaml
    kubectl -n $ARGOCD_NAMESPACE patch configmap ${fname} --patch-file .temp/${fname}.keycloak.patch.yaml

    # kubectl -n $ARGOCD_NAMESPACE patch secret argocd-secret --patch="{\"stringData\": { \"oidc.keycloak.clientSecret\": \"$KEYCLOAK_ARGOCD_SECRET\" }}"
    # kubectl -n $ARGOCD_NAMESPACE patch configmap argocd-cm --patch="{\"data\": {\"oidc.config\": \"name: Keycloak\nissuer: https://keycloak.${DOMAIN}/realms/master\nclientID: argocd\nclientSecret: \$oidc.keycloak.clientSecret\nrequestedScopes: [\\\"openid\\\", \\\"profile\\\", \\\"email\\\", \\\"groups\\\"]\"}}"
    # kubectl -n $ARGOCD_NAMESPACE patch configmap argocd-rbac-cm --patch="{\"data\": {\"policy.csv\": \"g, ArgoCDAdmins, role:admin\"}}"

  fi
fi