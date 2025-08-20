# Docker Environment Configuration

# Get LOCAL_UID and LOCAL_GID
LOCAL_UID=$(id -u)
LOCAL_GID=$(id -g)

# Set COMPUTE_TYPE to either "cpu" or "gpu"
COMPUTE_TYPE=cpu

# User Configuration
USER_NAME=$(whoami)
WORKSPACE_NAME=$(basename $(dirname $(pwd)))

# System Configuration
UBUNTU_VERSION=24.04
INSTALL_ROS=true
ROS_DISTRO=jazzy

# GPU Configuration (only used when COMPUTE_TYPE=gpu)
CUDA_VERSION=12.6.0
