title "DEPLOY CERT-MANAGER"
NAMESPACE=cert-manager

if helm list --all-namespaces --all | grep -q "${NAMESPACE}"; then
  action_done "Helm release detected. It seems to be installed already."
  return 0
fi

add_helm_repo jetstack https://charts.jetstack.io 

action "Deploy chart"
helm install cert-manager jetstack/cert-manager --version v1.17.2 --hide-notes  --wait \
  --namespace ${NAMESPACE} --create-namespace \
  --set crds.enabled=true
action_done

action "Deploy cluster CA issuer and secret"
kubectl create secret tls --namespace ${NAMESPACE} ca-cert \
  --cert=pki/ca.crt \
  --key=pki/private/ca.key
render_file cert-manager/ca-issuer.tpl.yaml | kubectl apply --server-side -f -
action_done

action "Deploy trust-manager"
helm install trust-manager jetstack/trust-manager --version 0.19.0 --hide-notes --wait \
  --namespace ${NAMESPACE} --create-namespace
action_done

action "Deploy CA bundle"
render_file "cert-manager/ca-bundle.tpl.yaml" | kubectl apply --server-side -f -
action_done
