ARG BUILD_FROM
FROM ${BUILD_FROM}

# Install dependencies
RUN apk add --no-cache \
    python3 \
    py3-pip \
    mariadb \
    mariadb-client \
    nginx \
    supervisor \
    wget \
    curl \
    git \
    bash \
    openssl \
    libffi \
    libpq \
    nodejs \
    npm

# Set environment variables
ENV SEATABLE_VERSION=3.5.0
ENV SEAFILE_ADMIN_EMAIL=admin@example.com
ENV SEAFILE_ADMIN_PASSWORD=password
ENV DB_HOST=localhost
ENV DB_ROOT_PASSWORD=password

# Set up directories
RUN mkdir -p /opt/seatable /data

# Download and extract Seatable
WORKDIR /opt
RUN wget -O seatable-server.tar.gz https://download.seatable.io/linux-server/seatable-server/${SEATABLE_VERSION}/seatable-server-${SEATABLE_VERSION}.tar.gz && \
    tar -xzf seatable-server.tar.gz && \
    rm seatable-server.tar.gz && \
    mv seatable-server-* seatable

# Copy root filesystem
COPY rootfs /

# Make scripts executable
RUN chmod +x /usr/bin/seatable.sh && \
    chmod +x /etc/services.d/seatable/run && \
    chmod +x /etc/services.d/seatable/finish

WORKDIR /opt/seatable

# Expose ports
EXPOSE 8000

# Set entrypoint
ENTRYPOINT ["/usr/bin/seatable.sh"]