set -o errexit

if ! test -f readme.md; then
  echo "The script must be run from the root directory"
  exit 1
fi

display() {
  EMPTY_CHARACTER=" "
  EMPTY_CHARACTER_LEFT=""
  EMPTY_CHARACTER_RIGHT=""
  MAX_WIDTH=$(tput cols)
  CENTER=""
  LEFT=""
  RIGHT=""
  while [[ $# -gt 0 ]]; do
    case $1 in
      --center|-c)
        CENTER=" $2 "
        shift 2
        ;;
      --left|-l)
        LEFT="$2 "
        shift 2
        ;;
      --right|-r)
        RIGHT=" $2"
        shift 2
        ;;
      --empty-character|--char|-e)
        EMPTY_CHARACTER="$2"
        shift 2
        ;;
      --empty-characeter-left|-L)
        EMPTY_CHARACTER_LEFT="$2"
        shift 2
        ;;
      --empty-characeter-right|-R)
        EMPTY_CHARACTER_RIGHT="$2"
        shift 2
        ;;
      --max-width|-w)
        MAX_WIDTH=$2
        shift 2
        ;;
      -*)
        echo "Unknown option $1"
        return 1
        ;;
      *)
        echo "Unknown argument $1"
        return 1
        ;;
    esac
  done

  [[ ${#LEFT} = 1 ]] && LEFT=""
  [[ ${#CENTER} = 1 ]] && CENTER=""
  [[ ${#RIGHT} = 1 ]] && RIGHT=""

  EMPTY_CHARACTER_LEFT=${EMPTY_CHARACTER_LEFT:-$EMPTY_CHARACTER}
  EMPTY_CHARACTER_RIGHT=${EMPTY_CHARACTER_RIGHT:-$EMPTY_CHARACTER}

  LENGTH=$(( ${#LEFT} + ${#CENTER} + ${#RIGHT} ))
  if (( $LENGTH > $MAX_WIDTH )); then
    echo "ERROR: too long"
    return 1
  fi

  # INITIAL COMPUTATIONS
  CENTER_LENGTH=${#CENTER}
  CENTER_LEFT_LENGTH=$(( $CENTER_LENGTH / 2 ))
  CENTER_RIGHT_LENGTH=$(( $CENTER_LENGTH - $CENTER_LEFT_LENGTH ))

  LEFT_LENGTH=${#LEFT}
  LEFT_PADDING=$(( $MAX_WIDTH / 2 ))

  RIGHT_LENGTH=${#RIGHT}
  RIGHT_PADDING=$(( $MAX_WIDTH - $LEFT_PADDING ))

  # ADJUST PADDINGS
  LEFT_PADDING=$(( $LEFT_PADDING - $LEFT_LENGTH - $CENTER_LEFT_LENGTH))
  if (( $LEFT_PADDING < 0 )); then
    RIGHT_PADDING=$(( $RIGHT_PADDING + $LEFT_PADDING ))
  fi

  RIGHT_PADDING=$(( $RIGHT_PADDING - $RIGHT_LENGTH - $CENTER_RIGHT_LENGTH ))
  if (( $RIGHT_PADDING < 0 )); then
    LEFT_PADDING=$(( $LEFT_PADDING + $RIGHT_PADDING ))
  fi

  # FINAL DISPLAY
  (( $LEFT_LENGTH > 0 )) && printf "%s" "$LEFT"
  (( $LEFT_PADDING > 0 )) && printf "$EMPTY_CHARACTER_LEFT%.0s" $(seq 1 $LEFT_PADDING)
  (( $CENTER_LENGTH > 0 )) && printf "%s" "$CENTER"
  (( $RIGHT_PADDING > 0 )) && printf "$EMPTY_CHARACTER_RIGHT%.0s" $(seq 1 $RIGHT_PADDING)
  (( $RIGHT_LENGTH > 0 )) && printf "%s" "$RIGHT"
  printf "\n"
}

GLOBAL_MAX_WIDTH=$(( $(tput cols) - 5 ))

info() {
  display --left "$@" -w $GLOBAL_MAX_WIDTH
}

title() {
  echo ""
  display --center "$1" -e "~" -w $GLOBAL_MAX_WIDTH #-L ">" -R "<"
}

action() {
  display --left "$1" --right "🔷" -e "."  -w $GLOBAL_MAX_WIDTH
}

action_done() {
  display --left "$1" --right "Success ✅" -e "."  -w $GLOBAL_MAX_WIDTH
}

action_failed() {
  display --left "$1" --right "Failed ❌" -e "."  -w $GLOBAL_MAX_WIDTH
}

action_skip() {
  display --left "$1" --right "Skipped ⚪" -e "."  -w $GLOBAL_MAX_WIDTH
}


check_requirement() {
  COMMAND=""
  OPTIONAL=false
  URL=""
  while [[ $# -gt 0 ]]; do
    case $1 in
      --command|-c)
        COMMAND="$2"
        shift 2
        ;;
      --optional|-o)
        OPTIONAL=true
        shift
        ;;
      --install-url|--url|-u)
        URL="$2"
        shift 2
        ;;
      -*)
        echo "Unknown option $1"
        return 1
        ;;
      *)
        echo "Unknown argument $1"
        return 1
        ;;
    esac
  done
  
  which $COMMAND > /dev/null 2>&1 && DETECTED=true || DETECTED=false
  if $DETECTED; then
    display --left "$COMMAND ($URL)" --right "Detected ✅" -e "." -w $GLOBAL_MAX_WIDTH
  else
    if $OPTIONAL; then
      display --left "$COMMAND ($URL)" --right "Optional 🟠" -e "." -w $GLOBAL_MAX_WIDTH
    else
      display --left "$COMMAND ($URL)" --right "Missing ❌" -e "." -w $GLOBAL_MAX_WIDTH
      return 1
    fi
  fi

  return 0
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