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
  UMASK=0002

RUN \
  adduser lucy \
  --uid 666 \
  --group \
  --system \
  --disabled-password \
  --no-create-home \
  && \
  mkdir -p /config \
  && chown -R lucy:lucy /config \
  && chmod -R 775 /config

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
  apt-get install -y \
    bash \
    ca-certificates \
    curl \
    dnsutils \
    jq \
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

ENV LANG en_US.UTF-8

SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# hadolint ignore=DL3008,DL3015
RUN \
  GO_VERSION=1.18 \
  && export GO_VERSION \
  && GOPATH=/go \
  && export GOPATH \
  && \
  apt-get update -yq \
  && apt-get install -yq \
    gnupg \
    lsb-release \
  && DISTRO="$(lsb_release -s -c)" \
  && export DISTRO \
  && apt-key adv --recv-keys --keyserver keyserver.ubuntu.com 52B59B1571A79DBC054901C0F6BC817356A3D45E \
  && echo "deb http://ppa.launchpad.net/longsleep/golang-backports/ubuntu $DISTRO main" | tee /etc/apt/sources.list.d/gosource.list \
  && echo "deb-src http://ppa.launchpad.net/longsleep/golang-backports/ubuntu $DISTRO main" | tee -a /etc/apt/sources.list.d/gosource.list \
  && apt-get update -yq \
  && apt-get install -yq \
    golang-${GO_VERSION} \
  && \
  /usr/lib/go-${GO_VERSION}/bin/go install github.com/drone/envsubst/cmd/envsubst@latest \
  && mv /go/bin/envsubst /usr/local/bin/envsubst \
  && envsubst --version \
  && \
  apt-key del 52B59B1571A79DBC054901C0F6BC817356A3D45E \
  && \
  apt-get remove -y gnupg golang-${GO_VERSION} lsb-release \
  && apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false \
  && apt-get autoremove -y \
  && apt-get clean \
  && unset GO_VERSION \
  && unset GOPATH \
  && unset DISTRO \
  && \
  rm -rf \
    /go \
    /etc/apt/sources.list.d/gosource.list \
    /tmp/* \
    /var/lib/apt/lists/* \
    /var/cache/apt/* \
    /var/tmp/*

USER lucy

VOLUME [ "/config" ]

COPY ./base/ubuntu-jammy/shim /shim

ENTRYPOINT [ "/usr/bin/tini", "--" ]

LABEL \
  org.opencontainers.image.base.name="ghcr.io/mikevader/ubuntu-jammy" \
  org.opencontainers.image.base.version="${VERSION}" \
  org.opencontainers.image.authors="Michael Muehlebach <michael@anduin.ch>"
