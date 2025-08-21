title "DEPLOY CLUSTER"
if kind get clusters -q | grep -qw "$CLUSTER_NAME"; then
  action_done "The cluster already exists"
  return 0
fi

action "Create cluster $CLUSTER_NAME"
render_file cluster/${CLUSTER_CONFIG}.tpl.yaml | kind create cluster --name "$CLUSTER_NAME" --config=-
action_done

action "Add ca-cert to the nodes"
for node in $(kind get nodes --name "$CLUSTER_NAME"); do
  cat pki/ca.crt | docker exec -i "${node}" cp /dev/stdin "/usr/local/share/ca-certificates/ca.crt"
  docker exec -i "${node}" update-ca-certificates
  docker exec -i "${node}" systemctl restart containerd
done
action_done