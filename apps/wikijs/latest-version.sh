#!/usr/bin/env bash

# Pinned to the 2.x line: Wiki.js 3 is a rewrite (Node >= 26, PostgreSQL only,
# new config format) and is not compatible with this image.
version=$(curl -sX GET "https://api.github.com/repos/Requarks/wiki/releases?per_page=100" \
  | jq --raw-output '[.[] | select(.prerelease == false) | .tag_name | select(startswith("v2."))][0]')
version="${version#*v}"
printf "%s" "${version}"
