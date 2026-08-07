#!/bin/bash

# ######################################################################################
# Script to build and install OpenCV from source for a ROS 2 environment using Ninja.
#
# This script is optimized for building OpenCV with both C++ and Python support,
# making it ideal for ROS 2 development. It uses the Ninja build system for
# faster compilation.
#
# It handles three main variables:
# 1. COMPUTER_TYPE:   Specifies the build target (cpu or gpu).
# 2. OPENCV_VERSION:  The version of OpenCV to install.
# 3. HEADLESS:        (Optional) Set to "true" for servers or robots without a display.
#
# Supported Ubuntu versions: 22.04, 24.04 and later.
#
# Usage:
# ./build_opencv_ros2_ninja.sh [COMPUTER_TYPE] [OPENCV_VERSION] [HEADLESS]
#
# Example (Desktop with GPU):
# ./build_opencv_ros2_ninja.sh gpu 4.9.0
#
# Example (Headless server with CPU):
# ./build_opencv_ros2_ninja.sh cpu 4.9.0 true
#
# ######################################################################################

set -e

# --- Configuration ---
MODE=$1
COMPUTER_TYPE=$2
OPENCV_VERSION=$3
INSTALL_PATH=${4:-/tmp/opencv_pkg_install} # Default install path
HEADLESS=${5:-false} # Default to false (GUI enabled)

PYTHON_VERSION_DIR=$(python3 -c "import sys; print(f'python{sys.version_info.major}.{sys.version_info.minor}')")

# --- Function to display usage information ---
usage() {
    echo "Usage: $0 [MODE] [COMPUTER_TYPE] [OPENCV_VERSION] [INSTALL_PATH] [HEADLESS]"
    echo "  MODE:           build | runtime"
    echo "  COMPUTER_TYPE:  cpu | gpu"
    echo "  OPENCV_VERSION: e.g., 4.12.0"
    echo "  INSTALL_PATH:   (Optional) Path to install OpenCV (default: /tmp/opencv_pkg_install)"
    echo "  HEADLESS:       (Optional) 'true' to skip GUI dependencies."
    exit 1
}

# --- Validate input arguments ---
validate_args() {
    if [ -z "$MODE" ] || [ -z "$COMPUTER_TYPE" ] || [ -z "$OPENCV_VERSION" ]; then
        echo "Error: Missing required arguments."
        usage
    fi
    if [ "$MODE" != "build" ] && [ "$MODE" != "runtime" ]; then
        echo "Error: Invalid MODE. Must be 'build' or 'runtime'."
        usage
    fi
    if [ "$COMPUTER_TYPE" != "cpu" ] && [ "$COMPUTER_TYPE" != "gpu" ]; then
        echo "Error: Invalid COMPUTER_TYPE. Must be 'cpu' or 'gpu'."
        usage
    fi
}

# --- Check Ubuntu version ---
check_ubuntu_version() {
    source /etc/os-release
    if ! awk -v ver="$VERSION_ID" 'BEGIN {exit !(ver >= 22.04)}'; then
        echo "Warning: This script is tested on Ubuntu 22.04 and 24.04. Your version ($VERSION_ID) may not be fully compatible."
    fi
    echo "Ubuntu version $VERSION_ID detected."
}

# --- Install build dependencies ---
install_build_dependencies() {
    echo "Updating package list and installing BUILD dependencies..."
    sudo apt-get update
    # Basic build tools (including Ninja)
    sudo apt-get install -y build-essential cmake git pkg-config ninja-build wget unzip
}

# --- Install runtime dependencies ---
install_runtime_dependencies() {
    echo "Updating package list and installing RUNTIME dependencies..."
    sudo apt-get update

    # Python (numpy installed via pip to ensure numpy 2.x)
    sudo apt-get install -y python3-dev python3-pip
    PIP_BREAK_SYSTEM_PACKAGES=1 pip3 install --upgrade "numpy>=2.0"

    # Math and Linear Algebra Libraries for Performance
    sudo apt-get install -y libatlas-base-dev libeigen3-dev # liblapacke-dev

    # Media I/O libraries
    sudo apt-get install -y libavcodec-dev libavformat-dev libswscale-dev libv4l-dev \
        libxvidcore-dev libx264-dev libjpeg-dev libpng-dev libtiff-dev
    # Optimization and threading libraries
    sudo apt-get install -y gfortran libopenexr-dev libatlas-base-dev libtbb-dev libtbbmalloc2 # libtbb2
    # Other useful libraries for robotics
    sudo apt-get install -y libdc1394-dev libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev

    # Install GUI libraries unless in headless mode
    if [ "$HEADLESS" != "true" ]; then
        echo "Installing GUI libraries (Qt5)..."
        sudo apt-get install -y \
            libgtk-3-dev libqt5x11extras5-dev qtbase5-dev libqt5opengl5-dev \
            libgl1-mesa-dev libglu1-mesa-dev freeglut3-dev
    else
        echo "Skipping GUI libraries for headless build."
    fi
}


