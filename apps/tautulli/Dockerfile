FROM ghcr.io/mikevader/ubuntu-jammy:rolling@sha256:b7fc0e5763b4246938c4f276fa0f4c93a0618ffb48565fce2a6f87a747a40e8c

ARG VERSION
USER root
ENV TAUTULLI_DOCKER="True"

# hadolint ignore=DL3008,DL3013,DL3015,SC2086
RUN \
  export EXTRA_INSTALL_ARG="build-essential libssl-dev libffi-dev python3-dev python3-pip"; \
  apt-get -qq update \
  && \
  apt-get -qq install -y \
    python3 \
    python3-setuptools \
    ${EXTRA_INSTALL_ARG} \
  && \
  ln -s /usr/bin/python3 /usr/bin/python \
  && \
  curl -fsSL "https://github.com/Tautulli/Tautulli/archive/v${VERSION}.tar.gz" | tar xzf - -C /app --strip-components 1 \
  && \
  echo "${VERSION}" > /app/version.txt \
  && \
  echo "master" > /app/branch.txt \
  && \
  pip3 install --no-cache-dir -U \
	  plexapi \
    pycryptodomex \
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
  && printf "umask %d" "${UMASK}" >> /etc/bash.bashrc

USER lucy

EXPOSE 8181

COPY ./apps/tautulli/entrypoint.sh /entrypoint.sh
CMD ["/entrypoint.sh"]

LABEL \
  org.opencontainers.image.title="Tautulli" \
  org.opencontainers.image.source="https://github.com/Tautulli/Tautulli" \
  org.opencontainers.image.version="${VERSION}"
