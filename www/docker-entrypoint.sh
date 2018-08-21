#!/bin/bash
set -e
echo "[Entrypoint] VCL Website"

# Set secrets
echo "[Entrypoint] Setting up secrets.php"
cp /var/www/html/.ht-inc/secrets-default.php /var/www/html/.ht-inc/secrets.php
sed -i "s/^\(\$vclhost\s=\s\).*/\1\'${MYSQL_HOST//\//\\/}';/" /var/www/html/.ht-inc/secrets.php
sed -i "s/^\(\$vcldb\s=\s\).*/\1\'${MYSQL_DATABASE//\//\\/}';/" /var/www/html/.ht-inc/secrets.php
sed -i "s/^\(\$vclusername\s=\s\).*/\1\'${MYSQL_USER//\//\\/}';/" /var/www/html/.ht-inc/secrets.php
sed -i "s/^\(\$vclpassword\s=\s\).*/\1\'${MYSQL_PASSWORD//\//\\/}';/" /var/www/html/.ht-inc/secrets.php
sed -i "s/^\(\$cryptkey\s=\s\).*/\1\'${VCL_CRYPT_KEY//\//\\/}';/" /var/www/html/.ht-inc/secrets.php
sed -i "s/^\(\$pemkey\s=\s\).*/\1\'${VCL_PEM_KEY//\//\\/}';/" /var/www/html/.ht-inc/secrets.php
echo "[Entrypoint] secrets.php updated"
cat /var/www/html/.ht-inc/secrets.php

# update conf.php
# echo "[Entrypoint] updating conf.php"
# if [ ! -f /etc/vcl-web-conf/conf.php ]; then
#    echo "[Entrypoint] /etc/vcl-web-conf/conf.php does not exists. cannot update /var/www/html/.ht-inc/conf.php"
#else
#    echo "[Entrypoint] /etc/vcl-web-conf/conf.php found updating /var/www/html/.ht-inc/conf.php"
#    ln -svf /etc/vcl-web-conf/conf.php /var/www/html/.ht-inc/conf.php
#fi
#echo "[Entrypoint] conf.php updated"
#cat /var/www/html/.ht-inc/conf.php

# Configure Postfix MTA
echo "[Entrypoint] Updating postfix configuration"
postconf -e inet_interfaces=all
postconf -e relayhost=${SMTP_RELAY_HOST}:${SMTP_RELAY_PORT}

# Run key generation
echo "[Entrypoint] Generating encryption keys"
cd /var/www/html/.ht-inc
./genkeys.sh

# Start HTTPD
echo "[Entrypoint] Starting VCL Website using $@"
exec "$@"
