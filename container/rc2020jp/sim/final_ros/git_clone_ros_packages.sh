#!/bin/bash

cd ~/docker_ws/container/rc2020jp_sim_final_ros/src/

#git cloneしたいTeamSOBITSのROSパッケージを記述
ros_packages=( \
    "display_text" \
    "ssd_node" \
)

for ((i = 0; i < ${#ros_packages[@]}; i++)) {
    #echo "array[$i] = ${array[i]}"
    echo "${ros_packages[i]}"
    git clone https://gitlab.com/TeamSOBITS/${ros_packages[i]}.git
}
