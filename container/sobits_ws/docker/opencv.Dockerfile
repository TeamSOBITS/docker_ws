# syntax=docker/dockerfile:1

# =========================================================================================
#  ARGUMENTS
# =========================================================================================
ARG UBUNTU_VERSION=22.04
ARG CUDA_VERSION=12.1.0
ARG CV2_VERSION=4.9.0
ARG COMPUTE_TYPE=cpu # Can be 'cpu' or 'gpu'

# =========================================================================================
#  Stage 1: Builder
#  This stage has all build tools and compiles OpenCV from source.
# =========================================================================================
FROM ubuntu:${UBUNTU_VERSION} AS base-cpu
FROM nvidia/cuda:${CUDA_VERSION}-cudnn-devel-ubuntu${UBUNTU_VERSION} AS base-gpu

# Select the base image based on the COMPUTE_TYPE argument
FROM base-${COMPUTE_TYPE} AS opencv-builder

ARG CV2_VERSION
ARG COMPUTE_TYPE

# Prevent interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ="Asia/Tokyo"

COPY install_sh/install_opencv.sh /tmp/install_opencv.sh

# Install common dependencies, create user, etc.
RUN apt-get update && apt-get install -y --no-install-recommends \
        software-properties-common sudo && \
    chmod +x /tmp/install_opencv.sh && \
    /tmp/install_opencv.sh ${COMPUTE_TYPE} ${CV2_VERSION}


# Set OpenCV environment variables
ENV OPENCV_DIR="/tmp/opencv_pkg_install"
ENV LD_LIBRARY_PATH="${OPENCV_DIR}/lib:${LD_LIBRARY_PATH}"
ENV PKG_CONFIG_PATH="${OPENCV_DIR}/lib/pkgconfig:${PKG_CONFIG_PATH}"
ENV PYTHONPATH="${OPENCV_DIR}/lib/${PYTHON_VERSION_DIR}/dist-packages:${PYTHONPATH}"
