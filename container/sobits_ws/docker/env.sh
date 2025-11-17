#!/bin/bash

# -- Docker Hub --
# Your Docker Hub username is required to push/pull the reusable OpenCV image.
export DOCKERHUB_USERNAME="sobits"

# -- Base System Configuration --
export UBUNTU_VERSION="22.04"

# -- GPU / CPU Configuration --
# Set to "true" to build the GPU-enabled container, "false" for CPU-only.
export COMPUTE_TYPE="gpu"    # Options: "cpu" or "gpu"
export CUDA_VERSION="12.8.1" # Required only if COMPUTE_TYPE is "gpu"

# -- Component Installation Flags --
export INSTALL_ROS="true"   # Set to "true" or "false"
export INSTALL_GAZEBO="false"  # Set to "true" or "false"
export INSTALL_PYTORCH="false"  # Set to "true" or "false"
export INSTALL_CV2="false"  # Set to "true" or "false"

# -- Component Versions --
export ROS_DISTRO="humble"  # "humble" for 22.04, "jazzy" for 24.04
export ROS_DOMAIN_ID="0"
export PYTORCH_VERSION="2.9.0"
export CV2_VERSION="4.12.0"


# --- Do not modify below this line ---

# -- User and Group IDs --
export USERNAME=$(whoami)
export LOCAL_UID=$(id -u)
export LOCAL_GID=$(id -g)

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
