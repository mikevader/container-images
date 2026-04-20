ARG VERSION
FROM golang:1.25 as gog-builder

RUN git clone https://github.com/steipete/gogcli.git && \
  cd gogcli && \
  make


FROM ghcr.io/openclaw/openclaw:${VERSION}

USER root
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Install gogcli
COPY --from=gog-builder /go/gogcli/gog /usr/local/bin/gog

# hadolint ignore=DL3003,DL3008,DL3013,DL3015,SC2086
RUN \
  apt-get -qq update \
  && \
  apt-get -qq install -y \
    curl \
    nano \
    jq \
    yq \
    ripgrep \
    gh \
  && apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false \
  && apt-get autoremove -y \
  && apt-get clean \
  && \
  rm -rf \
    /tmp/* \
    /var/lib/apt/lists/* \
    /var/tmp/

RUN npm install -g @anthropic-ai/claude-code@latest

USER node

