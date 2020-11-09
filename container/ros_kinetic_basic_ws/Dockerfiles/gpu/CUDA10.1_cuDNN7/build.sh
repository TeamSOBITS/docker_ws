#!/bin/bash
cd ~/docker_ws/container/ros_kinetic_basic_ws/Dockerfiles/gpu/CUDA10.1_cuDNN7/

docker build \
    --tag sobits/ros_kinetic_basic_ws_gpu_cuda10.1_cudnn7 \
    --network host \
    .
