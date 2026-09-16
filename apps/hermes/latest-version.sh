#!/usr/bin/env bash

version="$(curl -sX GET "https://api.github.com/repos/NousResearch/hermes-agent/releases/latest" | jq --raw-output '.tag_name')"
version="${version#*v}"
printf "%s" "${version}"
