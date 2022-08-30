FROM ghcr.io/mikevader/ubuntu-jammy:vjammy-20220801

ARG VERSION
USER root

RUN apt update \
    && apt-get install -y apache2 ssl-cert libapache2-mod-musicindex \
    && apt-get -y clean all \
    && mkdir -p /music /cache \
    && chown -R lucy:lucy /music /cache \
    && a2enmod ssl musicindex \
    && a2ensite default-ssl \
    && rm -rf /var/www/html \
    && ln -s /music /var/www/html

USER lucy

COPY ./apps/airprint/config/musicindex.conf /etc/apache2/conf-enabled/
COPY ./apps/airprint/entrypoint.sh /entrypoint.sh

WORKDIR /music

EXPOSE 80 443

CMD ["/entrypoint.sh"]
