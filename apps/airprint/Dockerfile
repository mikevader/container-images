FROM ghcr.io/mikevader/ubuntu-jammy:vjammy-20220815

ENV DEBIAN_FRONTEND noninteractive

USER root

RUN apt-get update && apt-get -y upgrade
RUN apt-get -y install \
      cups-daemon \
      cups-client \
      cups-pdf \
      printer-driver-all \
      openprinting-ppds \
      avahi-daemon \
      libnss-mdns \
# for mkpasswd
      whois \
      curl \
      inotify-tools \
      libpng16-16 \
      python3-cups \
      samba-client \
    && apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /tmp/* \
    && rm -rf /var/tmp/*

# TODO: really needed?
#COPY mime/ /etc/cups/mime/


# setup airprint scripts
COPY ./apps/airprint/airprint/ /opt/airprint/

COPY ./apps/airprint/cups/printers.conf /etc/cups/
COPY ./apps/airprint/ppd /etc/cups/ppd

COPY ./apps/airprint/healthcheck.sh /opt/airprint/
COPY ./apps/airprint/start-cups.sh /opt/airprint/

RUN chmod +x /opt/airprint/healthcheck.sh /opt/airprint/start-cups.sh

# USER lucy

HEALTHCHECK --interval=10s --timeout=3s CMD /opt/airprint/healthcheck.sh

ENV TZ="Europe/Zurich" \
    CUPS_ADMIN_USER="admin" \
    CUPS_ADMIN_PASSWORD="secr3t" \
    CUPS_WEBINTERFACE="yes" \
    CUPS_SHARE_PRINTERS="yes" \
    CUPS_REMOTE_ADMIN="yes" \
    CUPS_ENV_DEBUG="no" \
    # defaults to $(hostname -i)
    CUPS_IP="" \
    CUPS_ACCESS_LOGLEVEL="config" \
    # example: lpadmin -p Epson-RX520 -D 'my RX520' -m 'gutenprint.5.3://escp2-rx620/expert' -v smb://user:pass@host/Epson-RX520"
    CUPS_LPADMIN_PRINTER1=""

ENTRYPOINT ["/opt/airprint/start-cups.sh"]
