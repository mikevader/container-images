FROM ghcr.io/mikevader/ubuntu-focal:rolling@sha256:aab8157ff945ef41426270cce8b1edb599d45ae812e918f9197d1746157f14b5

### Based on https://github.com/linuxserver/docker-wikijs
# Give ourselves root for a bit
USER root

# set version label
ARG VERSION

COPY ./apps/wikijs/script/ /

# environment settings
ENV HOME="/config"
ENV NODE_ENV="production"

# install supporting software
RUN \
  echo "**** install build packages ****" && \
  curl -sL https://deb.nodesource.com/setup_14.x | bash - && \
  apt-get update -qq && \
  apt-get install -qq --no-install-recommends \
    gcc \
    g++ \
    make \
    nodejs \
    python && \
  echo "**** download wiki.js ****" && \
  mkdir -p /app/wiki /data && \
  if [ -z ${WIKIJS_RELEASE} ]; then \
    WIKIJS_RELEASE=$(curl -sNX GET "https://api.github.com/repos/Requarks/wiki/releases/latest" \
    | awk '/tag_name/{print $4;exit}' FS='[""]'); \
  fi && \
  curl -No \
    /tmp/wiki.tar.gz -L \
    "https://github.com/Requarks/wiki/releases/download/${WIKIJS_RELEASE}/wiki-js.tar.gz" && \
  echo "**** install wiki.js ****" && \
  tar xf \
    /tmp/wiki.tar.gz \
    -C \
    /app/wiki/ && \
  cd /app/wiki && \
  npm rebuild sqlite3 && \
  echo "**** build caches and mangle permissions ****" && \
  chown -R lucy:lucy /data /app/wiki && \
  chmod +x /entrypoint.sh && chown root:root -R /app/wiki/node_modules && \
  echo "**** cleanup ****" && \
  apt-get remove -qq \
    gcc \
    g++ \
    make \
    python && \
  apt-get purge -qq --auto-remove -o APT::AutoRemove::RecommendsImportant=false && \
  apt-get autoremove -qq && \
  apt-get clean -qq && \
  rm -rf /tmp/*

# ports and volumes
EXPOSE 3000
USER lucy
WORKDIR /app/wiki
CMD [ "/entrypoint.sh" ]