# --- Verify GPU-specific dependencies (CUDA and cuDNN) ---
check_gpu_dependencies() {
    echo "Checking for GPU-specific dependencies (CUDA and cuDNN)..."
    if ! command -v nvcc &> /dev/null; then
        echo "Error: CUDA Toolkit not found. 'nvcc' is not in the system's PATH." >&2
        echo "Please install the NVIDIA CUDA Toolkit and ensure it's configured correctly." >&2
        exit 1
    fi
    echo "CUDA Toolkit found."
    nvcc --version

    CUDNN_HEADER=$(find /usr/include /usr/local/cuda/include -name "cudnn.h" -print -quit)
    if [ -z "$CUDNN_HEADER" ]; then
        echo "Error: cuDNN header (cudnn.h) not found in standard include paths." >&2
        echo "Please install cuDNN and ensure it is in the correct directory." >&2
        exit 1
    fi
    echo "cuDNN header found at: $CUDNN_HEADER"
    # grep CUDNN_MAJOR -A 2 "$CUDNN_HEADER"
}

# --- Download OpenCV and OpenCV Contrib ---
download_opencv() {
    echo "Downloading OpenCV $OPENCV_VERSION..."
    cd /tmp
    wget -O opencv.zip "https://github.com/opencv/opencv/archive/${OPENCV_VERSION}.zip"
    wget -O opencv_contrib.zip "https://github.com/opencv/opencv_contrib/archive/${OPENCV_VERSION}.zip"
    unzip -q opencv.zip && mv "opencv-${OPENCV_VERSION}" opencv
    unzip -q opencv_contrib.zip && mv "opencv_contrib-${OPENCV_VERSION}" opencv_contrib
}

# --- Configure and build OpenCV ---
build_opencv() {
    echo "Configuring and building OpenCV..."
    cd /tmp/opencv
    mkdir -p build && cd build

    # --- CMAKE FLAGS ---
    CMAKE_FLAGS=(
        # Build generator
        "-G Ninja"

        # Build type and install path
        "-D CMAKE_BUILD_TYPE=RELEASE"
        # "-D CMAKE_INSTALL_PREFIX=/usr/local"
        "-D CMAKE_INSTALL_PREFIX=${INSTALL_PATH}"

        # Enable pkg-config for ROS 2 build system (colcon)
        "-D OPENCV_GENERATE_PKGCONFIG=ON"

        # Python 3 bindings
        "-D BUILD_opencv_python3=ON"
        "-D PYTHON3_EXECUTABLE=$(which python3)"
        "-D PYTHON3_INCLUDE_DIR=$(python3 -c "from sysconfig import get_paths; print(get_paths()['include'])")"
        "-D PYTHON3_NUMPY_INCLUDE_DIRS=$(python3 -c "import numpy; print(numpy.get_include())")"
        # "-D PYTHON3_PACKAGES_PATH=$(python3 -c "from site import getsitepackages; print(getsitepackages()[0])")"
        "-D PYTHON3_PACKAGES_PATH=${INSTALL_PATH}/lib/${PYTHON_VERSION_DIR}/dist-packages"

        # Contrib modules (for SIFT, ArUco, etc.)
        "-D OPENCV_EXTRA_MODULES_PATH=/tmp/opencv_contrib/modules"

        # Enable/disable features
        "-D BUILD_EXAMPLES=OFF"
        "-D BUILD_TESTS=OFF"
        "-D BUILD_PERF_TESTS=OFF"
        "-D WITH_TBB=ON"
    )

    # GUI settings
    if [ "$HEADLESS" != "true" ]; then
        CMAKE_FLAGS+=("-D WITH_QT=ON" "-D WITH_OPENGL=ON" "-D WITH_GTK=OFF")
    else
        CMAKE_FLAGS+=("-D WITH_GUI=OFF")
    fi

    # GPU-specific flags
    if [ "$COMPUTER_TYPE" == "gpu" ]; then
        echo "Enabling GPU-specific CMake flags for CUDA/cuDNN."
        CMAKE_FLAGS+=(
            "-D WITH_CUDA=ON"
            "-D WITH_CUDNN=ON"
            "-D OPENCV_DNN_CUDA=ON"
            "-D ENABLE_FAST_MATH=1"
            "-D CUDA_FAST_MATH=1"
            "-D WITH_CUBLAS=1"
            "-D WITH_NVCUVID=OFF"
            "-D WITH_NVCUVENC=OFF"
        )
    fi

    # Execute CMake, build with Ninja, and install
    echo "Running CMake with flags: ${CMAKE_FLAGS[*]}"
    cmake "${CMAKE_FLAGS[@]}" ..

    echo "Starting compilation with Ninja..."
    ninja

    echo "Installing OpenCV..."
    sudo ninja install
    sudo ldconfig
}

