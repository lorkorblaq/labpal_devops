#!/bin/bash

# Define the setting and value
SETTING="vm.overcommit_memory"
VALUE=1

# Check current setting value
current_value=$(sysctl -n $SETTING)

# If the setting is not configured as desired, update it
if [ "$current_value" -ne "$VALUE" ]; then
  echo "Setting $SETTING to $VALUE"
  
  # Temporarily set the memory overcommit
  sudo sysctl $SETTING=$VALUE
  
  # Permanently set the memory overcommit
  if ! grep -q "^$SETTING=$VALUE" /etc/sysctl.conf; then
    echo "$SETTING=$VALUE" | sudo tee -a /etc/sysctl.conf
  fi
  
  # Apply changes
  sudo sysctl -p
else
  echo "$SETTING is already set to $VALUE"
fi

# # Restart the Redis Docker container
# REDIS_CONTAINER_NAME="redis-server"
# if [ "$(docker ps -q -f name=$REDIS_CONTAINER_NAME)" ]; then
#   echo "Restarting Redis container: $REDIS_CONTAINER_NAME"
#   sudo docker restart $REDIS_CONTAINER_NAME
# else
#   echo "Redis container $REDIS_CONTAINER_NAME is not running."
# fi

echo "Configuration complete."
