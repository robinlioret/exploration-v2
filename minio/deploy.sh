title "DEPLOY MINIO"
NAMESPACE="minio"

if kubectl get namespaces | grep -q $NAMESPACE; then
  action_done "Namespace release detected. It seems to be installed already."
  return 0
fi

action "Deploy minio"
render_file "minio/minio.tpl.yaml" | kubectl apply --server-side -f -
kubectl wait --for condition=ready --namespace $NAMESPACE \
  --selector app.kubernetes.io/name=minio \
  --timeout 180s \
  pod
while true; do curl https://minio-api.sandbox.local 2> /dev/null | grep -q 404 || break; sleep 1; done
action_done

action "Create backups bucket"
if [[ -d "$DIR/storage/minio/backups" ]]; then
  action_skip "Already exists"
else
  ALIAS=minio-$(echo "$DOMAIN" | sed 's/\./\-/')
  mc alias set $ALIAS https://minio-api.${DOMAIN} $MINIO_ROOT_USER $MINIO_ROOT_PASSWORD
  mc mb $ALIAS/backups
  action_done
fi