#! /bin/bash
docker run \
    -p 6080:80 \
    --gpus all \
    --device /dev/dri:/dev/dri \
    --device /dev/video0:/dev/video0:mwr \
    -v ~/docker_ws/container/rc2020jp_sim_final_ros/src:/home/sobits/catkin_ws/src \
    --shm-size=512m \
    --name rc2020jp_sim_final_ros \
    --privileged \
    sobits/rc2020jp_sim_final_ros
