#! /bin/bash
cd ~/docker_ws/container/ros_kinetic_basic_ws/

xhost +

docker run -it \
	-p 6080:80 \
	--gpus all \
	--device /dev/:/dev/ \
    	--mount type=bind,src=$(pwd)/src/,dst=/home/sobits/catkin_ws/src/,bind-propagation=shared \
    	-e LOCAL_UID=$(id -u $USER) \
    	-e LOCAL_GID=$(id -g $USER) \
	--shm-size=512m \
	--name ros_kinetic_basic_ws \
	--privileged \
	-e DISPLAY=$DISPLAY \
    	-e QT_X11_NO_MITSHM=1 \
    	-v /tmp/.X11-unix/:/tmp/.X11-unix \
	sobits/ros_kinetic_basic_ws
