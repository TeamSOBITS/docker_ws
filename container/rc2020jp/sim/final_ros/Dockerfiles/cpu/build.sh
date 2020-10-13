#!/bin/bash
cd ~/docker_ws/container/rc2020jp/sim/final_ros
bash git_clone_ros_packages.sh

cd ~/docker_ws/container/rc2020jp/sim/final_ros/Dockerfiles/cpu/
docker build \
    --tag sobits/rc2020jp_sim_final_ros_cpu \
    --network host \
    .
