#!/bin/bash
cd ~/docker_ws/container/ros_kinetic_basic_ws/Dockerfiles/CUI/gpu/CUDA9.0_cuDNN7.6/

docker build \
    --tag sobits/ros_kinetic_basic_ws_cuda9.0_cudnn7.6 \
    --network host \
    .
