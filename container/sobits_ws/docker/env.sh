# Docker Environment Configuration

# Get LOCAL_UID and LOCAL_GID
LOCAL_UID=$(id -u)
LOCAL_GID=$(id -g)

# System Configuration
UBUNTU_VERSION=22.04
USE_GPU=true
INSTALL_ROS=true

# User Configuration
USERNAME=$(whoami)
CONTAINER_NAME=$(basename $(dirname $(pwd)))

# Packages
CUDA_VERSION=12.5.1 # when USE_GPU=true
ROS_DISTRO=humble   # when INSTALL_ROS=true
