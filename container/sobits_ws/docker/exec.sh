#!/bin/bash

# Load environment variables
export $(cat env.sh | grep -v '^#' | xargs)

# Check COMPUTE_TYPE
if [ -z "${COMPUTE_TYPE}" ]; then
    echo "Error: COMPUTE_TYPE not set in env.sh file"
    exit 1
fi

CONTAINER_NAME="${WORKSPACE_NAME}_${COMPUTE_TYPE}"

# Check if container is running
if [ ! "$(docker ps -q -f name=${CONTAINER_NAME})" ]; then
    echo "Container ${CONTAINER_NAME} is not running."
    echo "Please run './run.sh' first to start the container."
    exit 1
fi

echo "Entering container: ${CONTAINER_NAME}"
docker exec -it --user ${USER_NAME} "${CONTAINER_NAME}" bash
