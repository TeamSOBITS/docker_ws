#!/bin/bash
cd ~/docker_ws/container/ros_melodic_basic_ws/Dockerfiles/gpu/CUDA11.2_cuDNN8.1

docker build \
    --tag sobits/ros_melodic_basic_ws_gpu_cuda11.2_cudnn8.1 \
    --network host \
    .
