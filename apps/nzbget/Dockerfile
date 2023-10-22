FROM ghcr.io/mikevader/ubuntu-jammy:rolling@sha256:8330afb7412e42889c87ab55addcb51bc4a6e51a3bb8255b74e6775ad44f177c

ARG VERSION
USER root

# hadolint ignore=DL3008,DL3013,DL3015,SC2086
RUN \
  export EXTRA_INSTALL_ARG="build-essential libxml2-dev libxslt1-dev python3-dev python3-pip"; \
  apt-get -qq update \
  && \
  apt-get -qq install -y \
    p7zip-full \
    python3 \
    unrar \
    unzip \
    wget \
    ${EXTRA_INSTALL_ARG} \
  && \
  pip3 install --no-cache-dir -U \
    apprise \
    chardet \
    pynzbget \
    rarfile \
  && \
  ln -s /usr/bin/python3 /usr/bin/python \
  && \
  curl -fsSL -o /tmp/nzbget.run \
    "https://github.com/nzbget/nzbget/releases/download/v${VERSION}/nzbget-${VERSION}-bin-linux.run" \
  && \
  sh /tmp/nzbget.run --destdir /app \
  && \
  apt-get remove -y ${EXTRA_INSTALL_ARG} \
  && apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false \
  && apt-get autoremove -y \
  && apt-get clean \
  && \
  rm -rf \
    /tmp/* \
    /var/lib/apt/lists/* \
    /var/tmp/ \
  && curl -fsSl -o /app/cacert.pem -L "https://curl.haxx.se/ca/cacert.pem" \
  && chown -R lucy:lucy /app \
  && chmod -R u=rwX,go=rX /app \
  && printf "umask %d" "${UMASK}" >> /etc/bash.bashrc

USER lucy

EXPOSE 6789

COPY ./apps/nzbget/entrypoint.sh /entrypoint.sh
CMD ["/entrypoint.sh"]

LABEL \
  org.opencontainers.image.title="NZBGet" \
  org.opencontainers.image.source="https://github.com/nzbget/nzbget" \
  org.opencontainers.image.version="${VERSION}"
