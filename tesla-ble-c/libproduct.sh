#
# Home Assistant Add-On product's library
#
function initConfigVariables() {

  ### Required Configuration Settings
  export CAR_VIN="$(bashio::config 'car_vin')"
  export CAR_PRIVATE_KEY="$(bashio::config 'car_private_key')"
  export BLE_HCI_NUM="$(bashio::config 'ble_hci_num')"
  export BLE_COMMAND_TIMEOUT="$(bashio::config 'ble_command_timeout')"
  export BLE_CONNECT_TIMEOUT="$(bashio::config 'ble_connect_timeout')"
  export SSH_PUBLIC_KEY="$(bashio::config 'ssh_public_key')"

  ### Optional Configuration Settings
  if bashio::config.exists 'debug'; then
    export DEBUG="$(bashio::config 'debug')"
    if [ $DEBUG == "true" ]; then
      bashio::log.level debug
    fi
  else
    export DEBUG=""
  fi

  # Prevent bashio to complain for "unbound variable"
  export WHAT_VAR=""
}

#
# Definition functions to call bashio::log
#
function log_debug() {
  bashio::log.debug "$1"
}
function log_info() {
  bashio::log.info "$1"
}
function log_notice() {
  bashio::log.notice "$1"
}
function log_warning() {
  bashio::log.warning "$1"
}
function log_error() {
  bashio::log.error "$1"
}
function log_fatal() {
  bashio::log.fatal "$1"
}


#
# initProduct
#
initConfigVariables
