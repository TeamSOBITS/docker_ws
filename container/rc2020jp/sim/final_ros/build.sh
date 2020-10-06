#!/bin/bash
cd ~/docker_ws/container/rc2020jp/sim/final_ros
sh git_clone_ros_packages.sh

docker build \
    --tag sobits/rc2020jp_sim_final_ros \
    --network host \
    .
