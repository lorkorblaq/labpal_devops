#!/bin/bash

# Stop the Docker containers
echo "Stopping Docker containers..."
docker-compose down

# Remove the Docker containers
echo "Removing Docker containers..."
docker rm $(docker ps -a -q)

# Remove the Docker images
echo "Removing Docker images..."
docker rmi lorkorblaq/clinicalx_main:latest
docker rmi lorkorblaq/clinicalx_api:latest
docker rmi lorkorblaq/clinicalx_nginx:latest

# Run Docker Compose to start the services again
echo "Starting Docker Compose..."
docker-compose up -d --build

echo "Deployment completed."
