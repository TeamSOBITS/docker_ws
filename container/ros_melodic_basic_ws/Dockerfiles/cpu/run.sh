#!/bin/bash
cd ~/docker_ws/container/ros_melodic_basic_ws/

docker run \
    -d \
    -p 6080:80 \
    --device /dev:/dev \
    --mount type=bind,src=$(pwd)/src,dst=/home/sobits/catkin_ws/src \
    --shm-size=512m \
    --name ros_melodic_basic_ws \
    --privileged \
    sobits/ros_melodic_basic_ws
