#!/bin/bash

# -- Docker Hub --
# Your Docker Hub username is required to push/pull the reusable OpenCV image.
export DOCKERHUB_USERNAME="sobits"

# -- Base System Configuration --
export UBUNTU_VERSION="24.04"
export USERNAME=$(whoami)
export LOCAL_UID=$(id -u)
export LOCAL_GID=$(id -g)

# -- GPU / CPU Configuration --
# Set to "true" to build the GPU-enabled container, "false" for CPU-only.
export USE_GPU="true"
export CUDA_VERSION="12.8.1" # Required only if USE_GPU is true
export COMPUTE_TYPE="cpu"
if [[ "${USE_GPU}" == "true" ]]; then
    COMPUTE_TYPE="gpu"
fi

# -- Component Installation Flags --
export INSTALL_CV2="true"      # Set to "true" or "false"
export INSTALL_ROS="true"      # Set to "true" or "false"
export INSTALL_PYTORCH="true"  # Set to "true" or "false"
export INSTALL_GAZEBO="true"   # Set to "true" or "false"

# -- Component Versions --
export CV2_VERSION="4.12.0"
export PYTORCH_VERSION="2.9.0" # Example version
export ROS_DISTRO="jazzy"     # "humble" for 22.04, "jazzy" for 24.04
export ROS_DOMAIN_ID="30"

# -- Naming --

# () The name of the image based on the configuration
export IMAGE_NAME="${DOCKERHUB_USERNAME}/workspace:${COMPUTE_TYPE}-ubuntu${UBUNTU_VERSION}"

if [ "${INSTALL_CV2}" == "true" ]; then
  export IMAGE_NAME+="-opencv${CV2_VERSION}"
fi

if [ "${INSTALL_PYTORCH}" == "true" ]; then
  export IMAGE_NAME+="-pytorch${PYTORCH_VERSION}"
fi

if [ "${INSTALL_ROS}" == "true" ]; then
  export IMAGE_NAME+="-ros${ROS_DISTRO}"
fi

if [ "${INSTALL_GAZEBO}" == "true" ]; then
  export IMAGE_NAME+="-gz"
fi

# () The name of the Docker container
export CONTAINER_NAME=$(basename $(dirname $(pwd)))
