#!/bin/bash
cd ~/docker_ws/container/ros_kinetic_basic_ws/Dockerfiles/CUI/cpu

docker build \
    --tag sobits/ros_kinetic_basic_ws_cui \
    --network host \
    .
