#!/bin/bash
cd ~/docker_ws/container/ros_kinetic_basic_ws/Dockerfiles/cpu

docker build \
    --tag sobits/ros_kinetic_basic_ws \
    --network host \
    --build-arg OAUTH="CVbC1YVoCUN6x-uAQK61" \
    .
