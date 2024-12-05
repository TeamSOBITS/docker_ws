#!/bin/bash

DIR=$(pwd)
str=`echo ${DIR} | awk -F "/" '{ print $(NF - 2) }'`

cd $(pwd)/../../

xhost +local:${USER}

docker run -it \
    --env CONTAINER_NAME=${str} \
    --env DISPLAY=${DISPLAY} \
    --device /dev/snd \
    --env ALSA_CARD=sofhdadsp \
    --volume /etc/udev/rules.d/:/etc/udev/rules.d/ \
    --volume $(pwd)/src/:/home/sobits/colcon_ws/src/ \
    --shm-size=1g \
    --net host \
    --name ${str} \
    --privileged \
    --user sobits \
    sobits/${str} \
    /bin/bash
