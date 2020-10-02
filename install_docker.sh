#!/bin/bash

echo "=== INSTALL DOCKER ==="

#install dependencies
sudo apt install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common

#get GPG publis key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

#set apt repository
 sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

#install docker-ce
sudo apt update
sudo apt install -y docker-ce

#run as a normal user
sudo usermod -aG docker $USER

echo "=== FINISH ==="
