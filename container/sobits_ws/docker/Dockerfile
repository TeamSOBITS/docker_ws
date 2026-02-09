# =========================================================================================
#  ARGUMENTS - Define all build arguments at the top
# =========================================================================================
ARG UBUNTU_VERSION=22.04
ARG COMPUTE_TYPE=cpu # Can be 'cpu' or 'gpu'
ARG CUDA_VERSION=12.8.1
ARG CV2_VERSION=4.12.0
ARG PYTORCH_VERSION=2.9.0
ARG ROS_DISTRO=humble
ARG CV_IMAGE_TAG=sobits/opencv:${CV2_VERSION}-${COMPUTE_TYPE}-ubuntu${UBUNTU_VERSION}
ARG PYTORCH_IMAGE_TAG=sobits/pytorch:${PYTORCH_VERSION}-cuda${CUDA_VERSION%.*}-ubuntu${UBUNTU_VERSION}
ARG ROS_IMAGE_TAG=ros:${ROS_DISTRO}
ARG OPENCV_BASE_STAGE=base
ARG PYTORCH_BASE_STAGE=base
ARG ROS_BASE_STAGE=base
ARG FINAL_STAGE=base

# =========================================================================================
#  BASE STAGE : Common Base
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
        python3 python3-pip python3-venv python3-dev \
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
FROM ${ROS_IMAGE_TAG} AS ros_prebuilt
FROM ${CV_IMAGE_TAG} AS opencv_prebuilt
FROM ${PYTORCH_IMAGE_TAG} AS pytorch_prebuilt

# =========================================================================================
#  PYTORCH STAGE : Application WITH PyTorch
# =========================================================================================
FROM ${PYTORCH_BASE_STAGE} AS base_with_pytorch
ARG UBUNTU_VERSION=22.04
COPY --from=pytorch_prebuilt /opt/pytorch/ /opt/pytorch/
RUN if [ "${UBUNTU_VERSION}" = "22.04" ]; then \
    echo "export PYTHONPATH=/opt/pytorch/.venv/lib/python3.10/site-packages:\$PYTHONPATH" >> /home/${USERNAME}/.bashrc; \
    elif [ "${UBUNTU_VERSION}" = "24.04" ]; then \
    echo "export PYTHONPATH=/opt/pytorch/.venv/lib/python3.12/site-packages:\$PYTHONPATH" >> /home/${USERNAME}/.bashrc; \
    fi;
    
# =========================================================================================
#  OPENCV STAGE : Application WITH OpenCV
# =========================================================================================
FROM ${OPENCV_BASE_STAGE} AS base_with_opencv
ARG COMPUTE_TYPE=cpu # Can be 'cpu' or 'gpu'
ARG CV2_VERSION=4.12.0

# First, bring in the pre-built OpenCV files from our reference stage
COPY --from=opencv_prebuilt /tmp/opencv_pkg_install/ /tmp/opencv_pkg_install
COPY install_sh/install_opencv.sh /tmp/install_opencv.sh

RUN bash /tmp/install_opencv.sh runtime ${COMPUTE_TYPE} ${CV2_VERSION}

# =========================================================================================
#  ROS STAGE: Application WITH ROS
# =========================================================================================
FROM ${ROS_BASE_STAGE} AS base_with_ros
ARG USERNAME=sobits
ARG ROS_DISTRO=humble
ARG ROS_DOMAIN_ID=0
ARG INSTALL_GAZEBO=true
ARG ROS_WORKSPACE=colcon_ws

COPY --from=ros_prebuilt /etc/apt/sources.list.d/ros* /etc/apt/sources.list.d/
COPY --from=ros_prebuilt /usr/share/keyrings/ros* /usr/share/keyrings/
COPY ros_entrypoint.sh /home/${USERNAME}/ros_entrypoint.sh

USER root
# Configure ROS environment
RUN apt-get update && apt-get install -y \
        ros-${ROS_DISTRO}-desktop \
        ros-dev-tools && \
    rosdep init

# Install Gazebo if specified
RUN if [ "${INSTALL_GAZEBO}" = "true" ]; then \
        apt-get install -y ros-${ROS_DISTRO}-simulation; \
    fi

USER ${USERNAME}
RUN rosdep update && \
    mkdir -p ~/${ROS_WORKSPACE}/src && \
    echo "source ~/ros_entrypoint.sh" >> /home/${USERNAME}/.bashrc

# =========================================================================================
#  FINAL STAGE : Cleanup and Final Setup
# =========================================================================================
FROM ${FINAL_STAGE} AS final
USER root
RUN ldconfig

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
