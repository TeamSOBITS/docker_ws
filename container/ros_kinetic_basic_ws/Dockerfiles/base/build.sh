#!/bin/bash
cd ~/docker_ws/container/ros_kinetic_basic_ws/Dockerfiles/base

docker build \
    --tag sobits/ros_kinetic_basic_ws \
    --network host \
    .
