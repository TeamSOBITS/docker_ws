#! /bin/bash
cd ~/docker_ws/container/ros_kinetic_basic_ws/

docker run \
    -p 6080:80 \
    --gpus all \
    --device /dev/dri:/dev/dri \
    --device /dev/video0:/dev/video0:mwr \
    --mount type=bind,src=$(pwd)/src/,dst=/home/sobits/catkin_ws/src/,bind-propagation=shared \
    -e LOCAL_UID=$(id -u $USER) \
    -e LOCAL_GID=$(id -g $USER) \
    --shm-size=512m \
    --name ros_kinetic_basic_ws_gpu_cuda9.0_cudnn7 \
    --privileged \
    sobits/ros_kinetic_basic_ws_gpu_cuda9.0_cudnn7
