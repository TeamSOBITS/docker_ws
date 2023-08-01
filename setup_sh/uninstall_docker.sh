#!/bin/bash
# Reference: https://docs.docker.com/engine/install/ubuntu/#uninstall-docker-engine

echo "╔══╣ Set-Up: Uninstall Docker (STARTING) ╠══╗"


# Uninstall old Docker version
sudo apt-get purge -y \
    docker-ce \
    docker-ce-cli \
    containerd.io \
    docker-buildx-plugin \
    docker-compose-plugin \
    docker-ce-rootless-extras

sudo apt-get remove -y \
    docker.io \
    docker-doc \
    docker-compose \
    podman-docker \
    containerd \
    runc

sudo rm -rf /var/lib/docker
sudo rm -rf /var/lib/containerd


echo "╚══╣ Set-Up: Uninstall Docker (FINISHED) ╠══╝"