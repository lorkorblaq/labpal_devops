FROM nginx:latest

# Copy SSL certificate and key to the container
COPY ssl/selfsigned.crt /etc/nginx/ssl/selfsigned.crt
COPY ssl/selfsigned.key /etc/nginx/ssl/selfsigned.key

# Set appropriate permissions for the certificate and key files
RUN chmod 600 /etc/nginx/ssl/selfsigned.*

RUN rm /etc/nginx/conf.d/default.conf
# Copy custom Nginx configuration file
COPY clinicalx_nginx.conf /etc/nginx/nginx.conf

