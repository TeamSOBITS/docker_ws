#! /bin/bash
cd ~/docker_ws/container/ros_melodic_sobit_pro/

xhost +local:$USER

docker run -it \
    --gpus all \
    --device /dev/:/dev/ \
    --mount type=bind,src=/var/run/dbus/system_bus_socket,dst=/var/run/dbus/system_bus_socket,bind-propagation=shared \
    --mount type=bind,src=/etc/localtime,dst=/etc/localtime,bind-propagation=shared \
    --mount type=bind,src=/tmp/.X11-unix,dst=/tmp/.X11-unix,bind-propagation=shared \
    --mount type=bind,src=$(pwd)/src/,dst=/home/sobits/catkin_ws/src/,bind-propagation=shared \
    --mount type=bind,src=/dev/wheel,dst=/dev/wheel,bind-propagation=shared \
    --mount type=bind,src=/dev/arm_pantilt,dst=/dev/arm_pantilt,bind-propagation=shared \
    --env LOCAL_UID=$(id -u $USER) \
    --env LOCAL_GID=$(id -g $USER) \
    --env DISPLAY=$DISPLAY \
    --env QT_X11_NO_MITSHM=1 \
    --env CONTAINER_NAME="ros_melodic_sobit_pro_gpu" \
    --shm-size=512m \
    --name ros_melodic_sobit_pro_gpu_cuda11.0_cudnn8.0 \
    --privileged \
    --user sobits \
    sobits/ros_melodic_sobit_pro_gpu_cuda11.0_cudnn8.0
    /bin/bash 