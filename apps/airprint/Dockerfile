FROM ghcr.io/mikevader/ubuntu-jammy:vjammy-20220801

ARG VERSION
USER root

RUN apt update \
    && apt-get install -y apache2 ssl-cert \
    && apt-get -y clean all \
    && mkdir -p /music /cache /app \
    && chown -R lucy:lucy /music /cache /app \
    && rm -rf /var/www/html \
    && ln -s /music /var/www/html

COPY ./apps/airprint/config/musicindex.conf /etc/apache2/conf-enabled/
COPY ./apps/airprint/entrypoint.sh /app/entrypoint.sh
RUN ["chmod", "+x", "/app/entrypoint.sh"]

USER lucy

WORKDIR /music

EXPOSE 80 443

CMD ["/app/entrypoint.sh"]
