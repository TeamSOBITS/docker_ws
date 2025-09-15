#!/bin/bash

# Load environment variables
if [[ -f "./env.sh" ]]; then
  source ./env.sh
else
  echo "env.sh not found"; exit 1
fi

if [ ${USE_GPU} = "true" ]; then
    COMPUTE_TYPE="gpu"
else
    COMPUTE_TYPE="cpu"
fi

# Generate .env file
cat > .env <<EOF
LOCAL_UID=${LOCAL_UID}
LOCAL_GID=${LOCAL_GID}
UBUNTU_VERSION=${UBUNTU_VERSION}
USE_GPU=${USE_GPU}
COMPUTE_TYPE=${COMPUTE_TYPE}
USERNAME=${USERNAME}
CONTAINER_NAME=${CONTAINER_NAME}
CUDA_VERSION=${CUDA_VERSION}
PYTORCH_VERSION=${PYTORCH_VERSION}
INSTALL_PYTORCH=${INSTALL_PYTORCH}
INSTALL_ROS=${INSTALL_ROS}
INSTALL_GAZEBO=${INSTALL_GAZEBO}
ROS_DISTRO=${ROS_DISTRO}
ROS_DOMAIN_ID=${ROS_DOMAIN_ID}
EOF
echo "Generated .env file"

# Check USE_GPU and validate
if [ -z ${USE_GPU} ]; then
    echo "Error: USE_GPU not set in env.sh file"
    echo "Please set USE_GPU to either 'true' or 'false'"
    exit 1
fi

if [ ${USE_GPU} != "true" ] && [ ${USE_GPU} != "false" ]; then
    echo "Error: USE_GPU must be either 'true' or 'false'"
    echo "Current value: ${USE_GPU}"
    exit 1
fi

echo "Building Docker image for ${COMPUTE_TYPE} environment..."
echo "Base image: $(if [ "${COMPUTE_TYPE}" = "gpu" ]; then echo "nvidia/cuda:${CUDA_VERSION}-cudnn-devel-ubuntu${UBUNTU_VERSION}"; else echo "ubuntu:${UBUNTU_VERSION}"; fi)"

# Check if GPU is available when gpu is selected
if [ ${USE_GPU} = "true" ]; then
    if ! command -v nvidia-smi &> /dev/null; then
        echo "Error: nvidia-smi not found. GPU may not be available."
        exit 1
    else
        echo "GPU Status:"
        nvidia-smi --query-gpu=name,driver_version,memory.total --format=csv,noheader,nounits
    fi
fi

# Build the Docker image
if [ ${USE_GPU} = "true" ]; then
    docker compose build sobits-container-gpu
else
    docker compose build sobits-container
fi