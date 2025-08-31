title "DESTROY CLUSTER"
action "Destroy cluster"
if kind get clusters -q | grep -qw "$CLUSTER_NAME"; then
  kind delete cluster --name "$CLUSTER_NAME"
  action_done
else
  action_skip "Cluster not found."  
fi