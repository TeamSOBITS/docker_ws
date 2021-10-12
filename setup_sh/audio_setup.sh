# Setting Sound configure
echo "pacmd load-module module-native-protocol-unix socket=/tmp/pulseaudio.socket &> /dev/null" >> ~/.bashrc
echo "#!bin/bash
touch /tmp/pulseaudio.client.conf
echo \"default-server = unix:/tmp/pulseaudio.socket \n 
      # Prevent a server running in the container \n 
      autospawn = no \n 
      daemon-binary = /bin/true \n
      # Prevent the use of shared memory \n
      enable-shm = false\" >> /tmp/pulseaudio.client.conf" | sudo tee /etc/profile.d/sound_setup.sh
sudo bash /etc/profile.d/sound_setup.sh
