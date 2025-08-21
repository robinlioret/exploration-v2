title "DEPLOY CERT-MANAGER"
if helm list --all-namespaces --all | grep -q "cert-manager"; then
  action_done "Helm release detected. It seems to be installed already."
  return 0
fi

add_helm_repo jetstack https://charts.jetstack.io 

action "Deploy chart"
helm install cert-manager jetstack/cert-manager --version v1.17.2 --hide-notes  --wait \
  --namespace cert-manager --create-namespace \
  --set crds.enabled=true
action_done

action "Deploy cluster CA issuer and secret"
kubectl create secret tls --namespace cert-manager ca-cert \
  --cert=ca/pki/ca.crt \
  --key=ca/pki/private/ca.key
render_file cert-manager/ca-issuer.tpl.yaml | kubectl apply --server-side -f -
action_done