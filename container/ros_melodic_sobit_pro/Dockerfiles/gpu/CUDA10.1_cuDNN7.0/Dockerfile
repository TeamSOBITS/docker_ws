FROM sobits/ros_melodic_basic_ws_gpu_cuda10.1_cudnn7.0:latest

MAINTAINER Yuki Ikeda

# Install Numpy
RUN pip3 install numpy

# Install Pytorch
RUN pip3 install torch torchvision

# Install matplotlib
RUN pip3 install matplotlib && \
    apt-get update && \
    apt-get install python3-tk

# Install ROS Packages
RUN apt update -y && \
    apt install ros-melodic-rosbridge-* -y && \
    apt install ros-melodic-ecl-* -y && \
    apt install ros-melodic-joy -y && \
    apt install ros-melodic-roswww -y && \
    apt install ros-melodic-kobuki-* -y && \
    apt install ros-melodic-joint-state-publisher* -y

# Install PCL
RUN apt install ros-melodic-pcl-* -y && \
    apt install ros-melodic-openni2-* -y

# joint
RUN sudo apt update&&\
    sudo apt install ros-melodic-joint* -y

# clean cache
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/

RUN echo "Install Finished"