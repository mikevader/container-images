ARG VERSION
FROM ghcr.io/openclaw/openclaw:${VERSION}

USER root
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# hadolint ignore=DL3003,DL3008,DL3013,DL3015,SC2086
RUN \
  apt-get -qq update \
  && \
  apt-get -qq install -y \
    curl \
  && apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false \
  && apt-get autoremove -y \
  && apt-get clean \
  && \
  rm -rf \
    /tmp/* \
    /var/lib/apt/lists/* \
    /var/tmp/

USER node

RUN curl -fsSL https://claude.ai/install.sh | bash
