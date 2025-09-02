title "CHECK REQUIREMENTS: MINIO"
LOCAL_ALL_OK=true
check_requirement -c mc -u https://docs.min.io/community/minio-object-store/reference/minio-mc.html || LOCAL_ALL_OK=false
if ! $LOCAL_ALL_OK; then
  return 1
fi
