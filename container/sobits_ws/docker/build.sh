#!/bin/bash
set -e # Exit immediately if a command exits with a non-zero status.
cd "$(dirname "${BASH_SOURCE[0]}")"

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
CV_IMAGE_TAG="${DOCKERHUB_USERNAME}/opencv:${CV2_VERSION}-ubuntu${UBUNTU_VERSION}-${COMPUTE_TYPE}"
PYTORCH_IMAGE_TAG="${DOCKERHUB_USERNAME}/pytorch:${PYTORCH_VERSION}-ubuntu${UBUNTU_VERSION}-${COMPUTE_TYPE}"
if [[ "${COMPUTE_TYPE}" == "gpu" ]]; then
    CV_IMAGE_TAG+="-cuda${CUDA_VERSION%.*}"
    PYTORCH_IMAGE_TAG+="-cuda${CUDA_VERSION%.*}"
fi
ROS_IMAGE_TAG="ros:${ROS_DISTRO}"

# Determine base images for intermediate stages and final stage
PYTORCH_BASE_STAGE="null"
OPENCV_BASE_STAGE="null"
ROS_BASE_STAGE="null"
FINAL_STAGE="base"
if [[ "${INSTALL_PYTORCH}" == "true" ]]; then
    PYTORCH_BASE_STAGE="base"
    FINAL_STAGE="base_with_pytorch"
    if [[ "${INSTALL_CV2}" == "true" ]]; then
        OPENCV_BASE_STAGE="base_with_pytorch"
        FINAL_STAGE="base_with_opencv"
        if [[ "${INSTALL_ROS}" == "true" ]]; then
            ROS_BASE_STAGE="base_with_opencv"
            FINAL_STAGE="base_with_ros"
        fi
    elif [[ "${INSTALL_ROS}" == "true" ]]; then
        ROS_BASE_STAGE="base_with_pytorch"
        FINAL_STAGE="base_with_ros"
    fi
elif [[ "${INSTALL_CV2}" == "true" ]]; then
    OPENCV_BASE_STAGE="base"
    FINAL_STAGE="base_with_opencv"
    if [[ "${INSTALL_ROS}" == "true" ]]; then
        ROS_BASE_STAGE="base_with_opencv"
        FINAL_STAGE="base_with_ros"
    fi
elif [[ "${INSTALL_ROS}" == "true" ]]; then
    ROS_BASE_STAGE="base"
    FINAL_STAGE="base_with_ros"
fi

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
IMAGE_NAME=${IMAGE_NAME}
CONTAINER_NAME=${CONTAINER_NAME}
CUDA_VERSION=${CUDA_VERSION}
INSTALL_GAZEBO=${INSTALL_GAZEBO}
PYTORCH_IMAGE_TAG=${PYTORCH_IMAGE_TAG}
CV_IMAGE_TAG=${CV_IMAGE_TAG}
PYTORCH_VERSION=${PYTORCH_VERSION}
CV2_VERSION=${CV2_VERSION}
ROS_IMAGE_TAG=${ROS_IMAGE_TAG}
ROS_DISTRO=${ROS_DISTRO}
ROS_DOMAIN_ID=${ROS_DOMAIN_ID}
ROS_WORKSPACE=${ROS_WORKSPACE}
PYTORCH_BASE_STAGE=${PYTORCH_BASE_STAGE}
OPENCV_BASE_STAGE=${OPENCV_BASE_STAGE}
ROS_BASE_STAGE=${ROS_BASE_STAGE}
FINAL_STAGE=${FINAL_STAGE}
EOF

if [[ "${INSTALL_ROS}" == "true" ]]; then
    if [[ "${ROS_DISTRO}" == "noetic" ]]; then
cat > ros_entrypoint.sh <<EOF
source /opt/ros/${ROS_DISTRO}/setup.bash
source ~/${ROS_WORKSPACE}/devel/setup.bash
export ROS_MASTER_URI=http://localhost:11311
alias cm='CURRENT_DIR=\`pwd\` && cd ~/${ROS_WORKSPACE}/ && catkin_make && source ~/.bashrc && cd \${CURRENT_DIR}'
EOF
    else
cat > ros_entrypoint.sh <<EOF
source /opt/ros/${ROS_DISTRO}/setup.bash
source ~/${ROS_WORKSPACE}/install/setup.bash
source /usr/share/colcon_argcomplete/hook/colcon-argcomplete.bash
export ROS_DOMAIN_ID=${ROS_DOMAIN_ID}
alias cb='CURRENT_DIR=\`pwd\` && cd ~/${ROS_WORKSPACE}/ && colcon build --symlink-install && source ~/.bashrc && cd \${CURRENT_DIR}'
EOF
    fi
fi
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
    stages=("${PYTORCH_BASE_STAGE}" "${OPENCV_BASE_STAGE}" "${ROS_BASE_STAGE}" "${FINAL_STAGE}")
    declare -A _seen
    unique=()
    for s in "${stages[@]}"; do
      if [[ -z "${_seen[$s]}" ]]; then
        if [[ "${s}" != "null" ]]; then
          unique+=("$s")
        fi
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
      echo ""
    fi
    if [[ "${INSTALL_CV2}" == "true" ]]; then
      echo "Using pre-built OpenCV image: ${CV_IMAGE_TAG}"
    fi
    if [[ "${INSTALL_PYTORCH}" == "true" ]]; then
      echo "Using pre-built PyTorch image: ${PYTORCH_IMAGE_TAG}"
    fi
    if [[ "${INSTALL_ROS}" == "true" ]]; then
      echo "Using pre-built ROS image: ${ROS_IMAGE_TAG}"
    fi
    echo ""

    if [ "${COMPUTE_TYPE}" = "gpu" ]; then
        if ! command -v nvidia-smi &> /dev/null; then
            echo "Error: nvidia-smi not found. GPU may not be available."
            exit 1
        fi
        docker compose build sobits-container-gpu
    elif [ "${COMPUTE_TYPE}" = "cpu" ]; then
        docker compose build sobits-container
    else
        echo "Error: Invalid COMPUTE_TYPE '${COMPUTE_TYPE}' in .env"
        exit 1
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
rm -f ros_entrypoint.sh
echo "Done."
