#!/bin/bash
cd ~/docker_ws/container/ros_melodic_sobit_pro/Dockerfiles/gpu/CUDA11.0_cuDNN8.0

docker build \
    --tag sobits/ros_melodic_sobit_pro_gpu_cuda11.0_cudnn8.0 \
    --network host \
    .
