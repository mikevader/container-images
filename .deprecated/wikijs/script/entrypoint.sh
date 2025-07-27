#!/usr/bin/bash

#shellcheck disable=SC1091
source "/shim/umask.sh"
source "/shim/vpn.sh"
source "/shim/config.sh"

if [ ! -f "/config/config.yml" ]; then
  envsubst < /config.yml > /config/config.yml
fi

ln -sf /config/config.yml /app/wiki/config.yml

exec /usr/bin/node server ${EXTRA_ARGS}
