FROM ghcr.io/mikevader/ubuntu-jammy:rolling@sha256:ded6ddbd020f5221f416692d50100fab3819a9dd55f3444823fbb0b59c01cee2

ARG VERSION
USER root
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# hadolint ignore=DL3003,DL3008,DL3013,DL3015,SC2086
RUN \
  export EXTRA_INSTALL_ARG="build-essential libffi-dev libssl-dev python3-dev python3-pip"; \
  apt-get -qq update \
  && \
  apt-get -qq install -y \
    p7zip-full \
    par2 \
    python3 \
    python3-distutils \
    python3-pkg-resources \
    unrar \
    unzip \
    ${EXTRA_INSTALL_ARG} \
  && \
  ln -s /usr/bin/python3 /usr/bin/python \
  && \
  curl -fsSL "https://github.com/sabnzbd/sabnzbd/releases/download/${VERSION}/SABnzbd-${VERSION}-src.tar.gz" | tar xzf - -C /app --strip-components=1 \
  && \
  pip3 install --no-cache-dir -U -r /app/requirements.txt \
  && \
  NZBNOTIFY_VERSION=$(curl -fsSL "https://api.github.com/repos/caronc/nzb-notify/releases/latest" | jq --raw-output '.tag_name') \
  && \
  mkdir -p /app/nzbnotify \
  && \
  curl -fsSL -o /tmp/nzbnotify.tar.gz \
    "https://api.github.com/repos/caronc/nzb-notify/tarball/${NZBNOTIFY_VERSION}" \
  && \
  tar xf \
    /tmp/nzbnotify.tar.gz -C \
    /app/nzbnotify --strip-components=1\
  && \
  cd /app/nzbnotify \
  && \
  pip3 install --no-cache-dir -U -r requirements.txt \
  && apt-get remove -y ${EXTRA_INSTALL_ARG} \
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
  && printf "umask %d" "${UMASK}" >> /etc/bash.bashrc

USER lucy

EXPOSE 8080

COPY ./apps/sabnzbd/sabnzbd.ini /app/sabnzbd.ini

COPY ./apps/sabnzbd/entrypoint.sh /entrypoint.sh
CMD ["/entrypoint.sh"]

LABEL \
  org.opencontainers.image.title="SABnzbd" \
  org.opencontainers.image.source="https://github.com/sabnzbd/sabnzbd" \
  org.opencontainers.image.version="${VERSION}"
