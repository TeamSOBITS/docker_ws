FROM sobits/ros_melodic_basic_ws_gpu_cuda11.0_cudnn8.0:latest

MAINTAINER Yuki Ikeda

# Install Numpy
RUN pip3 install numpy

# Install Pytorch
RUN pip3 install torch torchvision

# Install Chainer
RUN pip3 install chainer && \
    pip3 install chainerrl

# Install matplotlib
RUN pip3 install matplotlib && \
    apt-get update && \
    apt-get install python3-tk

# clean cache
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/

# Install ros-melodic-urg-node
# RUN apt-get install ros-melodic-urg-node

# Install ros-melodic-uvc-camera
# RUN apt-get install ros-melodic-uvc-camera

# Install ros-melodic-roswww
# RUN apt-get install ros-melodic-roswww

# Install ros-melodic-rosbridge-suite
# RUN apt-get install ros-melodic-rosbridge-suite

# Install ros-melodic-jsk-rviz-plugins
# RUN apt-get install ros-melodic-jsk-rviz-plugins

# Install mplayer
# RUN apt-get install mplayer

# Install smach
# RUN apt-get install ros-melodic-smach*

# Install ros-control
# RUN apt install ros-melodic-ros-control*

# Install ros-control
# RUN apt install ros-melodic-joint-*

# Install sympy
# RUN pip install sympy

RUN echo "Install Finished"