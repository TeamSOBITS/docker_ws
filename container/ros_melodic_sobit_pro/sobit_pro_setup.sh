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
echo "SUBSYSTEM==\"tty\", ATTRS{idVendor}==\"0403\", ATTRS{idProduct}==\"6014\", ATTRS{serial}==\"E148\", SYMLINK+=\"wheel\", MODE=\"0666\"" | sudo tee /etc/udev/rules.d/wheel.rules
sudo /etc/init.d/udev reload

# Seting arm_pantilt USB
echo "SUBSYSTEM==\"tty\", ATTRS{idVendor}==\"0403\", ATTRS{idProduct}==\"6015\", ATTRS{serial}==\"E143\", SYMLINK+=\"arm_pantilt\", MODE=\"0666\"" | sudo tee /etc/udev/rules.d/arm_pantilt.rules
sudo /etc/init.d/udev reload

# Seting arm_pantilt USB
#echo "KERNEL==\"uinput\", MODE=\"0666\"
#      KERNEL==\"hidraw*\", SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"054c\", ATTRS{idProduct}==\"05c4\", MODE=\"0666\"
#      KERNEL==\"hidraw*\", SUBSYSTEM==\"hidraw\", KERNELS==\"0005:054C:05C4.*\", MODE=\"0666\"
#      KERNEL==\"hidraw*\", SUBSYSTEM==\"hidraw\", ATTRS{idVendor}==\"054c\", ATTRS{idProduct}==\"09cc\", MODE=\"0666\"
#      KERNEL==\"hidraw*\", SUBSYSTEM==\"hidraw\", KERNELS==\"0005:054C:09CC.*\", MODE=\"0666\"" | sudo tee /etc/udev/rules.d/50-ds4drv.rules
#sudo /etc/init.d/udev reload

sudo udevadm control --reload-rules
sudo udevadm trigger

# USB Reload
sudo /etc/init.d/udev reload
