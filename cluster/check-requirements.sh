title "CHECK REQUIREMENTS: CLUSTER"
LOCAL_ALL_OK=true
check_requirement -c kind -u "https://kind.sigs.k8s.io/docs/user/quick-start/" || LOCAL_ALL_OK=false
if ! $LOCAL_ALL_OK; then
  return 1
fi
