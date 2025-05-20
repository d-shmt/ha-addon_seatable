ARG BUILD_FROM
FROM ${BUILD_FROM}

# Set shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Installation von Abhängigkeiten
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    git \
    python3 \
    python3-pip \
    python3-setuptools \
    jq \
    nginx \
    mariadb-server \
    mariadb-client \
    redis-server \
    wget \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Erstelle notwendige Verzeichnisse
RUN mkdir -p /opt/seatable

# Kopiere Skripte
COPY rootfs /

# Mache Skripte ausführbar
RUN chmod a+x /etc/services.d/seatable/run \
    && chmod a+x /etc/services.d/seatable/finish \
    && chmod a+x /etc/cont-init.d/seatable.sh \
    && chmod a+x /usr/bin/seatable.sh

# Expose Ports
EXPOSE 8080 8443

# Start Script
ENTRYPOINT ["/init"]