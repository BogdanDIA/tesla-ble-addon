#!/bin/ash
. /app/libproduct.sh

exec /usr/sbin/sshd -D -e "$@"
