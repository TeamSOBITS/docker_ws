#! /bin/bash
docker run \
    -p 6080:80 \
    --gpus all \
    --device /dev/dri:/dev/dri \
    --device /dev/video0:/dev/video0:mwr \
    -v ~/docker_ws/container/ros_kinetic_basic_ws/src:/home/sobits/catkin_ws/src \
    --shm-size=512m \
    --name ros_kinetic_basic_ws_gpu_cuda8.0_cudnn5 \
    --privileged \
    sobits/ros_kinetic_basic_ws_gpu_cuda8.0_cudnn5
