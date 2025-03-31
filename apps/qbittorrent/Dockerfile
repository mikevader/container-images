FROM ghcr.io/mikevader/ubuntu-noble:vnoble-20250127

ARG TARGETPLATFORM
ARG BUILDPLATFORM
ARG VERSION

ENV BITTORRENT_PORT=6881 \
    WEBUI_PORT=8080

USER root

# hadolint ignore=DL3008,DL3013,DL3015,SC2086
RUN \
  export EXTRA_INSTALL_ARG="binutils"; \
  apt-get -qq update \
  && \
  apt-get install -y \
    geoip-bin \
    p7zip-full \
    python3 \
    unrar \
    unzip \
    ${EXTRA_INSTALL_ARG} \
  && \
  case "${TARGETPLATFORM}" in \
    'linux/amd64') export ARCH="x86_64" ;; \
    'linux/arm64') export ARCH="aarch64" ;; \
  esac \
  && curl -fsSL -o /app/qbittorrent-nox "https://github.com/userdocs/qbittorrent-nox-static/releases/latest/download/${ARCH}-qbittorrent-nox" \
  && chmod +x /app/qbittorrent-nox \
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
  && chown -R lucy:lucy /app \
  && chmod -R u=rwX,go=rX /app \
  && chown -R lucy:lucy /config \
  && chmod -R u=rwX,go=rX /config \
  && printf "umask %d" "${UMASK}" >> /etc/bash.bashrc

USER lucy

EXPOSE ${BITTORRENT_PORT} ${BITTORRENT_PORT}/udp ${WEBUI_PORT}

COPY ./apps/qbittorrent/shim/config.py /shim/config.py
COPY ./apps/qbittorrent/entrypoint.sh /entrypoint.sh

CMD ["/entrypoint.sh"]

LABEL \
  org.opencontainers.image.title="qBittorrent" \
  org.opencontainers.image.source="https://github.com/qbittorrent/qBittorrent" \
  org.opencontainers.image.version="${VERSION}"
