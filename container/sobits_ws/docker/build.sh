#!/bin/bash

# Load environment variables
export $(cat .env | grep -v '^#' | xargs)

# Get LOCAL_UID and LOCAL_GID
export LOCAL_UID=$(id -u)
export LOCAL_GID=$(id -g)

# Check COMPUTE_TYPE and validate
if [ -z "${COMPUTE_TYPE}" ]; then
    echo "Error: COMPUTE_TYPE not set in .env file"
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