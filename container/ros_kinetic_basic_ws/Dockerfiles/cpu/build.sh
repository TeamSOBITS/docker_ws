#!/bin/bash
cd ~/docker_ws/container/ros_kinetic_basic_ws/Dockerfiles/cpu

docker build \
    --tag sobits/ros_kinetic_cpu \
    --network host \
    --build-arg IMAGE_NAME="sobits/ros_kinetic_cpu" \
    .
