#!/bin/bash

DIR=$(pwd)
str=`echo ${DIR} | awk -F "/" '{ print $(NF - 3) }'`

cd $(pwd)/../../../

xhost +local:${USER}

docker run -it \
    --gpus all \
    -v /etc/udev/rules.d/:/etc/udev/rules.d/ \
    -v $(pwd)/src/:/home/sobits/colcon_ws/src/ \
    --env CONTAINER_NAME=${str} \
    --shm-size=1g \
    --net host \
    --name ${str} \
    --privileged \
    --user sobits \
    sobits/${str} \
    /bin/bash
