#!/bin/bash
cd ~/docker_ws/container/ros_melodic_basic_ws/Dockerfiles/gpu/CUDA11.3_cuDNN8.2

docker build \
    --tag sobits/ros_melodic_basic_ws_gpu_cuda11.3_cudnn8.2 \
    --network host \
    .
