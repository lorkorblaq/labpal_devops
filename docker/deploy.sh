#!/bin/bash

# Stop the Docker containers
echo "Stopping Docker containers..."
docker-compose down

# Pull the latest images
echo "Pulling the latest Docker images..."
docker-compose pull

# Start Docker Compose, rebuilding only if necessary
echo "Starting Docker Compose..."
docker-compose up -d

echo "Deployment completed."
