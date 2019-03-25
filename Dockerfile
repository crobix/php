##
# Loïc AUDU Base container
##

FROM            debian:stable
MAINTAINER  Loïc AUDU <audu382@gmail.com>

ENV         DEBIAN_FRONTEND noninteractive

# Add Source List
COPY    certs/ /root/

COPY    install.sh /root/install.sh
RUN     chmod +x /root/install.sh
RUN     /root/install.sh
