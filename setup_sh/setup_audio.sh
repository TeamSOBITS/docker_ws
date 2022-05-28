#!/bin/bash

echo "╔══╣ Set-Up: Sound Configuration (STARTING) ╠══╗"

# Setting Sound Configuration
echo "pacmd load-module module-native-protocol-unix socket=/tmp/pulseaudio.socket &> /dev/null" >> ~/.bashrc

echo -e '#!bin/bash 
touch /tmp/pulseaudio.client.conf 
echo "default-server = unix:/tmp/pulseaudio.socket
      # Prevent a server running in the container 
      autospawn = no 
      daemon-binary = /bin/true 
      # Prevent the use of shared memory 
      enable-shm = false" >> /tmp/pulseaudio.client.conf' | sudo tee /etc/profile.d/sound_setup.sh

sudo bash /etc/profile.d/sound_setup.sh

echo "╚══╣ Set-Up: Sound Configuration (FINISHED) ╠══╝"
echo "source ~/.bashrc をして下さい"
source ~/.bashrc
