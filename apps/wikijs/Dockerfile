FROM ghcr.io/mikevader/ubuntu-noble:latest

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
  curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
  apt-get update -qq && \
  apt-get install -qq --no-install-recommends \
    gcc \
    g++ \
    make \
    nodejs \
    python3 && \
  echo "**** download wiki.js ****" && \
  mkdir -p /app/wiki /data && \
  curl -fsSLo \
    /tmp/wiki.tar.gz \
    "https://github.com/Requarks/wiki/releases/download/v${VERSION}/wiki-js.tar.gz" && \
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
    make && \
  apt-get purge -qq --auto-remove -o APT::AutoRemove::RecommendsImportant=false && \
  apt-get autoremove -qq && \
  apt-get clean -qq && \
  rm -rf /tmp/*

# ports and volumes
EXPOSE 3000
USER lucy
WORKDIR /app/wiki
CMD [ "/entrypoint.sh" ]
