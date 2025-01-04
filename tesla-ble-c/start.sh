#!/bin/ash -e
. /app/libproduct.sh

log_info "Entering main loop..."

exec /usr/sbin/sshd -D -e "$@"

while :; do
  log_info "This is tesla-ble loop. Should not reach here"
  sleep 30
done


