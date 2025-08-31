title "CHECK REQUIREMENTS: TELEPRESENCE"
LOCAL_ALL_OK=true
check_requirement -c telepresence -o -u https://telepresence.io/docs/quick-start || LOCAL_ALL_OK=false
if ! $LOCAL_ALL_OK; then
  return 1
fi
