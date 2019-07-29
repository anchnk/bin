#! /usr/bin/env bash

get_dbus_environment() {
  local pid
  local env
  pid="$(pidof -s dbus-daemon)"
  env=$(\
    tr '\0' '\n' < /proc/"$pid"/environ |\
    awk -F'=|,' '/DBUS_SESSION_BUS_ADDRESS/{print $2"="$3}'
  )
  printf "%s" "$env"
}

get_outdated_packages() {
 npm_outdated_json_response="$(npm -g outdated --json)"

 if [ $? -eq 0 ]; then
   echo "All packages are up to date"
 else
   printf "%s" "$(npm -g outdated --json |\
     jq -r 'keys[] as $k | "• \($k) [\(.[$k] | .current) → \(.[$k] | .latest)]"'\
   )"
 fi
}

send_notification() {
  /usr/bin/notify-send                   \
    -i "$HOME/Pictures/Node.js_logo.svg" \
    -t 400                               \
    -u "critical"                        \
    "Node $(node -v)"                    \
    "$(get_outdated_packages)"
}

notify_outdated_packages_for_nvm_runtimes() {
  node_runtimes="$(ls "$HOME"/.nvm/versions/node/)"
  for node_runtime in  ${node_runtimes[0]}
  do
    nvm use "$node_runtime" > /dev/null
    send_notification
  done
}

main() {
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

  DBUS_SESSION_BUS_ADDRESS="$(get_dbus_environment)" \
    notify_outdated_packages_for_nvm_runtimes
}

main
