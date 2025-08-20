#!/bin/bash

# Load environment variables
if [[ -f "./env.sh" ]]; then
  source ./env.sh
else
  echo "env.sh not found"; exit 1
fi

# Generate .env file
cat > .env <<EOF
LOCAL_UID=${LOCAL_UID}
LOCAL_GID=${LOCAL_GID}
COMPUTE_TYPE=${COMPUTE_TYPE}
USER_NAME=${USER_NAME}
WORKSPACE_NAME=${WORKSPACE_NAME}
UBUNTU_VERSION=${UBUNTU_VERSION}
INSTALL_ROS=${INSTALL_ROS}
ROS_DISTRO=${ROS_DISTRO}
CUDA_VERSION=${CUDA_VERSION}
EOF
echo "Generated .env:"

# Check COMPUTE_TYPE and validate
if [ -z "${COMPUTE_TYPE}" ]; then
    echo "Error: COMPUTE_TYPE not set in env.sh file"
    echo "Please set COMPUTE_TYPE to either 'cpu' or 'gpu'"
    exit 1
fi

if [ "${COMPUTE_TYPE}" != "cpu" ] && [ "${COMPUTE_TYPE}" != "gpu" ]; then
    echo "Error: COMPUTE_TYPE must be either 'cpu' or 'gpu'"
    echo "Current value: ${COMPUTE_TYPE}"
    exit 1
fi

echo "Building Docker image for ${COMPUTE_TYPE} environment..."
echo "Base image: $(if [ "${COMPUTE_TYPE}" = "gpu" ]; then echo "nvidia/cuda:${CUDA_VERSION}-cudnn-devel-ubuntu${UBUNTU_VERSION}"; else echo "ubuntu:${UBUNTU_VERSION}"; fi)"

# Check if GPU is available when gpu is selected
if [ "${COMPUTE_TYPE}" = "gpu" ]; then
    if ! command -v nvidia-smi &> /dev/null; then
        echo "Warning: nvidia-smi not found. GPU may not be available."
    else
        echo "GPU Status:"
        nvidia-smi --query-gpu=name,driver_version,memory.total --format=csv,noheader,nounits
    fi
fi

# Build the Docker image
if [ "${COMPUTE_TYPE}" = "gpu" ]; then
    docker compose build sobits-container-gpu
else
    docker compose build sobits-container
fi