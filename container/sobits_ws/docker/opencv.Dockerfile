# syntax=docker/dockerfile:1

# =========================================================================================
#  ARGUMENTS
# =========================================================================================
ARG UBUNTU_VERSION=24.04
ARG CUDA_VERSION=13.1.1
ARG CV2_VERSION=4.13.0
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
    /tmp/install_opencv.sh build ${COMPUTE_TYPE} ${CV2_VERSION}
