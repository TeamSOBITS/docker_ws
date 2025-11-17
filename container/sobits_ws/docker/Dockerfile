# =========================================================================================
#  ARGUMENTS - Define all build arguments at the top
# =========================================================================================
ARG UBUNTU_VERSION=22.04
ARG COMPUTE_TYPE=cpu # Can be 'cpu' or 'gpu'
ARG CUDA_VERSION=12.8.1
ARG CV2_VERSION=4.12.0
ARG PYTORCH_VERSION=2.9.0
ARG CV_IMAGE_TAG=sobits/opencv:${CV2_VERSION}-${COMPUTE_TYPE}-ubuntu${UBUNTU_VERSION}
ARG PYTORCH_IMAGE_TAG=sobits/pytorch:${PYTORCH_VERSION}-cuda${CUDA_VERSION%.*}-ubuntu${UBUNTU_VERSION}
ARG OPENCV_BASE_STAGE=base
ARG PYTORCH_BASE_STAGE=base
ARG FINAL_STAGE=base

# =========================================================================================
#  STAGE 1: Common Base
#  This stage contains everything that is common to both build types.
# =========================================================================================
FROM ubuntu:${UBUNTU_VERSION} AS base-cpu
FROM nvidia/cuda:${CUDA_VERSION}-cudnn-devel-ubuntu${UBUNTU_VERSION} AS base-gpu
FROM base-${COMPUTE_TYPE} AS base

ARG LOCAL_UID=1000
ARG LOCAL_GID=1000
ARG USERNAME=sobits
ARG CONTAINER_NAME=sobits_ws

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ="Asia/Tokyo"
ENV LANG=ja_JP.UTF-8

# Install common dependencies, create user, etc.
RUN apt-get update && apt-get install -y --no-install-recommends \
        tzdata language-pack-ja fonts-ipafont software-properties-common \
        sudo git-all wget curl nano gedit \
        bash-completion lsb-release dpkg-dev pkg-config net-tools iputils-ping \
        usbutils libusb-1.0-0-dev libudev-dev uuid-dev \
        python3-full python3-pip python3-venv python3-dev \
    && rm -rf /var/lib/apt/lists/*

# Add user
RUN echo "Creating user '${USERNAME}' with UID:${LOCAL_UID} and GID:${LOCAL_GID}" 

RUN if id -u ${LOCAL_UID} >/dev/null 2>&1; then \
        EXISTING_USER=$(id -nu ${LOCAL_UID}); \
        userdel -r ${EXISTING_USER} 2>/dev/null || true; \
    fi && \
    useradd --create-home --home-dir /home/${USERNAME} --shell /bin/bash --user-group -u ${LOCAL_UID} ${USERNAME} && \
    groupmod -g ${LOCAL_GID} -o ${USERNAME} && \
    echo "${USERNAME} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

USER ${USERNAME}
# User specific environment variables
RUN echo "export PYTHONDONTWRITEBYTECODE=1" >> /home/${USERNAME}/.bash_aliases && \
    echo "export PS1='\[\e[1;33;40m\]${CONTAINER_NAME}\[\e[0m\] \${debian_chroot:+(\${debian_chroot})}\[\033[01;32m\]\u@\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '" >> /home/${USERNAME}/.bash_aliases

# =========================================================================================
#  PREBUILD STAGE: Reference Prebuilt Images
# =========================================================================================
FROM ${CV_IMAGE_TAG} AS opencv_prebuilt
FROM ${PYTORCH_IMAGE_TAG} AS pytorch_prebuilt

# =========================================================================================
#  FINAL STAGE 1: Application WITH ROS
# =========================================================================================
FROM base AS base_with_ros
ARG INSTALL_GAZEBO=false
ARG ROS_DISTRO=humble
ARG ROS_DOMAIN_ID=0

# Run as root for ROS installation
USER root

# Set ROS_DISTRO environment variable and install ROS only if ROS will be installed
RUN echo "Installing ROS ${ROS_DISTRO}..."; \
    echo "export ROS_DISTRO=${ROS_DISTRO}" >> /etc/environment; \
    apt-get update && apt-get install -yq \
        gnupg && \
    curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg && \
    . /etc/os-release && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu ${UBUNTU_CODENAME} main" | tee /etc/apt/sources.list.d/ros2.list > /dev/null && \
    apt-get update -q && \
    apt-get install -yq \
        ros-${ROS_DISTRO}-desktop \
        ros-dev-tools && \
    if [ ${INSTALL_GAZEBO} = "true" ]; then \
        echo "Installing Gazebo for ROS ${ROS_DISTRO}..."; \
        apt-get install -yq \
            ros-${ROS_DISTRO}-simulation; \
    fi; \
    rosdep init;

USER ${USERNAME}
# Configure ROS environment
RUN rosdep update && \
    mkdir -p ~/colcon_ws/src && \
    echo "source /opt/ros/${ROS_DISTRO}/setup.bash" >> ~/.bashrc && \
    echo "source ~/colcon_ws/install/setup.bash"  >> ~/.bashrc && \
    echo "export ROS_DOMAIN_ID=${ROS_DOMAIN_ID}" >> ~/.bashrc && \
    echo "source /usr/share/colcon_argcomplete/hook/colcon-argcomplete.bash" >> ~/.bashrc && \
    # Create bash aliases
    echo "alias cb='CURRENT_DIR=\`pwd\` && cd ~/colcon_ws/ && colcon build --symlink-install && source ~/.bashrc && cd \${CURRENT_DIR}'" >> /home/${USERNAME}/.bash_aliases && \
    echo "" >> /home/${USERNAME}/.bash_aliases;

# =========================================================================================
#  FINAL STAGE 2: Application WITH PyTorch
# =========================================================================================
FROM ${PYTORCH_BASE_STAGE} AS base_with_pytorch
COPY --from=pytorch_prebuilt /opt/pytorch/ /opt/pytorch/
RUN echo "export PATH=/opt/pytorch/.venv/bin:\$PATH" >> /home/${USERNAME}/.bashrc

# =========================================================================================
#  FINAL STAGE 3: Application WITH OpenCV
# =========================================================================================
FROM ${OPENCV_BASE_STAGE} AS base_with_opencv
ARG COMPUTE_TYPE=cpu # Can be 'cpu' or 'gpu'
ARG CV2_VERSION=4.12.0

# First, bring in the pre-built OpenCV files from our reference stage
COPY --from=opencv_prebuilt /tmp/opencv_pkg_install/ /tmp/opencv_pkg_install
COPY install_sh/install_opencv.sh /tmp/install_opencv.sh

RUN bash /tmp/install_opencv.sh runtime ${COMPUTE_TYPE} ${CV2_VERSION}

FROM ${FINAL_STAGE} AS final
ARG INSTALL_PYTORCH=true
ARG INSTALL_CV2=true
USER root
RUN ldconfig

RUN if [ "${INSTALL_PYTORCH}" = "true" ] && [ "${INSTALL_CV2}" = "true" ]; then \
        echo "Avoid conflicts between PyTorch and OpenCV prebuilt images."; \
        rm -rf /opt/pytorch/.venv/lib/python3.10/site-packages/numpy*; \
    fi;

# Clean cache
RUN apt-get clean &&\
	apt-get autoremove && \	
    rm -rf /var/lib/apt/lists/* && \
    if [ -f /etc/apt/apt.conf.d/docker-clean ]; then \
        rm -rf /etc/apt/apt.conf.d/docker-clean; \
    fi;

# Switch back to the user
USER ${USERNAME}
WORKDIR /home/${USERNAME}
