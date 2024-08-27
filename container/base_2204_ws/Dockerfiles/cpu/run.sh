#!/bin/bash

DIR=$(pwd)
str=`echo ${DIR} | awk -F "/" '{ print $(NF - 2) }'`

cd $(pwd)/../../

xhost +local:${USER}

docker run -it \
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

    # -v /run/user/1000/pipewire-0:/tmp/pipewire-0 \
    # -e PIPEWIRE_RUNTIME_DIR=/tmp \
    # --device /dev/snd/ \
    # --env LOCAL_UID=$(id -u ${USER}) \
    # --env LOCAL_GID=$(id -g ${USER}) \
    # --device /dev/:/dev/ \
    # --device=/dev/video0 \
    # -v /var/run/dbus/system_bus_socket:/var/run/dbus/system_bus_socket \
    # -v /etc/localtime:/etc/localtime \
    # -v /tmp/.X11-unix:/tmp/.X11-unix \
    # -v /tmp/pulseaudio.socket:/tmp/pulseaudio.socket \
    # -v /tmp/pulseaudio.client.conf:/tmp/pulseaudio.client.conf \
    # -v /dev/input/:/dev/input/ \
    # -v /dev/snd/:/dev/snd/ \
    # --env PULSE_SERVER=unix:/tmp/pulseaudio.socket \
    # --env PULSE_COOKIE=/tmp/pulseaudio.cookie \
    # --env DISPLAY=${DISPLAY} \
    # --env QT_X11_NO_MITSHM=1 \
