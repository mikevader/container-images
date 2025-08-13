FROM ghcr.io/mikevader/ubuntu-jammy:rolling@sha256:846b3e64f6000e8761acfbc5915fdc884eaade09880042291a0d7930ec87aa1f

ARG TARGETPLATFORM
ARG BUILDPLATFORM
ARG VERSION
USER root

ENV \
  RADARR__INSTANCE_NAME="Radarr" \
  RADARR__BRANCH="master" \
  RADARR__PORT="7878"

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
  curl -fsSL -o /tmp/radarr.tar.gz \
    "https://radarr.servarr.com/v1/update/${RADARR__BRANCH}/updatefile?version=${VERSION}&os=linux&runtime=netcore&arch=${ARCH}" \
  && tar ixzf /tmp/radarr.tar.gz -C /app --strip-components 1 \
  && \
  rm -rf \
    /app/Radarr.Update* \
  && \
  printf "UpdateMethod=docker\nBranch=%s\nPackageVersion=%s\nPackageAuthor=[Team mikevader](https://github.com/mikevader)" "${RADARR__BRANCH}" "${VERSION}" > /app/package_info \
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

EXPOSE ${RADARR__PORT}/tcp

COPY ./apps/radarr/config.xml.tmpl /app/config.xml.tmpl
COPY ./apps/radarr/entrypoint.sh /entrypoint.sh
CMD ["/entrypoint.sh"]

LABEL \
  org.opencontainers.image.title="${RADARR__INSTANCE_NAME}" \
  org.opencontainers.image.source="https://github.com/Radarr/Radarr" \
  org.opencontainers.image.version="${VERSION}"
