#!/bin/bash
cd ~/docker_ws/container/ros_kinetic_basic_ws/Dockerfiles/VNC-Server/gpu/CUDA8.0_cuDNN5

docker build \
    --tag sobits/ros_kinetic_basic_ws_gpu_cuda8.0_cudnn5 \
    --network host \
    .
