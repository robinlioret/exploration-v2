title "DEPLOY VELERO"
NAMESPACE="velero"

if kubectl get namespaces | grep -q $NAMESPACE; then
  action_done "Namespace release detected. It seems to be installed already."
  return 0
fi

kubectl create namespace ${NAMESPACE}

action "Create Minio credentials secret"
render_file velero/minio-creds.tpl.txt > .temp/velero-minio-creds.txt
kubectl create secret generic --namespace ${NAMESPACE} minio-creds --from-file=creds=.temp/velero-minio-creds.txt
action_done

add_helm_repo vmware-tanzu https://vmware-tanzu.github.io/helm-charts/

action "Deploy Velero"
render_file "velero/velero.values.tpl.yaml" | helm install velero vmware-tanzu/velero --hide-notes --wait --version 10.1.1 \
    --namespace ${NAMESPACE} -f -
action_done