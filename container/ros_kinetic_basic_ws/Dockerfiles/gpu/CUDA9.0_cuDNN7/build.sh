#!/bin/bash
cd ~/docker_ws/container/ros_kinetic_basic_ws/Dockerfiles/gpu/CUDA9.0_cuDNN7

docker build \
    --tag sobits/ros_kinetic_basic_ws_gpu_cuda9.0_cudnn7 \
    --network host \
    .
