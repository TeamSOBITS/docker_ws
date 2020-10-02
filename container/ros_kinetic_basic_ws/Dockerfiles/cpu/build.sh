#!/bin/bash
cd ~/docker_ws/container/ros_kinetic_basic_ws/Dockerfiles/cpu

docker build \
    --tag ros_kinetic_basic_ws \
    --network host \
    .
