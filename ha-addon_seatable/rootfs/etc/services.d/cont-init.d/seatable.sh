#!/usr/bin/with-contenv bashio
# ==============================================================================
# Setup Seatable
# ==============================================================================

# Hole Konfigurationsoptionen
ADMIN_EMAIL=$(bashio::config 'admin_email')
ADMIN_PASSWORD=$(bashio::config 'admin_password')
SERVER_DOMAIN=$(bashio::config 'server_domain')
MYSQL_ROOT_PASSWORD=$(bashio::config 'mysql_root_password')

# Prüfe ob Konfiguration abgeschlossen
if bashio::config.is_empty 'admin_password' || bashio::config.is_empty 'mysql_root_password'; then
    bashio::log.fatal "Fehlerhafte Konfiguration: Bitte setze die admin_password und mysql_root_password Option."
    bashio::exit.nok
fi

bashio::log.info "Konfiguriere und starte MariaDB..."
# Starte MariaDB und konfiguriere
service mariadb start
mysql -e "CREATE DATABASE IF NOT EXISTS seatable CHARACTER SET utf8;"
mysql -e "CREATE USER IF NOT EXISTS 'seatable'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';"
mysql -e "GRANT ALL PRIVILEGES ON seatable.* TO 'seatable'@'localhost';"
mysql -e "FLUSH PRIVILEGES;"

bashio::log.info "Starte Redis-Server..."
service redis-server start

# Prüfe ob Seatable bereits installiert ist
if [ ! -d "/opt/seatable/seatable-server" ]; then
    bashio::log.info "Herunterladen und installieren von Seatable..."
    
    # Abrufen der neuesten Seatable Version
    SEATABLE_VERSION=$(curl -s https://api.github.com/repos/seatable/seatable-installer/releases/latest | jq -r '.tag_name')
    
    # Herunterladen und extrahieren von Seatable
    mkdir -p /opt/seatable
    cd /opt/seatable
    wget -O installer.tar.gz "https://github.com/seatable/seatable-installer/archive/${SEATABLE_VERSION}.tar.gz"
    tar -xzf installer.tar.gz
    rm installer.tar.gz
    mv seatable-installer* seatable-installer
    
    # Konfiguriere Seatable
    cd seatable-installer
    
    # Erstelle setup.sh basierend auf Umgebungsvariablen
    cat > setup.sh << EOF
#!/bin/bash
# Server info
SERVER_IP="127.0.0.1"
SERVER_NAME="${SERVER_DOMAIN}"
MYSQL_ROOT_PASSWD="${MYSQL_ROOT_PASSWORD}"
MYSQL_USER_HOST="localhost"
# Admin info
ADMIN_EMAIL="${ADMIN_EMAIL}"
ADMIN_PASSWD="${ADMIN_PASSWORD}"
EOF
    
    # Installiere Seatable
    bash seatable-server-installer.sh auto
fi

bashio::log.info "Seatable wurde konfiguriert und ist bereit."