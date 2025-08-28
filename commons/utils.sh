set -o errexit

if ! test -f readme.md; then
  echo "The script must be run from the root directory"
  exit 1
fi

# title() {
#   echo -e "\n================================"
#   echo -e "$1"
#   echo -e "--------------------------------"
# }

# action() {
#   echo -e "\n>>> $1"
# }

exec 3>&1
# if [[ "$1" == "verbose" ]]; then
#   exec 1>/dev/null 2>&1
# fi

info() {
  echo -e $@ >&3
}

title() {
  info "\n✴️  $1"
}

action() {
  info "\t🔷 $1"
}

action_done() {
  info "\t✅ ${1:-Done}"
}

action_failed() {
  info "\t❌ ${1:-Failed}"
}

action_skip() {
  info "\t⚪ ${1:-Skipped}"
}

add_helm_repo() {
  if helm repo list | grep -q $1; then
    action "Update $1 repo"
    helm repo update $1
  else
    action "Add $1 repo"
    helm repo add $1 $2 --force-update
  fi
  action_done
}

has_flag() {
  if echo "$MODULES" | grep -w -i -q $1; then
    return 0
  else
    return 1
  fi
}

render_file() {
  eval '
arg=$(cat << EOF
'"$(cat $1)"'
EOF
)'
  cat << EOF
$arg
EOF
}

title "INIT"

action "Load variables"
source commons/variables.sh
action_done

action "Load .env file"
test -f .env && source .env
action_done

action "Init .temp directory"
test -d .temp || mkdir .temp
rm -rf .temp/*
action_done