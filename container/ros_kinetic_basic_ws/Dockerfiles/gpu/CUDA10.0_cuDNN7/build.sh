#!/bin/bash
cd ~/docker_ws/container/ros_kinetic_basic_ws/Dockerfiles/gpu/CUDA10.0_cuDNN7/

docker build \
    --tag sobits/ros_kinetic_basic_ws_gpu_CUDA10.0_cuDNN7 \
    --network host \
    .
