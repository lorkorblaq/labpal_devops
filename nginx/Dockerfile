FROM nginx:latest

# Create the directory for the SSL certificates if it doesn't exist
RUN mkdir -p /etc/nginx/ssl

# Copy SSL certificate and key to the container
COPY ssl/selfsigned.crt /etc/nginx/ssl/selfsigned.crt
COPY ssl/selfsigned.key /etc/nginx/ssl/selfsigned.key

# Set appropriate permissions for the certificate and key files
RUN chmod 600 /etc/nginx/ssl/selfsigned.*

# Remove the default Nginx configuration file
RUN rm /etc/nginx/conf.d/default.conf

# Copy custom Nginx configuration file
COPY clinicalx_nginx.conf /etc/nginx/nginx.conf
