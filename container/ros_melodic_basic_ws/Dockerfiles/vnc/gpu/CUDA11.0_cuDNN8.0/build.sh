#!/bin/bash
cd ~/docker_ws/container/ros_melodic_basic_ws/Dockerfiles/vnc/gpu/CUDA11.0_cuDNN8.0

docker build \
    --tag sobits/ros_melodic_vnc_gpu_cuda11.0_cudnn8.0 \
    --network host \
    .
