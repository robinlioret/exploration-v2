title "CHECK REQUIREMENTS: VELERO"
LOCAL_ALL_OK=true
check_requirement -c velero -u https://github.com/vmware-tanzu/velero/releases || LOCAL_ALL_OK=false
if ! $LOCAL_ALL_OK; then
  return 1
fi
