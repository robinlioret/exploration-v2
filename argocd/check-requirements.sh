title "CHECK REQUIREMENTS: ARGOCD"
LOCAL_ALL_OK=true
check_requirement -c argocd -o -u https://argo-cd.readthedocs.io/en/stable/cli_installation/ || LOCAL_ALL_OK=false
if ! $LOCAL_ALL_OK; then
  return 1
fi
