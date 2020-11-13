#!/bin/bash
cd ~/docker_ws/container/ros_melodic_basic_ws/

docker run \
    --detach \
    --publish 6080:80 \
    --device /dev:/dev \
    --mount type=bind,src=$(pwd)/src/,dst=/home/sobits/catkin_ws/src/,bind-propagation=shared \
    --env LOCAL_UID=$(id -u $USER) \
    --env LOCAL_GID=$(id -g $USER) \
    --shm-size=512m \
    --name ros_melodic_vnc \
    --privileged \
    sobits/ros_melodic_vnc
