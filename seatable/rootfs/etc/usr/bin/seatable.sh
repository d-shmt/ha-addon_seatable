#!/usr/bin/env bash
set -e

CONFIG_PATH=/data/options.json

# Get config values
ADMIN_EMAIL=$(jq --raw-output ".admin_email" $CONFIG_PATH)
ADMIN_PASSWORD=$(jq --raw-output ".admin_password" $CONFIG_PATH)
DB_PASSWORD=$(jq --raw-output ".db_password" $CONFIG_PATH)
SECRET_KEY=$(jq --raw-output ".secret_key" $CONFIG_PATH)

# Set environment variables
export SEAFILE_ADMIN_EMAIL=$ADMIN_EMAIL
export SEAFILE_ADMIN_PASSWORD=$ADMIN_PASSWORD
export DB_ROOT_PASSWORD=$DB_PASSWORD

# Generate secret key if not provided
if [ -z "$SECRET_KEY" ]; then
    SECRET_KEY=$(openssl rand -hex 16)
    echo "Generated new SECRET_KEY: $SECRET_KEY"
fi

# Initialize database if first run
if [ ! -d "/data/seatable-data" ]; then
    echo "First run, initializing Seatable..."
    
    # Set up MariaDB
    mkdir -p /data/mariadb-data
    mysql_install_db --user=root --datadir=/data/mariadb-data
    
    # Start MariaDB
    mysqld_safe --datadir=/data/mariadb-data &
    sleep 10
    
    # Setup database
    mysqladmin -u root password "$DB_PASSWORD"
    
    # Initialize Seatable
    cd /opt/seatable
    ./seatable.sh setup \
        --mysql-host=localhost \
        --mysql-port=3306 \
        --mysql-user=root \
        --mysql-password=$DB_PASSWORD \
        --seatable-server-hostname=localhost \
        --admin-email=$ADMIN_EMAIL \
        --admin-password=$ADMIN_PASSWORD \
        --use-existing-db=false
    
    # Copy data to persistent storage
    mkdir -p /data/seatable-data
    cp -r /opt/seatable/* /data/seatable-data/
fi

# Link data directory
rm -rf /opt/seatable
ln -s /data/seatable-data /opt/seatable

# Start services
cd /opt/seatable
./seatable.sh start

# Keep container running
tail -f /opt/seatable/logs/seatable.log