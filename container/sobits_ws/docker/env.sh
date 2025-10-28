#!/bin/bash

# Docker Environment Configuration

# Get LOCAL_UID and LOCAL_GID
LOCAL_UID=$(id -u)
LOCAL_GID=$(id -g)

# System Configuration
UBUNTU_VERSION=22.04
USE_GPU=true
INSTALL_PYTORCH=true
INSTALL_ROS=true
INSTALL_GAZEBO=true
INSTALL_CV2=true

# Packages
CUDA_VERSION=12.6.3 # when USE_GPU=true
PYTORCH_VERSION=2.8.0 # when INSTALL_PYTORCH=true
ROS_DISTRO=humble   # when INSTALL_ROS=true
CV2_VERSION=4.12.0   # when INSTALL_CV2=true

# User Configuration
USERNAME=$(whoami)
CONTAINER_NAME=$(basename $(dirname $(pwd)))
ROS_DOMAIN_ID=1 # when INSTALL_ROS=true
