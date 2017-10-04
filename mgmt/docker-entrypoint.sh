#!/bin/bash
set -e

echo "[Entrypoint] VCL Management Daemon"

# Update VCL Configuration File
sed -i 's/FQDN=*$/FQDN='$HOSTNAME'/' /etc/vcl/vcld.conf
sed -i 's/database=*$/database='$MYSQL_DATABASE'/' /etc/vcl/vcld.conf
sed -i 's/server=*$/server=db/' /etc/vcl/vcld.conf
sed -i 's/LockerWrtUser=*$/LockerWrtUser='$MYSQL_USER'/' /etc/vcl/vcld.conf
sed -i 's/wrtPass=*$/wrtPass='$MYSQL_PASSWORD'/' /etc/vcl/vcld.conf
echo "[Entrypoint] Configuration File Updated"
cat /etc/vcl/vcld.conf

# Update database


# Start VCL Daemon
echo "[Entrypoint] Starting VCL Daemon using $@"
exec "$@"