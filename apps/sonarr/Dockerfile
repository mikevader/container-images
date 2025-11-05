FROM ghcr.io/mikevader/ubuntu-noble:latest

ARG VERSION
USER root

ENV \
  SONARR__INSTANCE_NAME="Sonarr" \
  SONARR__BRANCH="main" \
  SONARR__PORT="8989" \
  SONARR__LOG_LEVEL="info" \
  SONARR__AUTHENTICATION_METHOD="External" \
  SONARR__AUTHENTICATION_REQUIRED="DisabledForLocalAddresses" \
  SONARR__AUTHENTICATION_TYPE="DisabledForLocalAddresses" \
  SONARR__POSTGRES_PORT="5432"

SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# hadolint ignore=DL3008,DL3015,SC2086
RUN \
  apt-get -qq update \
  && apt-get -qq install -y gnupg \
  && \
  apt-get -qq install -y \
    ca-certificates \
    mono-complete \
    ca-certificates-mono \
    libmediainfo0v5 \
    xmlstarlet \
    gettext \
  && \
  curl -fsSL -o /tmp/sonarr.tar.gz \
    "https://github.com/Sonarr/Sonarr/releases/download/v${VERSION}/Sonarr.${SONARR__BRANCH}.${VERSION}.linux-x64.tar.gz" \
  && tar ixzf /tmp/sonarr.tar.gz -C /app --strip-components 1 \
  && \
  rm -rf \
    /app/Sonarr.Update* \
  && \
  printf "UpdateMethod=docker\nBranch=%s\nPackageVersion=%s\nPackageAuthor=[Team mikevader](https://github.com/mikevader)" "${SONARR__BRANCH}" "${VERSION}" > /app/package_info \
  && \
  gpgconf --kill all \
  && apt-get remove -y gnupg \
  && apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false \
  && apt-get autoremove -y \
  && apt-get clean \
  && \
  rm -rf \
    /tmp/* \
    /var/lib/apt/lists/* \
    /var/cache/apt/* \
    /var/tmp/ \
  && chown -R lucy:lucy /app \
  && chmod -R u=rwX,go=rX /app \
  && printf "umask %d" "${UMASK}" >> /etc/bash.bashrc

USER lucy

EXPOSE ${SONARR__PORT}/tcp

COPY ./apps/sonarr/config.xml.tmpl /app/config.xml.tmpl
COPY ./apps/sonarr/entrypoint.sh /entrypoint.sh
CMD ["/entrypoint.sh"]

LABEL \
  org.opencontainers.image.title="${SONARR__INSTANCE_NAME}" \
  org.opencontainers.image.source="https://github.com/Sonarr/Sonarr" \
  org.opencontainers.image.version="${VERSION}"
