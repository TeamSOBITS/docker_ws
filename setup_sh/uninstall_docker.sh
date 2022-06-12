#!/bin/bash

# Reference: https://docs.docker.com/engine/install/ubuntu/#uninstall-docker-engine
sudo apt-get purge docker-ce docker-ce-cli containerd.io

sudo rm -rf /var/lib/docker
sudo rm -rf /var/lib/containerd
