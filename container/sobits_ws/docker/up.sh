#!/bin/bash

# Load environment variables
if [[ -f ".env" ]]; then
  source .env
else
  echo ".env not found"; exit 1
fi

echo "Starting Docker container for $(if [ ${COMPUTE_TYPE} = "gpu" ]; then echo "GPU"; else echo "CPU"; fi) environment..."

PROJECT_NAME=${CONTAINER_NAME}

# Select service name based on COMPUTE_TYPE
if [ "${COMPUTE_TYPE}" = "cpu" ]; then
    SERVICE_NAME="sobits-container"
elif [ "${COMPUTE_TYPE}" = "gpu" ]; then
    SERVICE_NAME="sobits-container-gpu"
else
    echo "Error: Invalid COMPUTE_TYPE '${COMPUTE_TYPE}' in .env"
    exit 1
fi

# Start the appropriate container
docker compose -p ${PROJECT_NAME} up -d ${SERVICE_NAME}
