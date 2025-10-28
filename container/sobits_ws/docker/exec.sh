#!/bin/bash

# Load environment variables
if [[ -f ".env" ]]; then
  source .env
else
  echo ".env not found"; exit 1
fi

PROJECT_NAME=${CONTAINER_NAME}

# Check if container is running
if [ ! "$(docker ps -q -f name=${CONTAINER_NAME})" ]; then
    echo "Container ${CONTAINER_NAME} is not running."
    echo "Please run './up.sh' first to start the container."
    exit 1
fi

# Select service name based on COMPUTE_TYPE
if [ ${COMPUTE_TYPE} = "cpu" ]; then
    SERVICE_NAME="sobits-container"
else
    SERVICE_NAME="sobits-container-gpu"
fi

echo "Entering container: ${CONTAINER_NAME}"
docker compose -p ${PROJECT_NAME} exec -it --user ${USERNAME} ${SERVICE_NAME} /bin/bash
