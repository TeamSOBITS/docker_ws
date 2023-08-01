#!/bin/bash
# Reference: https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/install-guide.html

echo "╔══╣ Install: NVIDIA Container Toolkit (STARTING) ╠══╗"


# Setup the package repository and the GPG key:
distribution=$(. /etc/os-release;echo $ID$VERSION_ID) \
      && curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg \
      && curl -s -L https://nvidia.github.io/libnvidia-container/$distribution/libnvidia-container.list | \
            sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | \
            sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list


# Install the nvidia-docker2 package (and dependencies)
sudo apt-get update
sudo apt-get install -y nvidia-docker2


# Configure the Docker daemon to recognize the NVIDIA Container Runtime
sudo nvidia-ctk runtime configure --runtime=docker


# Restart the Docker daemon
sudo systemctl restart docker


echo "╚══╣ Install: NVIDIA Container Toolkit (FINISHED) ╠══╝"
