#!/bin/bash
set -e

echo "[Entrypoint] VCL Management Daemon"

# Update VCL Configuration File
sed -i 's/^\(FQDN=\).*/\1'$HOSTNAME'/' /etc/vcl/vcld.conf
sed -i 's/^\(database=\).*/\1'$MYSQL_DATABASE'/' /etc/vcl/vcld.conf
sed -i 's/^\(server=\).*/\1db/' /etc/vcl/vcld.conf
sed -i 's/^\(LockerWrtUser=\).*/\1'$MYSQL_USER'/' /etc/vcl/vcld.conf
sed -i 's/^\(wrtPass=\).*/\1'$MYSQL_PASSWORD'/' /etc/vcl/vcld.conf
echo "[Entrypoint] Configuration File Updated"
cat /etc/vcl/vcld.conf

# Update database
echo "[Entrypoint] Updating management node information in database"
perl -f /configure-vcl-db.pl

# Start VCL Daemon
echo "[Entrypoint] Starting VCL Daemon using $@"
exec "$@"