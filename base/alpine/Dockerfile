ARG VERSION
FROM golang:1.24.2-alpine3.20 as builder
ARG TARGETOS
ARG TARGETARCH
ARG TARGETVARIANT=""
ARG TARGETPLATFORM
ENV GO111MODULE=on \
    CGO_ENABLED=0 \
    GOOS=${TARGETOS} \
    GOARCH=${TARGETARCH} \
    GOARM=${TARGETVARIANT}
RUN go install -ldflags="-s -w" github.com/drone/envsubst/cmd/envsubst@latest

# TODO: upx for arm64 not in alpine 3.16
#hadolint ignore=DL3018,DL3059
RUN \
    case "${TARGETPLATFORM}" in \
        'linux/amd64') \
            # 1.9M -> 1.0M
            apk add --no-cache upx \
            && upx --ultra-brute /go/bin/envsubst \
        ;; \
    esac

FROM alpine:${VERSION}
ARG VERSION
ARG CHANNEL
ARG TARGETPLATFORM
ENV TARGETPLATFORM=${TARGETPLATFORM:-linux/amd64}

ENV UMASK="0002" \
    TZ="Etc/UTC"

WORKDIR /app

# hadolint ignore=DL3002
USER root

#hadolint ignore=DL3018
RUN \
    apk add --no-cache \
        ca-certificates \
        bash \
        bind-tools \
        curl \
        iputils \
        jo \
        jq \
        nano \
        pv \
        tini \
        tzdata \
        util-linux

#hadolint ignore=DL3018
RUN \
    addgroup -S lucy --gid 666 \
    && adduser -S lucy -G lucy --uid 666 \
    && \
    mkdir -p /config \
    && chown -R lucy:lucy /config \
    && chmod -R 775 /config \
    && printf "/bin/bash /scripts/greeting.sh\n" > /etc/profile.d/greeting.sh \
    && printf "umask %d" "${UMASK}" > /etc/profile.d/umask.sh \
    && ln -s /usr/bin/vi   /usr/local/bin/vi \
    && ln -s /usr/bin/vi   /usr/local/bin/vim \
    && ln -s /usr/bin/nano /usr/local/bin/nano \
    && ln -s /usr/bin/nano /usr/local/bin/neovim \
    && ln -s /usr/bin/nano /usr/local/bin/emacs \
    && rm -rf /tmp/* \

USER lucy

VOLUME ["/config"]

COPY ./base/alpine/scripts /scripts
COPY --from=builder /go/bin/envsubst /usr/local/bin/envsubst

ENTRYPOINT ["/sbin/tini", "--"]

LABEL \
  org.opencontainers.image.base.name="ghcr.io/mikevader/alpine" \
  org.opencontainers.image.base.version="${VERSION}" \
  org.opencontainers.image.authors="Michael Muehlebach <michael@anduin.ch>" \
  org.opencontainers.image.description="This image is meant to be used as base image for k8s images." \
  org.opencontainers.image.source=https://github.com/mikevader/container-images \
  org.opencontainers.image.licenses='GPL-3.0-or-later'
