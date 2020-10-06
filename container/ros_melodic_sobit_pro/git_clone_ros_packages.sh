#!/bin/bash

cd ~/docker_ws/container/ros_kinetic_basic_ws/src/

#git cloneしたいTeamSOBITSのROSパッケージを記述
ros_packages=( \
    "sobit_common" \
    "web_speech_recognition" \
    "display_text" \
    "text_to_speech" \
    "ssd_node" \
    "sobit_pro" \
)

for ((i = 0; i < ${#ros_packages[@]}; i++)) {
    #echo "array[$i] = ${array[i]}"
    echo "${ros_packages[i]}"
    git clone https://gitlab.com/TeamSOBITS/${ros_packages[i]}.git
}

echo "DynamixelSDK"
git clone https://github.com/ROBOTIS-GIT/DynamixelSDK.git