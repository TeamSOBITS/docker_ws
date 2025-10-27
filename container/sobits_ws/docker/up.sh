#!/bin/bash

# Load environment variables
if [[ -f ".env" ]]; then
  source .env
else
  echo ".env not found"; exit 1
fi

echo "Starting Docker container for $(if [ ${USE_GPU} = "true" ]; then echo "GPU"; else echo "CPU"; fi) environment..."

PROJECT_NAME=${CONTAINER_NAME}

# Select service name based on USE_GPU
if [ ${USE_GPU} = "false" ]; then
    SERVICE_NAME="sobits-container"
else
    SERVICE_NAME="sobits-container-gpu"
fi

# Start the appropriate container
docker compose -p ${PROJECT_NAME} up -d ${SERVICE_NAME}
