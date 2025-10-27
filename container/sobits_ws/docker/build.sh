#!/bin/bash
set -e # Exit immediately if a command exits with a non-zero status.

# Load environment variables
if [[ -f "./env.sh" ]]; then
  source ./env.sh
else
  echo "Error: env.sh not found"; exit 1
fi

# =============================================================================
# Configuration & Validation
# =============================================================================
if [[ -z "${DOCKERHUB_USERNAME}" ]]; then
    echo "Error: DOCKERHUB_USERNAME is not set in env.sh"
    exit 1
fi

# Define the build target stage based on whether we need OpenCV
IMAGE_BUILD_TARGET="base_without_opencv"
if [[ "${INSTALL_CV2}" == "true" ]]; then
    IMAGE_BUILD_TARGET="base_with_opencv"
fi

# Construct the unique tag for our reusable OpenCV image
CV_IMAGE_TAG="${DOCKERHUB_USERNAME}/opencv:${CV2_VERSION}-${COMPUTE_TYPE}-ubuntu${UBUNTU_VERSION}"

# Delete existing .env file if it exists
if [[ -f ".env" ]]; then
    rm .env
fi

# Generate .env file for Docker Compose
cat > .env <<EOF
LOCAL_UID=${LOCAL_UID}
LOCAL_GID=${LOCAL_GID}
UBUNTU_VERSION=${UBUNTU_VERSION}
COMPUTE_TYPE=${COMPUTE_TYPE}
USERNAME=${USERNAME}
CONTAINER_NAME=${CONTAINER_NAME}
IMAGE_NAME=${IMAGE_NAME}
CUDA_VERSION=${CUDA_VERSION}
PYTORCH_VERSION=${PYTORCH_VERSION}
INSTALL_PYTORCH=${INSTALL_PYTORCH}
INSTALL_ROS=${INSTALL_ROS}
INSTALL_GAZEBO=${INSTALL_GAZEBO}
INSTALL_CV2=${INSTALL_CV2}
CV2_VERSION=${CV2_VERSION}
ROS_DISTRO=${ROS_DISTRO}
ROS_DOMAIN_ID=${ROS_DOMAIN_ID}
CV_IMAGE_TAG=${CV_IMAGE_TAG}
IMAGE_BUILD_TARGET=${IMAGE_BUILD_TARGET}
EOF

# =============================================================================
# Main Command Logic
# =============================================================================
COMMAND=$1

case ${COMMAND} in
  "opencv")
    echo "======================================================"
    echo " Building OpenCV Image"
    echo "======================================================"
    echo "TAG: ${CV_IMAGE_TAG}"
    echo ""

    docker build \
      --build-arg UBUNTU_VERSION="${UBUNTU_VERSION}" \
      --build-arg CUDA_VERSION="${CUDA_VERSION}" \
      --build-arg COMPUTE_TYPE="${COMPUTE_TYPE}" \
      --build-arg CV2_VERSION="${CV2_VERSION}" \
      -t "${CV_IMAGE_TAG}" \
      -f opencv.Dockerfile .

    echo ""
    read -p "Build complete. Do you want to push this image to Docker Hub? (y/N) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "Pushing ${CV_IMAGE_TAG} to Docker Hub..."
        docker push "${CV_IMAGE_TAG}"
    fi
    ;;

  "sobits")
    echo "======================================================"
    echo " Building SOBITS Image"
    echo "======================================================"
    echo "Docker build target: ${IMAGE_BUILD_TARGET}"
    if [[ "${INSTALL_CV2}" == "true" ]]; then
      echo "Using pre-built OpenCV image: ${CV_IMAGE_TAG}"
    fi
    echo ""

    if [ ${COMPUTE_TYPE} = "gpu" ]; then
        if ! command -v nvidia-smi &> /dev/null; then
            echo "Error: nvidia-smi not found. GPU may not be available."
            exit 1
        fi
        docker compose build sobits-container-gpu
    else
        docker compose build sobits-container
    fi
    ;;

  *)
    echo "Usage: $0 {opencv|sobits}"
    echo ""
    echo "Commands:"
    echo "  opencv    Build the reusable OpenCV base image and optionally push it to Docker Hub."
    echo "  sobits    Build the final application image using whether or not we need the pre-built OpenCV image."
    exit 1
    ;;
esac

echo "Done."