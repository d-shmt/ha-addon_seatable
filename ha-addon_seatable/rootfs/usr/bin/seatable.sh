#!/usr/bin/with-contenv bashio
# ==============================================================================
# Run Seatable
# ==============================================================================

bashio::log.info "Starte Seatable Server..."

# Starte Abhängigkeiten
service mariadb start
service redis-server start

# Starte Seatable
cd /opt/seatable
./seatable.sh start all

# Behalte den Prozess am Leben
tail -f /opt/seatable/logs/seatable.log