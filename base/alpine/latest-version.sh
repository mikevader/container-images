#!/usr/bin/env bash

channel=3.20 #$1
version=$(curl -s "https://registry.hub.docker.com/v2/repositories/library/alpine/tags?ordering=name&name=$channel" | jq --raw-output --arg s "$channel" '.results[] | select(.name | contains($s)) | .name' | head -n1)
version="${version#*v}"
version="${version#*release-}"
printf "%s" "${version}"
