#! /bin/bash
cd ~/docker_ws/container/ros_kinetic_basic_ws/

xhost +local:root

docker run -it \
	--gpus all \
	--device /dev/:/dev/ \
	--mount type=bind,src=$(pwd)/src/,dst=/home/sobits/catkin_ws/src/,bind-propagation=shared \
    	-e LOCAL_UID=$(id -u $USER) \
    	-e LOCAL_GID=$(id -g $USER) \
    	-e DISPLAY=$DISPLAY \
    	-e QT_X11_NO_MITSHM=1 \
    	-v /tmp/.X11-unix/:/tmp/.X11-unix \
    	--shm-size=512m \
    	--name ros_kinetic_basic_ws_cui_cuda9.0_cudnn7.6 \
    	--privileged \
    	sobits/ros_kinetic_basic_ws_cui_cuda9.0_cudnn7.6 \
    	/bin/bash --rcfile /home/sobits/.bashrc
