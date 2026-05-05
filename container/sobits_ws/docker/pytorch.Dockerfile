# syntax=docker/dockerfile:1

# =========================================================================================
#  ARGUMENTS
# =========================================================================================
ARG UBUNTU_VERSION=24.04
ARG CUDA_VERSION=13.2.1
ARG PYTORCH_VERSION=2.11.0
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
        python3 \
    && rm -rf /var/lib/apt/lists/*

# Install uv CLI tool for enhanced command execution
COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

# Create a Python virtual environment using uv
RUN uv venv --system-site-packages

# Install common dependencies, create user, etc.
RUN echo "Installing PyTorch ${PYTORCH_VERSION}..." >&2; \
    # Check Ubuntu version to determine pip installation method
    UBUNTU_MAJOR=$(echo ${UBUNTU_VERSION} | cut -d. -f1); \
    # Map CUDA version to the nearest PyTorch wheel tag (PyTorch only publishes
    # wheels for specific CUDA releases, not every patch/minor version).
    CUDA_TAG="cpu"; \
    if [ ${COMPUTE_TYPE} = "gpu" ] && echo ${CUDA_VERSION} | grep -qE '^[0-9]+'; then \
        CUDA_MAJOR=$(echo ${CUDA_VERSION} | cut -d. -f1); \
        CUDA_MINOR=$(echo ${CUDA_VERSION} | cut -d. -f2); \
        if [ "${CUDA_MAJOR}" -ge 13 ]; then CUDA_TAG="cu130"; \
        elif [ "${CUDA_MAJOR}" = "12" ]; then \
            if   [ "${CUDA_MINOR}" -ge 8 ]; then CUDA_TAG="cu128"; \
            elif [ "${CUDA_MINOR}" -ge 6 ]; then CUDA_TAG="cu126"; \
            elif [ "${CUDA_MINOR}" -ge 4 ]; then CUDA_TAG="cu124"; \
            else CUDA_TAG="cu121"; fi; \
        else CUDA_TAG="cu${CUDA_MAJOR}${CUDA_MINOR}"; fi; \
        echo "CUDA Tag detected: ${CUDA_TAG}" >&2; \
    fi; \
    echo "Installing PyTorch with CUDA tag: ${CUDA_TAG}" >&2; \
    uv pip install -U --no-cache-dir torch==${PYTORCH_VERSION} torchvision torchaudio --index-url https://download.pytorch.org/whl/${CUDA_TAG}; \
