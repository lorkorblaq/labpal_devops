#!/bin/bash

# Update system and install certbot
sudo apt-get update
sudo apt-get install -y certbot python3-certbot-nginx

# Make sure Nginx is running
sudo systemctl start nginx
sudo systemctl enable nginx

# Define domain and email
DOMAIN="labpal.com.ng"
EMAIL="f3mioloko@gmail.com"

# Run Certbot using the Nginx plugin to obtain/renew certificate
sudo certbot --nginx -d $DOMAIN -d www.$DOMAIN --non-interactive --agree-tos --email $EMAIL --force-renewal >> /var/log/certbot-renew.log 2>&1

# Check if Certbot was successful
if [ $? -eq 0 ]; then
  echo "Certbot renewal for $DOMAIN completed on $(date)" >> /var/log/certbot-renew.log
else
  echo "Failed renewing certificate for $DOMAIN on $(date)" >> /var/log/certbot-renew.log
  exit 1
fi

# Add the cron job for automatic renewal (if not already added)
CRON_JOB="0 3 * * * certbot renew --quiet >> /var/log/certbot-renew.log 2>&1"

# Check if the cron job already exists
(crontab -l 2>/dev/null | grep -F "$CRON_JOB") || (echo "$CRON_JOB" | crontab -)

echo "Cron job for Certbot renewal has been set."