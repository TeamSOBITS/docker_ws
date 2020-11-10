#!/bin/bash
cd ~/docker_ws/container/ros_kinetic_basic_ws/Dockerfiles/VNC-Server/gpu/tmp/

docker build \
    --tag sobits/ros_kinetic_basic_ws_gpu_tmp \
    --network host \
    .
