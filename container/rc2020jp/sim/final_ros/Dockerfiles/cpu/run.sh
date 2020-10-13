#! /bin/bash
cd ~/docker_ws/container/rc2020jp/sim/final_ros/Dockerfiles/cpu/

docker run \
    -p 6080:80 \
    --gpus all \
    --device /dev/dri:/dev/dri \
    --device /dev/video0:/dev/video0:mwr \
    --mount type=bind,src=$(pwd)/src/,dst=/home/sobits/catkin_ws/src/,bind-propagation=shared \
    -e LOCAL_UID=$(id -u $USER) \
    -e LOCAL_GID=$(id -g $USER) \
    --shm-size=512m \
    --name rc2020jp_sim_final_ros_cpu \
    --privileged \
    sobits/rc2020jp_sim_final_ros_cpu
