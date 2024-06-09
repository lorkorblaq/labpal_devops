sudo apt-get update
sudo apt-get install certbot python3-certbot-nginx
sudo certbot --nginx -d labpal.com.ng
sudo certbot renew --dry-run
