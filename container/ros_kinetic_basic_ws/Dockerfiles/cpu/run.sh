#! /bin/bash
docker run \
    -p 6080:80 \
    --device /dev/dri:/dev/dri \
    --device /dev/video0:/dev/video0:mwr \
    --shm-size=512m \
    --name ros_kinetic_basic_ws \
    --privileged \
    ros_kinetic_basic_ws
