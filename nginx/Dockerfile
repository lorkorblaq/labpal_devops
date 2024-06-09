FROM nginx:latest

# Create the directory for the SSL certificates if it doesn't exist
RUN mkdir -p /etc/nginx/ssl

# Remove the default Nginx configuration file
RUN rm /etc/nginx/conf.d/default.conf

# Copy custom Nginx configuration file
COPY clinicalx_nginx.conf /etc/nginx/nginx.conf