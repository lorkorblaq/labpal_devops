#!/bin/bash

# Stop all running containers
docker stop $(docker ps -a -q)

# Remove all containers
docker rm $(docker ps -a -q)

# Remove all images
docker rmi $(docker images -a -q)

# Build and push the first image
docker build -t lorkorblaq/clinicalx_api:latest -f ../../clinicalx_api/Dockerfile ../../clinicalx_api
docker push lorkorblaq/clinicalx_api:latest

# Build and push the second image
docker build -t lorkorblaq/clinicalx_main:latest -f ../../clinicalx_main/Dockerfile ../../clinicalx_main
docker push lorkorblaq/clinicalx_main:latest