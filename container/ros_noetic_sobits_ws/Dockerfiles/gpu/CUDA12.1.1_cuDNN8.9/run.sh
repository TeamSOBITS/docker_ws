#!/bin/bash

DIR=$(pwd)
str=`echo ${DIR} | awk -F "/" '{ print $(NF - 3) }'`

cd $(pwd)/../../../

xhost +local:${USER}

docker run -it \
    --gpus all \
    --device /dev/:/dev/ \
    --device=/dev/video0 \
    -v /var/run/dbus/system_bus_socket:/var/run/dbus/system_bus_socket \
    -v /etc/localtime:/etc/localtime \
    -v /etc/udev/rules.d/:/etc/udev/rules.d/ \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -v /tmp/pulseaudio.socket:/tmp/pulseaudio.socket \
    -v /tmp/pulseaudio.client.conf:/tmp/pulseaudio.client.conf \
    -v /dev/input/:/dev/input/ \
    -v /dev/snd/:/dev/snd/ \
    -v $(pwd)/src/:/home/sobits/catkin_ws/src/ \
    --env LOCAL_UID=$(id -u ${USER}) \
    --env LOCAL_GID=$(id -g ${USER}) \
    --env PULSE_SERVER=unix:/tmp/pulseaudio.socket \
    --env PULSE_COOKIE=/tmp/pulseaudio.cookie \
    --env DISPLAY=${DISPLAY} \
    --env QT_X11_NO_MITSHM=1 \
    --env CONTAINER_NAME=${str} \
    --shm-size=512m \
    --net host \
    --name ${str} \
    --privileged \
    --user sobits \
    sobits/${str} \
    /bin/bash


    # --mount type=bind,src=/var/run/dbus/system_bus_socket,dst=/var/run/dbus/system_bus_socket,bind-propagation=shared \
    # --mount type=bind,src=/etc/localtime,dst=/etc/localtime,bind-propagation=shared \
    # --mount type=bind,src=/tmp/.X11-unix,dst=/tmp/.X11-unix,bind-propagation=shared \
    # --mount type=bind,src=/tmp/pulseaudio.socket,dst=/tmp/pulseaudio.socket,bind-propagation=shared \
    # --mount type=bind,src=/tmp/pulseaudio.client.conf,dst=/tmp/pulseaudio.client.conf,bind-propagation=shared \
    # --mount type=bind,src=/dev/input/,dst=/dev/input/,bind-propagation=shared \
    # --mount type=bind,src=/dev/snd/,dst=/dev/snd/,bind-propagation=shared \
    # --mount type=bind,src=$(pwd)/src/,dst=/home/sobits/catkin_ws/src/,bind-propagation=shared \