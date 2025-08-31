title "CHECK REQUIREMENTS: DNS"
LOCAL_ALL_OK=true
check_requirement -c dig -u "See dig installation for your OS" || LOCAL_ALL_OK=false
if ! $LOCAL_ALL_OK; then
  return 1
fi
