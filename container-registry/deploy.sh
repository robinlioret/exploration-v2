title "DEPLOY CONTAINER REGISTRY (CR)"
NAMESPACE="container-registry"

if kubectl get namespaces | grep -q $NAMESPACE; then
  action_done "Namespace release detected. It seems to be installed already."
  return 0
fi

action "Deploy the container registry at cr.${DOMAIN}"
render_file "container-registry/container-registry.tpl.yaml" | kubectl apply --server-side -f -
kubectl wait --for condition=ready --namespace $NAMESPACE \
  --selector app.kubernetes.io/name=container-registry \
  --timeout 180s \
  pod
action_done

action "Test container registry"
docker pull alpine:latest
docker tag alpine:latest cr.${DOMAIN}/alpine:latest
docker push cr.${DOMAIN}/alpine:latest
action_done "Docker registry up and running"