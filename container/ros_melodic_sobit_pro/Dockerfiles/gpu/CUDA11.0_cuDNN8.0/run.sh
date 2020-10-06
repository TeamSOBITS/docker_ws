#! /bin/bash
docker run \
    -d \
    -p 6080:80 \
    --gpus all \
    --device /dev:/dev \
    -v ~/docker_ws/container/ros_melodic_basic_ws/src:/home/sobits/catkin_ws/src \
    --shm-size=512m \
    --name ros_melodic_basic_ws_gpu_cuda11.0_cudnn8.0 \
    --privileged \
    sobits/ros_melodic_basic_ws_gpu_cuda11.0_cudnn8.0
