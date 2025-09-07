#!/bin/bash

# Load environment variables
if [[ -f ".env" ]]; then
  source .env
else
  echo ".env not found"; exit 1
fi

PROJECT_NAME=${CONTAINER_NAME}

# Stop and remove the Docker container
echo "Stopping and removing container: ${CONTAINER_NAME}..."
docker compose -p ${PROJECT_NAME} down