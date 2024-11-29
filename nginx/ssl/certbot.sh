#!/bin/bash

# Update system and install certbot
sudo apt-get update
sudo apt-get install -y certbot

# Make sure Docker volume directory exists
WEBROOT_DIR="/var/lib/docker/volumes/letsencrypt_data/_data"
DOMAIN="labpal.com.ng"
EMAIL="f3mioloko@gmail.com"

# Run Certbot to obtain/renew certificate
certbot certonly \
  --webroot -w $WEBROOT_DIR \
  -d $DOMAIN -d www.$DOMAIN \
  --non-interactive \
  --agree-tos \
  --email $EMAIL \
  --force-renewal \
  >> /var/log/certbot-renew.log 2>&1

# Check if Certbot was successful
if [ $? -eq 0 ]; then
  echo "Certbot renewal for $DOMAIN completed on $(date)" >> /var/log/certbot-renew.log
else
  echo "Failed renewing certificate for $DOMAIN on $(date)" >> /var/log/certbot-renew.log
  exit 1
fi

# Add the cron job for automatic renewal (if not already added)
CRON_JOB="0 3 * * * certbot renew --webroot -w $WEBROOT_DIR --quiet >> /var/log/certbot-renew.log 2>&1"

# Check if the cron job already exists
(crontab -l 2>/dev/null | grep -F "$CRON_JOB") || (echo "$CRON_JOB" | crontab -)

echo "Cron job for Certbot renewal has been set."
