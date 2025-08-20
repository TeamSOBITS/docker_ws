#!/bin/bash

# Load environment variables
if [[ -f "./env.sh" ]]; then
  source ./env.sh
else
  echo "env.sh not found"; exit 1
fi

# Check COMPUTE_TYPE
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

echo "Starting Docker container for ${COMPUTE_TYPE} environment..."

PROJECT_NAME=$WORKSPACE_NAME

# Select service name based on COMPUTE_TYPE
if [ "${COMPUTE_TYPE}" = "cpu" ]; then
    SERVICE_NAME="sobits-container"
else
    SERVICE_NAME="sobits-container-gpu"
fi

# Start the appropriate container
docker compose -f docker-compose.yml -p "${PROJECT_NAME}" up -d "${SERVICE_NAME}"