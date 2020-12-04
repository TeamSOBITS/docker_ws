FROM sobits/ros_melodic_basic_ws_gpu_cuda11.0_cudnn8.0:latest

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
RUN apt update &&\
    apt install ros-melodic-pcl-* -y && \
    apt install ros-melodic-openni2-* -y

# Install joint
RUN sudo apt update &&\
    sudo apt install ros-melodic-joint* -y

# Install ps4 controller
RUN sudo apt-get install ros-melodic-joy

# Install Pybind
RUN sudo apt update &&\
    sudo apt install ros-melodic-pybind11-catkin -y

# Install URG
RUN sudo apt update &&\
    sudo apt install ros-melodic-urg-node -y

# Install SLAM 
RUN sudo apt update &&\
    sudo apt install ros-melodic-map-server -y &&\
    sudo apt install ros-melodic-move-base-* -y &&\
    sudo apt-get install ros-melodic-dwa-local-planner -y
# clean cache
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/

RUN echo "Install Finished"