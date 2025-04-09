FROM ghcr.io/mikevader/ubuntu-jammy:rolling@sha256:ded6ddbd020f5221f416692d50100fab3819a9dd55f3444823fbb0b59c01cee2

ARG TARGETPLATFORM
ARG BUILDPLATFORM
ARG VERSION
USER root

ENV \
  PROWLARR__INSTANCE_NAME="Prowlarr" \
  PROWLARR__BRANCH="master" \
  PROWLARR__PORT="9696"

SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# hadolint ignore=DL3008,DL3015
RUN \
  apt-get -qq update \
  && \
  apt-get -qq install -y \
    ca-certificates \
    libicu70 \
    libsqlite3-0 \
    xmlstarlet \
  && \
  case "${TARGETPLATFORM}" in \
    'linux/amd64') export ARCH='x64' ;; \
    'linux/arm64') export ARCH='arm64' ;; \
  esac \
  && \
  curl -fsSL -o /tmp/prowlarr.tar.gz \
    "https://prowlarr.servarr.com/v1/update/${PROWLARR__BRANCH}/updatefile?version=${VERSION}&os=linux&runtime=netcore&arch=${ARCH}" \
  && tar ixzf /tmp/prowlarr.tar.gz -C /app --strip-components 1 \
  && \
  rm -rf \
    /app/Prowlarr.Update* \
  && \
  printf "UpdateMethod=docker\nBranch=%s\nPackageVersion=%s\nPackageAuthor=[Team mikevader](https://github.com/mikevader)" "${PROWLARR__BRANCH}" "${VERSION}" > /app/package_info \
  && \
  apt-get autoremove -y \
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

EXPOSE ${PROWLARR__PORT}/tcp

COPY ./apps/prowlarr/config.xml.tmpl /app/config.xml.tmpl
COPY ./apps/prowlarr/entrypoint.sh /entrypoint.sh
CMD ["/entrypoint.sh"]

LABEL \
  org.opencontainers.image.title="${PROWLARR__INSTANCE_NAME}" \
  org.opencontainers.image.source="https://github.com/Prowlarr/Prowlarr" \
  org.opencontainers.image.version="${VERSION}"
