#!/bin/bash

# # Stop all running containers
# docker stop $(docker ps -a -q)

# # Remove all containers
# docker rm $(docker ps -a -q)

# Remove all images
# docker rmi $(docker images -a -q)

# Build and push the first image
# docker build -t lorkorblaq/clinicalx_api:latest -f ../../clinicalx_api/Dockerfile ../../clinicalx_api
# docker push lorkorblaq/labpal_api:latest

# docker build -t lorkorblaq/labpal_api:latest -f ../../clinicalx_api/Dockerfile ../../clinicalx_api
# docker push lorkorblaq/labpal_api:latest

docker build -t lorkorblaq/labpal_nginx:secure -f ../../clinicalx_devops/nginx/Dockerfile ../../clinicalx_devops/nginx/
docker push lorkorblaq/labpal_nginx:secure


# Build and push the seconds image
# docker build -t lorkorblaq/clinicalx_main:latest -f ../../clinicalx_main/Dockerfile ../../clinicalx_main
# docker push lorkorblaq/clinicalx_main:latest

# docker build -t lorkorblaq/labpal_main:latest -f ../../clinicalx_main/Dockerfile ../../clinicalx_main
# docker push lorkorblaq/labpal_main:latest


# Build and push the gpt environment
# docker build -t lorkorblaq/gpt_engine:latest -f ../../labpal_gpt/gptenv/Dockerfile ../../labpal_gpt/gptenv
# docker push lorkorblaq/gpt_engine:latest

# docker build -t lorkorblaq/labpal_gpt:latest -f ../../labpal_gpt/Dockerfile ../../labpal_gpt
# docker push lorkorblaq/labpal_gpt:latest