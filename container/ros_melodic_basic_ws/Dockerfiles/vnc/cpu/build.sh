#!/bin/bash
cd ~/docker_ws/container/ros_melodic_basic_ws/Dockerfiles/vnc/cpu

docker build \
    --tag sobits/ros_melodic_vnc \
    --network host \
    .
