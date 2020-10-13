#!/bin/bash
cd ~/docker_ws/container/ros_kinetic_basic_ws/Dockerfiles/gpu/CUDA10.0_cuDNN7/

docker build \
<<<<<<< HEAD
    --tag sobits/ros_kinetic_basic_ws_gpu_cuda10.0_cudnn7 \
=======
    --tag sobits/ros_kinetic_basic_ws_gpu_cuda10.0_cudnn7 \
>>>>>>> 50455bb1ee2fb227865cd322164cd0a463b5e308
    --network host \
    .
