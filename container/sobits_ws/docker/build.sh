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

# Construct the unique tag for our reusable OpenCV image
CV_IMAGE_TAG="${DOCKERHUB_USERNAME}/opencv:${CV2_VERSION}-${COMPUTE_TYPE}-ubuntu${UBUNTU_VERSION}"
PYTORCH_IMAGE_TAG="${DOCKERHUB_USERNAME}/pytorch:${PYTORCH_VERSION}-cuda${CUDA_VERSION%.*}-ubuntu${UBUNTU_VERSION}"

# Determine base images for intermediate stages and final stage
PYTORCH_BASE_STAGE="base"
OPENCV_BASE_STAGE="base"
FINAL_STAGE="base"
if [[ "${INSTALL_ROS}" == "true" ]]; then
    PYTORCH_BASE_STAGE="base_with_ros"
    OPENCV_BASE_STAGE="base_with_ros"
    FINAL_STAGE="base_with_ros"

    if [[ "${INSTALL_PYTORCH}" == "true" ]]; then
        OPENCV_BASE_STAGE="base_with_pytorch"
        FINAL_STAGE="base_with_pytorch"

        if [[ "${INSTALL_CV2}" == "true" ]]; then
            FINAL_STAGE="base_with_opencv"
        fi
    elif [[ "${INSTALL_CV2}" == "true" ]]; then
        FINAL_STAGE="base_with_opencv"
    fi
elif [[ "${INSTALL_PYTORCH}" == "true" ]]; then
    OPENCV_BASE_STAGE="base_with_pytorch"
    FINAL_STAGE="base_with_pytorch"

    if [[ "${INSTALL_CV2}" == "true" ]]; then
        FINAL_STAGE="base_with_opencv"
    fi
elif [[ "${INSTALL_CV2}" == "true" ]]; then
    FINAL_STAGE="base_with_opencv"
fi

# Delete existing .env file if it exists
if [[ -f ".env" ]]; then
    rm .env
fi

# Generate .env file for Docker Compose
cat > .env <<EOF
LOCAL_UID=${LOCAL_UID}
LOCAL_GID=${LOCAL_GID}
USERNAME=${USERNAME}
IMAGE_NAME=${IMAGE_NAME}
CONTAINER_NAME=${CONTAINER_NAME}
UBUNTU_VERSION=${UBUNTU_VERSION}
COMPUTE_TYPE=${COMPUTE_TYPE}
CUDA_VERSION=${CUDA_VERSION}
INSTALL_ROS=${INSTALL_ROS}
INSTALL_GAZEBO=${INSTALL_GAZEBO}
INSTALL_PYTORCH=${INSTALL_PYTORCH}
INSTALL_CV2=${INSTALL_CV2}
PYTORCH_IMAGE_TAG=${PYTORCH_IMAGE_TAG}
CV_IMAGE_TAG=${CV_IMAGE_TAG}
ROS_DISTRO=${ROS_DISTRO}
ROS_DOMAIN_ID=${ROS_DOMAIN_ID}
PYTORCH_VERSION=${PYTORCH_VERSION}
CV2_VERSION=${CV2_VERSION}
PYTORCH_IMAGE_TAG=${PYTORCH_IMAGE_TAG}
PYTORCH_BASE_STAGE=${PYTORCH_BASE_STAGE}
OPENCV_BASE_STAGE=${OPENCV_BASE_STAGE}
FINAL_STAGE=${FINAL_STAGE}
EOF


# =============================================================================
# Main Command Logic
# =============================================================================
COMMAND=${1:-"sobits"}

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
  "pytorch")
    echo "======================================================"
    echo " Building PyTorch Image"
    echo "======================================================"
    echo "TAG: ${PYTORCH_IMAGE_TAG}"
    echo ""

    docker build \
      --build-arg UBUNTU_VERSION="${UBUNTU_VERSION}" \
      --build-arg CUDA_VERSION="${CUDA_VERSION}" \
      --build-arg COMPUTE_TYPE="${COMPUTE_TYPE}" \
      --build-arg PYTORCH_VERSION="${PYTORCH_VERSION}" \
      -t "${PYTORCH_IMAGE_TAG}" \
      -f pytorch.Dockerfile .

    echo ""
    read -p "Build complete. Do you want to push this image to Docker Hub? (y/N) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "Pushing ${PYTORCH_IMAGE_TAG} to Docker Hub..."
        docker push "${PYTORCH_IMAGE_TAG}"
    fi
    ;;

  "sobits")
    echo "======================================================"
    echo " Building SOBITS Image"
    echo "======================================================"
    # Print a smarter summary of the build stages: deduplicate and show mapping
    stages=("${PYTORCH_BASE_STAGE}" "${OPENCV_BASE_STAGE}" "${FINAL_STAGE}")
    declare -A _seen
    unique=()
    for s in "${stages[@]}"; do
      if [[ -z "${_seen[$s]}" ]]; then
        unique+=("$s")
        _seen[$s]=1
      fi
    done
    if [[ ${#unique[@]} -eq 1 ]]; then
      echo "Docker build target: ${unique[0]} (all stages identical)"
    else
      echo -n "Docker build targets:"
      for u in "${unique[@]}"; do
        echo -n " ${u}"
      done
      echo
      echo "  (pyTorch base: ${PYTORCH_BASE_STAGE}, openCV base: ${OPENCV_BASE_STAGE}, final: ${FINAL_STAGE})"
    fi
    if [[ "${INSTALL_CV2}" == "true" ]]; then
      echo "Using pre-built OpenCV image: ${CV_IMAGE_TAG}"
    fi
    if [[ "${INSTALL_PYTORCH}" == "true" ]]; then
      echo "Using pre-built PyTorch image: ${PYTORCH_IMAGE_TAG}"
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
    echo "Usage: $0 {opencv|pytorch|sobits}"
    echo ""
    echo "Commands:"
    echo "  opencv    Build the reusable OpenCV base image and optionally push it to Docker Hub."
    echo "  pytorch   Build the reusable PyTorch base image and optionally push it to Docker Hub."
    echo "  sobits    Build the final application image using whether or not we need the pre-built OpenCV image."
    exit 1
    ;;
esac

echo "Done."