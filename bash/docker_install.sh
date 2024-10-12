#!/bin/bash

# Function to install Docker on Ubuntu
install_docker_ubuntu() {
    sudo apt-get update
    echo "Installing Docker..."
    sudo apt-get install -y apt-transport-https ca-certificates curl gnupg lsb-release
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt-get update
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io
}

# Function to install Docker Compose
install_docker_compose() {
    echo "Installing Docker Compose..."
    local compose_version="2.17.0" # Update this version as needed
    sudo curl -L "https://github.com/docker/compose/releases/download/v${compose_version}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
}

# Function to initialize Docker Swarm
initialize_docker_swarm() {
    echo "Initializing Docker Swarm..."
    local advertise_addr="13.48.14.227" # Replace with your manager's IP address
    sudo docker swarm init --advertise-addr $advertise_addr
}

# Function to setup Docker Swarm (join an existing Swarm)
setup_docker_swarm() {
    echo "Setting up Docker Swarm..."
    # Replace the placeholder with your Docker Swarm join command
    local docker_swarm_join_command='docker swarm join --token SWMTKN-1-3uwnk9sz5z5bqtk8h716cy571rdv93drg0uy0yw8438l1b38qv-autc5oc8t5l3u2qizxs8hjx4o 13.48.14.227:2377'
    sudo $docker_swarm_join_command
}

# Check if lsb_release is available
if ! command -v lsb_release &> /dev/null; then
    echo "lsb_release command not found. Install the lsb-release package."
    exit 1
fi

# Check if running on Ubuntu
if [[ $(lsb_release -si) != "Ubuntu" ]]; then
    echo "This script is intended for Ubuntu only."
    exit 1
fi

# Install Docker on Ubuntu
# install_docker_ubuntu

# Install Docker Compose
# install_docker_compose

# Initialize Docker Swarm (only if this is the manager node)
# initialize_docker_swarm

Setup Docker Swarm (join an existing Swarm)
# setup_docker_swarm

# Add current user to the docker group
# sudo usermod -aG docker $USER

# Update permissions on Docker socket
# sudo chmod 666 /var/run/docker.sock

echo "Docker, Docker Compose, and Docker Swarm setup completed successfully."