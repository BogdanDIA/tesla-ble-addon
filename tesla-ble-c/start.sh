#!/bin/ash -e
. /app/libproduct.sh

log_info "Entering main loop..."
log_info "Copying SSH public key from $SSH_PUBLIC_KEY"

if [[ -f $SSH_PUBLIC_KEY ]]; then
  RESULT="$(cat /share/storage/root_ssh.pub > /root/.ssh/authorized_keys)"
  STAT=$?
  if [ $STAT -eq 0 ]; then
    log_info "Copying SSH key success"
  else
    log_error "Copying SSH pub key failed: RESULT: $RESULT, STAT: $?"
  fi
else
  log_error "No SSH public key file was found"
fi

exec /usr/sbin/sshd -D -e "$@"

while :; do
  log_info "This is tesla-ble loop. Should not reach here"
  sleep 30
done

