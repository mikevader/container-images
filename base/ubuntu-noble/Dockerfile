ARG VERSION

FROM ubuntu:${VERSION}

ARG VERSION
ARG TARGETPLATFORM
ENV TARGETPLATFORM=${TARGETPLATFORM:-linux/amd64}

# DEBIAN_FRONTEND: https://askubuntu.com/questions/972516/debian-frontend-environment-variable
# APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE: http://stackoverflow.com/questions/48162574/ddg#49462622
ENV \
  VERSION="${VERSION}" \
  DEBCONF_NONINTERACTIVE_SEEN=true \
  DEBIAN_FRONTEND="noninteractive" \
  APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=DontWarn \
  UMASK=0002 \
  LANG=en_US.UTF-8

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN \
  useradd lucy \
  --system \
  --uid 666 \
  --user-group \
  --no-create-home

RUN \
  mkdir -p /config \
  && chown -R lucy:lucy /config \
  && chmod -R 775 /config

VOLUME [ "/config" ]

WORKDIR /app

# hadolint ignore=DL3008,DL3015
RUN \
  set -eux \
  && echo 'APT::Install-Recommends "false";' >/etc/apt/apt.conf.d/00recommends \
  && echo 'APT::Install-Suggests "false";' >>/etc/apt/apt.conf.d/00recommends \
  && echo 'APT::Get::Install-Recommends "false";' >>/etc/apt/apt.conf.d/00recommends \
  && echo 'APT::Get::Install-Suggests "false";' >>/etc/apt/apt.conf.d/00recommends \
  && \
  apt-get -qq update \
  && \
  apt-get install -y -no-install-recommends \
    bash \
    ca-certificates \
    curl \
    locales \
    tini \
    tzdata \
    vim-tiny \
  && \
  localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8 \
  && ln -s /usr/bin/vim.tiny /usr/local/bin/vi \
  && ln -s /usr/bin/vim.tiny /usr/local/bin/vim \
  && ln -s /usr/bin/vim.tiny /usr/local/bin/nano \
  && ln -s /usr/bin/vim.tiny /usr/local/bin/emacs \
  && chown -R lucy:lucy /app \
  && \
  printf "/bin/bash /shim/greeting.sh\n" >> /etc/bash.bashrc \
  && apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false \
  && apt-get autoremove -y \
  && apt-get clean \
  && \
  rm -rf \
    /tmp/* \
    /var/lib/apt/lists/* \
    /var/cache/apt/* \
    /var/tmp/*

COPY ./base/ubuntu-noble/shim /shim

USER lucy

ENTRYPOINT [ "/usr/bin/tini", "--" ]

LABEL \
  org.opencontainers.image.base.name="ghcr.io/mikevader/ubuntu-noble" \
  org.opencontainers.image.base.version="${VERSION}" \
  org.opencontainers.image.authors="Michael Muehlebach <michael@anduin.ch>" \
  org.opencontainers.image.description="Some description"
