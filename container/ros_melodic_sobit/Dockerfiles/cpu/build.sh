#!/bin/bash
cd ~/docker_ws/container/ros_melodic_sobit_pro/Dockerfiles/cpu

docker build \
    --tag sobits/ros_melodic_sobit_pro_cpu \
    --network host \
    .
