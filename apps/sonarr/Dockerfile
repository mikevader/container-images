FROM ghcr.io/mikevader/ubuntu-jammy:rolling@sha256:ded6ddbd020f5221f416692d50100fab3819a9dd55f3444823fbb0b59c01cee2

ARG VERSION
USER root

ENV \
  SONARR__INSTANCE_NAME="Sonarr" \
  SONARR__BRANCH="main" \
  SONARR__PORT="8989"

SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# hadolint ignore=DL3008,DL3015,SC2086
RUN \
  apt-get -qq update \
  && apt-get -qq install -y gnupg \
	&& \
  apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF \
  && echo "deb https://download.mono-project.com/repo/ubuntu stable-focal main" | tee /etc/apt/sources.list.d/mono-official.list \
  && apt-get -qq update \
  && \
  apt-get -qq install -y \
    ca-certificates \
    mono-complete \
    ca-certificates-mono \
    libmediainfo0v5 \
    xmlstarlet \
  && \
  curl -fsSL -o /tmp/sonarr.tar.gz \
    "https://download.sonarr.tv/v3/${SONARR__BRANCH}/${VERSION}/Sonarr.${SONARR__BRANCH}.${VERSION}.linux.tar.gz" \
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
