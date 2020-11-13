#!/bin/bash
cd ~/docker_ws/container/ros_melodic_basic_ws/Dockerfiles/base/cpu

docker build \
    --tag sobits/ros_melodic_basic_ws \
    --network host \
    .
