FROM ghcr.io/mikevader/ubuntu-focal:rolling@sha256:261c2d956ae6454026a669a7ded7917d28fe0528c3563bb6e7e4129404d64571

ARG TARGETPLATFORM
ARG BUILDPLATFORM
ARG VERSION

# Sets Jackett config directory
# https://github.com/Jackett/Jackett#home-directory-1
ENV XDG_CONFIG_HOME=/config

USER root

# hadolint ignore=DL3008,DL3015,SC2086
RUN \
  apt-get -qq update \
  && \
  apt-get -qq install -y \
    libicu66 \
    libssl1.1 \
  && \
  case "${TARGETPLATFORM}" in \
    'linux/amd64') export ARCH='AMDx64' ;; \
    'linux/arm64') export ARCH='ARM64' ;; \
    'linux/arm/v7') export ARCH='ARM32' ;; \
  esac \
  && \
  curl -fsSL -o /tmp/jackett.tar.gz \
    "https://github.com/Jackett/Jackett/releases/download/v${VERSION}/Jackett.Binaries.Linux${ARCH}.tar.gz" \
  && tar ixzf /tmp/jackett.tar.gz -C /app --strip-components 1 \
  && \
  rm -rf \
    /app/JackettUpdater* \
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

EXPOSE 9117

COPY ./apps/jackett/entrypoint.sh /entrypoint.sh
CMD ["/entrypoint.sh"]

LABEL \
  org.opencontainers.image.title="Jackett" \
  org.opencontainers.image.source="https://github.com/Jackett/Jackett" \
  org.opencontainers.image.version="${VERSION}"
