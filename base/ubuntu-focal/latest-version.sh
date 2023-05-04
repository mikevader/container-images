#!/usr/bin/env bash

version=$(curl -s "https://registry.hub.docker.com/v2/repositories/library/ubuntu/tags?ordering=name&name=focal" | jq --raw-output '.results[] | select(.name | contains("focal")) | .name' | head -n1)
version="${version#*v}"
version="${version#*release-}"
printf "%s" "${version}"
