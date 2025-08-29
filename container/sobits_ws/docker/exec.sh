#!/bin/bash

# Load environment variables
if [[ -f "./env.sh" ]]; then
  source ./env.sh
else
  echo "env.sh not found"; exit 1
fi

# Check if container is running
if [ ! "$(docker ps -q -f name=${CONTAINER_NAME})" ]; then
    echo "Container ${CONTAINER_NAME} is not running."
    echo "Please run './run.sh' first to start the container."
    exit 1
fi

echo "Entering container: ${CONTAINER_NAME}"
docker exec -it --user ${USERNAME} ${CONTAINER_NAME} bash
