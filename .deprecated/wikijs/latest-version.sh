#!/usr/bin/env bash

version=$(curl -sX GET "https://api.github.com/repos/Requarks/wiki/releases/latest" | jq --raw-output '.tag_name')
version="${version#*v}"
version="${version#*release-}"
printf "%s" "${version}"
