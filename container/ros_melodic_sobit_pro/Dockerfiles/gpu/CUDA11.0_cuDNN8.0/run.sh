#! /bin/bash
cd ~/docker_ws/container/ros_melodic_sobit_pro/

xhost +local:$USER

docker run -it \
    --gpus all \
    --device /dev/:/dev/ \
    --mount type=bind,src=/var/run/dbus/system_bus_socket,dst=/var/run/dbus/system_bus_socket,bind-propagation=shared \
    --mount type=bind,src=/etc/localtime,dst=/etc/localtime,bind-propagation=shared \
    --mount type=bind,src=/tmp/.X11-unix,dst=/tmp/.X11-unix,bind-propagation=shared \
    --mount type=bind,src=/tmp/pulseaudio.socket,dst=/tmp/pulseaudio.socket,bind-propagation=shared \
    --mount type=bind,src=/tmp/pulseaudio.client.conf,dst=/tmp/pulseaudio.client.conf,bind-propagation=shared \
    --mount type=bind,src=/dev/input/,dst=/dev/input/,bind-propagation=shared \
    --mount type=bind,src=/dev/snd/,dst=/dev/snd/,bind-propagation=shared \
    --mount type=bind,src=$(pwd)/src/,dst=/home/sobits/catkin_ws/src/,bind-propagation=shared \
    --env LOCAL_UID=$(id -u $USER) \
    --env LOCAL_GID=$(id -g $USER) \
    --env PULSE_SERVER=unix:/tmp/pulseaudio.socket \
    --env PULSE_COOKIE=/tmp/pulseaudio.cookie \
    --env DISPLAY=$DISPLAY \
    --env QT_X11_NO_MITSHM=1 \
    --env CONTAINER_NAME="ros_melodic_sobit_pro_gpu" \
    --shm-size=512m \
    --net host \
    --name ros_melodic_sobit_pro_gpu_cuda11.0_cudnn8.0 \
    --privileged \
    --user sobits \
    sobits/ros_melodic_sobit_pro_gpu_cuda11.0_cudnn8.0 \
    /bin/bash 