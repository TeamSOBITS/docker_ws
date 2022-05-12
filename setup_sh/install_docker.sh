#!/bin/bash
# Reference: https://docs.docker.com/engine/install/ubuntu/

echo "╔══╣ Install: Docker Engine (STARTING) ╠══╗"

# Uninstall old versions
sudo apt-get remove -y \
    docker \
    docker-engine \
    docker.io \
    containerd \
    runc

# Install dependencies
sudo apt-get update
sudo apt install -y \
    apt-transport-https \
    software-properties-common \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

# Add Docker’s official GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# Set up the stable repository
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install the latest version of Docker Engine and containerd
sudo apt-get update
sudo apt-get install -y \
    docker-ce \
    docker-ce-cli \
    containerd.io

# Manage Docker as a non-root user
# Reference: https://docs.docker.com/engine/install/linux-postinstall/
sudo groupdel docker
sudo groupadd docker
sudo usermod -aG docker $USER
sudo su - $USER

# Set up the audio communication
bash audio_setup.sh

# Configure Docker to start on boot
sudo systemctl enable docker.service
sudo systemctl enable containerd.service


echo "╚══╣ Install: Docker Engine (FINISHED) ╠══╝"
echo "Please, reboot your OS"
echo "You can type: 'reboot now'"