# --- Create environment script for OpenCV ---
create_environment_script() {
    echo "Creating OpenCV environment script at /etc/profile.d/opencv.sh"
    # Use a heredoc for readability
    cat <<EOF | sudo tee /etc/profile.d/opencv.sh
#!/bin/bash
# This script sets the environment variables for the custom-built OpenCV
export OPENCV_DIR=${INSTALL_PATH}
export LD_LIBRARY_PATH=\${OPENCV_DIR}/lib:\${LD_LIBRARY_PATH}
export PKG_CONFIG_PATH=\${OPENCV_DIR}/lib/pkgconfig:\${PKG_CONFIG_PATH}
export PYTHONPATH=\${OPENCV_DIR}/lib/${PYTHON_VERSION_DIR}/dist-packages:\${PYTHONPATH}
EOF
    # sudo chmod +x /etc/profile.d/opencv.sh
    source /etc/profile.d/opencv.sh

    # Source to bashrc for interactive shells
if ! grep -q "source /etc/profile.d/opencv.sh" ~/.bashrc; then
    echo "source /etc/profile.d/opencv.sh" >> ~/.bashrc
fi
    source ~/.bashrc
}

# --- Post-installation verification ---
verify_installation() {
    echo "Verifying installation..."
    # Verify C++ installation via pkg-config
    local cpp_version
    cpp_version=$(pkg-config --modversion opencv4)
    if [ "$cpp_version" == "$OPENCV_VERSION" ]; then
        echo "C++ bindings verification successful. (pkg-config version: $cpp_version)"
    else
        echo "Error: C++ bindings verification failed. pkg-config returned wrong version: $cpp_version" >&2
    fi

    # Verify Python installation by importing and checking version
    local python_version
    python_version=$(python3 -c "import cv2; print(cv2.__version__)")
    if [ "$python_version" == "$OPENCV_VERSION" ]; then
        echo "Python bindings verification successful. (cv2.__version__: $python_version)"
    else
        echo "Error: Python bindings verification failed. Python module returned wrong version: $python_version" >&2
    fi
}

# --- Cleanup temporary files ---
cleanup() {
    echo "Cleaning up downloaded and extracted files..."
    cd /tmp
    rm -rf opencv opencv_contrib opencv.zip opencv_contrib.zip
}

main() {
    validate_args
    if [ "$COMPUTER_TYPE" == "gpu" ]; then
        check_gpu_dependencies
    fi

    if [ "$MODE" == "build" ]; then
        echo "--- Running in BUILD mode ---"
        install_build_dependencies
        install_runtime_dependencies
        download_opencv
        build_opencv
        create_environment_script
        verify_installation
        cleanup
        echo "--- OpenCV BUILD successful. Artifacts are in ${INSTALL_PATH} ---"

    elif [ "$MODE" == "runtime" ]; then
        echo "--- Running in RUNTIME mode ---"
        install_runtime_dependencies
        create_environment_script
        verify_installation
        echo "--- Runtime environment is ready. ---"
    fi
}

# --- Run the main function ---
main
