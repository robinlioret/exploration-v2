title "DESTROY DNS"
action "Destroy container"
if docker ps -a | grep -qw dns; then
  docker rm -fv dns
  action_done
else
  action_skip "No container found."
fi