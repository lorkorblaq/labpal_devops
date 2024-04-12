#!/bin/bash

# Install Docker on Ubuntu
install_docker_ubuntu() {
    sudo apt-get update
    echo "installing docker"
    sudo apt-get install -y apt-transport-https ca-certificates curl gnupg lsb-release
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt-get update
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io
}
docker_swarm_join_command='docker swarm join --token SWMTKN-1-3rl5zgl9974mqrtyvojlgji2r0z2gmov3f0rx1iplpd4g9tbl3-cgegvls0sapjxul7bjevld0q1 51.20.2.93:2377'


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
install_docker_ubuntu

echo "Joining Docker Swarm..."
sudo $docker_swarm_join_command
sudo chmod 666 /var/run/docker.sock
echo "Docker Swarm join completed"

# Add current user to the docker group
sudo usermod -aG docker $USER

echo "Docker installed successfully"
