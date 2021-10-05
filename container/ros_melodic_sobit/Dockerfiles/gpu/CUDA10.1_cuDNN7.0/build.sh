#!/bin/bash
cd ~/docker_ws/container/ros_melodic_sobit_pro/Dockerfiles/gpu/CUDA10.1_cuDNN7.0

docker build \
    --tag sobits/ros_melodic_sobit_pro_gpu_cuda10.1_cudnn7.0 \
    --network host \
    .
