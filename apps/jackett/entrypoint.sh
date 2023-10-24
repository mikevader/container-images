#!/usr/bin/env bash

#shellcheck disable=SC1091
source "/shim/unmask.sh"
source "/shim/vpn.sh"

exec /app/jackett --NoUpdates ${EXTRA_ARGS}
