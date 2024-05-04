#!/bin/bash
# Reference: https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/install-guide.html

echo "╔══╣ Install: NVIDIA Container Toolkit (STARTING) ╠══╗"


# Configure the production repository:
curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg \
  && curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list | \
    sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | \
    sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list



# Install the NVIDIA Container Toolkit packages
sudo apt-get update
sudo apt-get install -y nvidia-container-toolkit


# Configure the container runtime by using the nvidia-ctk command
sudo nvidia-ctk runtime configure --runtime=docker


# Restart the Docker daemon
sudo systemctl restart docker


echo "╚══╣ Install: NVIDIA Container Toolkit (FINISHED) ╠══╝"
