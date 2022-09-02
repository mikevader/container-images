#!/usr/bin/env bash

#shellcheck disable=SC1091
#source "/shim/umask.sh"

export APACHE_RUN_DIR=/app
export APACHE_LOG_DIR=/app
export APACHE_PID_FILE=/tmp/apache.pid
export APACHE_RUN_USER=lucy
export APACHE_RUN_GROUP=lucy

touch /app/access.log
touch /app/error.log

ln -sf /dev/stdout /app/access.log \
ln -sf /dev/stderr /app/error.log

exec apache2 -X
