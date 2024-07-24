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
# echo "Image lorkorblaq/labpal_api:latest built and pushed."

# docker build -t lorkorblaq/labpal_nginx:secure -f ../../clinicalx_devops/nginx/Dockerfile ../../clinicalx_devops/nginx/
# docker push lorkorblaq/labpal_nginx:secure


# Build and push the seconds image
# docker build -t lorkorblaq/clinicalx_main:latest -f ../../clinicalx_main/Dockerfile ../../clinicalx_main
# docker push lorkorblaq/clinicalx_main:latest

# docker build -t lorkorblaq/labpal_main:latest -f ../../clinicalx_main/Dockerfile ../../clinicalx_main
# docker push lorkorblaq/labpal_main:latest
# echo "Image lorkorblaq/labpal_main:latest built and pushed."



# Build and push the gpt environment
# docker build -t lorkorblaq/gpt_engine:latest -f ../../labpal_gpt/gptenv/Dockerfile ../../labpal_gpt/gptenv
# docker push lorkorblaq/gpt_engine:latest

docker build -t lorkorblaq/labpal_gpt:latest -f ../../labpal_gpt/Dockerfile ../../labpal_gpt
docker push lorkorblaq/labpal_gpt:latest
echo "Image lorkorblaq/labpal_gpt:latest built and pushed."


# Deploy the updated images
ssh labpal_delta << 'EOF'
echo "Changing directory to labpal/labpal_devops/docker"
cd labpal/labpal_devops/docker || { echo "Failed to change directory"; exit 1; }
echo "Running deploy script"
./deploy.sh || { echo "Deploy script failed"; exit 1; }
echo "Deployment completed successfully."
EOF

echo "Docker build, push, and deploy process completed."