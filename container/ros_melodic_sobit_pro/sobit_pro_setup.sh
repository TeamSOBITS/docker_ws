#!/bin/bash

cd ~/docker_ws/container/ros_melodic_sobit_pro/src/

# git cloneしたいTeamSOBITSのROSパッケージを記述
ros_packages=( \
    "sobit_pro" \
    "sobit_common" \
)

for ((i = 0; i < ${#ros_packages[@]}; i++)) {
    # echo "array[$i] = ${array[i]}"
    echo "${ros_packages[i]}"
    git clone https://gitlab.com/TeamSOBITS/${ros_packages[i]}.git
}

cd 

# Seting wheel USB
echo "SUBSYSTEM==\"tty\", ATTRS{idVendor}==\"0403\", ATTRS{idProduct}==\"6014\", ATTRS{serial}==\"E148\", SYMLINK+=\"wheel\", MODE=\"0666\"" > /etc/udev/rules.d/wheel.rules
sudo /etc/init.d/udev reload

# Seting arm_pantilt USB
echo "SUBSYSTEM==\"tty\", ATTRS{idVendor}==\"0403\", ATTRS{idProduct}==\"6015\", ATTRS{serial}==\"E143\", SYMLINK+=\"arm_pantilt\", MODE=\"0666\"" > /etc/udev/rules.d/arm_pantilt.rules && \
sudo /etc/init.d/udev reload

# USB Reload
sudo /etc/init.d/udev reload
