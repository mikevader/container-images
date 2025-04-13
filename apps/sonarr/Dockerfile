FROM ghcr.io/mikevader/ubuntu-noble:vnoble-20250127

ARG VERSION
USER root

ENV \
  SONARR__INSTANCE_NAME="Sonarr" \
  SONARR__BRANCH="main" \
  SONARR__PORT="8989"

SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# hadolint ignore=DL3008,DL3015,SC2086
RUN apt-get -qq update \
  && apt-get -qq install -y \
     ca-certificates \
     aspnetcore-runtime-8.0 \
     libmediainfo0v5 \
     xmlstarlet

RUN curl -fsSL -o /tmp/sonarr.tar.gz \
    "https://download.sonarr.tv/v3/${SONARR__BRANCH}/${VERSION}/Sonarr.${SONARR__BRANCH}.${VERSION}.linux.tar.gz" \
  && tar ixzf /tmp/sonarr.tar.gz -C /app --strip-components 1 \
  && \
  rm -rf \
    /app/Sonarr.Update* \
  && \
  printf "UpdateMethod=docker\nBranch=%s\nPackageVersion=%s\nPackageAuthor=[Team mikevader](https://github.com/mikevader)" "${SONARR__BRANCH}" "${VERSION}" > /app/package_info \
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
