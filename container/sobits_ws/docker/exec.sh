#!/bin/bash

# Load environment variables
if [[ -f ".env" ]]; then
  source .env
else
  echo ".env not found"; exit 1
fi

# Check if container is running
if [ ! "$(docker ps -q -f name=${CONTAINER_NAME})" ]; then
    echo "Container ${CONTAINER_NAME} is not running."
    echo "Please run './run.sh' first to start the container."
    exit 1
fi

# Select service name based on USE_GPU
if [ ${USE_GPU} = "false" ]; then
    SERVICE_NAME="sobits-container"
else
    SERVICE_NAME="sobits-container-gpu"
fi

echo "Entering container: ${CONTAINER_NAME}"
docker compose -p ${CONTAINER_NAME} exec -it ${SERVICE_NAME} /bin/bash
