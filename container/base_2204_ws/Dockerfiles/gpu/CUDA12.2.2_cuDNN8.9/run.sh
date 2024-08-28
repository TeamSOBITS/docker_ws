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


    # --mount type=bind,src=/var/run/dbus/system_bus_socket,dst=/var/run/dbus/system_bus_socket,bind-propagation=shared \
    # --mount type=bind,src=/etc/localtime,dst=/etc/localtime,bind-propagation=shared \
    # --mount type=bind,src=/tmp/.X11-unix,dst=/tmp/.X11-unix,bind-propagation=shared \
    # --mount type=bind,src=/tmp/pulseaudio.socket,dst=/tmp/pulseaudio.socket,bind-propagation=shared \
    # --mount type=bind,src=/tmp/pulseaudio.client.conf,dst=/tmp/pulseaudio.client.conf,bind-propagation=shared \
    # --mount type=bind,src=/dev/input/,dst=/dev/input/,bind-propagation=shared \
    # --mount type=bind,src=/dev/snd/,dst=/dev/snd/,bind-propagation=shared \
    # --mount type=bind,src=$(pwd)/src/,dst=/home/sobits/catkin_ws/src/,bind-propagation=shared \