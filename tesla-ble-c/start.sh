#!/bin/ash -e
. /app/libproduct.sh

log_info "Entering main loop..."

exec /usr/sbin/sshd -D -e "$@"

while :; do
  log_info "This is ESP32 HCI Proxy"
  sleep 30
done


