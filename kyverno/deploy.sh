title "DEPLOY KYVERNO"
NAMESPACE="kyverno"

if kubectl get namespaces | grep -q $NAMESPACE; then
  action_done "Namespace release detected. It seems to be installed already."
  return 0
fi

add_helm_repo kyverno https://kyverno.github.io/kyverno/

action "Deploy Kyverno"
render_file "kyverno/kyverno.values.tpl.yaml" | helm install kyverno kyverno/kyverno --hide-notes --wait --version 3.5.1 \
    --namespace ${NAMESPACE} --create-namespace -f -
action_done

action "Apply CA certs injection policy"
render_file "kyverno/ca-injection-policy.tpl.yaml" | kubectl apply --server-side -f -
action_done