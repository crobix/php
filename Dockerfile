##
# Loïc AUDU PHP 7.1 container
##

FROM           crobix/php:base
MAINTAINER  Loïc AUDU <audu382@gmail.com>

ENV         DEBIAN_FRONTEND noninteractive

COPY    certs/ /root/
COPY    install.sh /root/install.sh
RUN     chmod +x /root/install.sh
RUN     /root/install.sh

COPY            bin/fixright /
RUN             chmod +x /fixright

VOLUME      /sources

WORKDIR     /sources

