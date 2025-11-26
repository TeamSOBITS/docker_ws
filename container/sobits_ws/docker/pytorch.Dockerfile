# syntax=docker/dockerfile:1

# =========================================================================================
#  ARGUMENTS
# =========================================================================================
ARG UBUNTU_VERSION=22.04
ARG CUDA_VERSION=12.8.0
ARG PYTORCH_VERSION=2.9.0
ARG COMPUTE_TYPE=cpu # Can be 'cpu' or 'gpu'

# =========================================================================================
#  Stage 1: Builder
#  This stage builds PyTorch and installs it in a virtual environment.
# =========================================================================================
FROM ubuntu:${UBUNTU_VERSION} AS base-cpu
FROM nvidia/cuda:${CUDA_VERSION}-cudnn-devel-ubuntu${UBUNTU_VERSION} AS base-gpu

# Select the base image based on the COMPUTE_TYPE argument
FROM base-${COMPUTE_TYPE} AS pytorch-builder

ARG PYTORCH_VERSION
ARG COMPUTE_TYPE

# Prevent interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ="Asia/Tokyo"

WORKDIR /opt/pytorch

# Install common dependencies, create user, etc.
RUN apt-get update && apt-get install -y --no-install-recommends \
        python3 python3-pip python3-venv python3-dev \
    && rm -rf /var/lib/apt/lists/*

# Install uv CLI tool for enhanced command execution
COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

# Create a Python virtual environment using uv
RUN uv venv --system-site-packages

# Install common dependencies, create user, etc.
RUN echo "Installing PyTorch ${PYTORCH_VERSION}..." >&2; \
    # Check Ubuntu version to determine pip installation method
    UBUNTU_MAJOR=$(echo ${UBUNTU_VERSION} | cut -d. -f1); \
    # Determine CUDA tag for PyTorch installation
    CUDA_TAG="cpu"; \
    if [ ${COMPUTE_TYPE} = "gpu" ] && echo ${CUDA_VERSION} | grep -qE '^[0-9]+'; then \
        CUDA_MAJOR=$(echo ${CUDA_VERSION} | cut -d. -f1); \
        CUDA_MINOR=$(echo ${CUDA_VERSION} | cut -d. -f2); \
        CUDA_TAG="cu${CUDA_MAJOR}${CUDA_MINOR}"; \
        echo "CUDA Tag detected: ${CUDA_TAG}" >&2; \
    fi; \
    echo "Installing PyTorch with CUDA tag: ${CUDA_TAG}" >&2; \
    uv pip install -U --no-cache-dir torch==${PYTORCH_VERSION} torchvision torchaudio --index-url https://download.pytorch.org/whl/${CUDA_TAG}; \
    uv pip uninstall numpy;