#!/bin/bash
cd ~/docker_ws/container/ros_kinetic_basic_ws/Dockerfiles/gpu/CUDA8.0_cuDNN6

docker build \
    --tag sobits/ros_kinetic_basic_ws_gpu_cuda8.0_cudnn6 \
    --network host \
    .