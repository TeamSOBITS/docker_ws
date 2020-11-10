#!/bin/bash
cd ~/docker_ws/container/ros_kinetic_basic_ws/Dockerfiles/VNC-Server/gpu/CUDA10.0_cuDNN7/

docker build \
    --tag sobits/ros_kinetic_basic_ws_gpu_cuda10.0_cudnn7 \
    --network host \
    .
