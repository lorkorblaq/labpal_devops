#!/bin/bash

# List of servers
servers=("clinicalx_1" "clinicalx_2", 'clinicalx_3')

# Path to the script on the remote servers
script_path="/home/blaq/Desktop/clinicalx/devops/docker_install.sh"

for server in "${servers[@]}"; do
    echo "Running script on $server..."
    ssh $server "bash -s" < "$script_path"
    echo "Script execution completed on $server"
done
