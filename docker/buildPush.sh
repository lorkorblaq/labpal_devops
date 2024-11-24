#!/bin/bash

# # Stop all running containers
# docker stop $(docker ps -a -q)

# # Remove all containers
# docker rm $(docker ps -a -q)

# Remove all images
# docker rmi $(docker images -a -q)


# docker build -t lorkorblaq/labpal_api:latest -f ../../labpal_api/Dockerfile ../../labpal_api
# docker push lorkorblaq/labpal_api:latest
# echo "Image lorkorblaq/labpal_api:latest built and pushed."

# docker build -t lorkorblaq/labpal_nginx:secure -f ../../labpal_devops/nginx/Dockerfile ../../labpal_devops/nginx/
# docker push lorkorblaq/labpal_nginx:secure


# Build and push the seconds image
docker build -t lorkorblaq/labpal_main:latest -f ../../labpal_main/Dockerfile ../../labpal_main
docker push lorkorblaq/labpal_main:latest
echo "Image lorkorblaq/labpal_main:latest built and pushed."

# Build and push the seconds image
# docker build -t public.ecr.aws/a3h1q7q4/labpal/main:latest  -f ../../labpal_main/Dockerfile ../../labpal_main
# docker push public.ecr.aws/a3h1q7q4/labpal/main:latest
# echo "Image lorkorblaq/labpal_main:latest built and pushed."

# Build and push the gpt environment
# docker build -t lorkorblaq/gpt_engine:latest -f ../../labpal_gpt/gptenv/Dockerfile ../../labpal_gpt/gptenv
# docker push lorkorblaq/gpt_engine:latest


# Build and push the gpt image
# docker build -t 058264420881.dkr.ecr.eu-north-1.amazonaws.com/labpal/gpt:latest -f ../../labpal_gpt/Dockerfile ../../labpal_gpt
# docker push 058264420881.dkr.ecr.eu-north-1.amazonaws.com/labpal/gpt:latest
# echo "Image lorkorblaq/labpal_gpt:latest built and pushed."

# docker build -t lorkorblaq/labpal_gpt:latest -f ../../labpal_gpt/Dockerfile ../../labpal_gpt
# docker push lorkorblaq/labpal_gpt:latest
# echo "Image lorkorblaq/labpal_gpt:latest built and pushed."


# Deploy the updated images
ssh labpal_devops << 'EOF'
echo "sshing to devops"
echo "Rebooting the server..."
sudo reboot
EOF

# echo "Docker build, push, and deploy process completed."b 