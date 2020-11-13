FROM sobits/ros_melodic_vnc:latest

LABEL maintainer Tsurue Takumi

# Do NOT rewrite manually

# refference https://gitlab.com/nvidia/container-images/cuda/-/tree/master/dist/11.0/ubuntu18.04-x86_64

###################################
# Environment_variable_preference #
###################################
ENV CUDA_VERSION 11.0
ENV NCCL_VERSION 2.7.8
ENV CUDNN_VERSION 8.0.4.30
ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES compute,utility
ENV NVIDIA_REQUIRE_CUDA "cuda>=11.0 brand=tesla,driver>=418,driver<419 brand=tesla,driver>=440,driver<441"
ENV PATH /usr/local/nvidia/bin:/usr/local/cuda/bin:${PATH}
ENV LD_LIBRARY_PATH /usr/local/nvidia/lib:/usr/local/nvidia/lib64
ENV LIBRARY_PATH /usr/local/cuda/lib64/stubs

#########################
# nvidia driver setting #
#########################
## base ##
RUN apt-get update && apt-get install -y --no-install-recommends \
    gnupg2 curl ca-certificates && \
    curl -fsSL https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/7fa2af80.pub | apt-key add - && \
    echo "deb https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64 /" > /etc/apt/sources.list.d/cuda.list && \
    echo "deb https://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1804/x86_64 /" > /etc/apt/sources.list.d/nvidia-ml.list

# For libraries in the cuda-compat-* package: https://docs.nvidia.com/cuda/eula/index.html#attachment-a
RUN apt-get update && apt-get install -y --no-install-recommends \
    cuda-cudart-11-0=11.0.221-1 \
    cuda-compat-11-0 \
    && ln -s cuda-11.0 /usr/local/cuda

# Required for nvidia-docker v1
RUN echo "/usr/local/nvidia/lib" >> /etc/ld.so.conf.d/nvidia.conf && \
    echo "/usr/local/nvidia/lib64" >> /etc/ld.so.conf.d/nvidia.conf


## runtime ##
RUN apt-get update && apt-get install -y --no-install-recommends \
    cuda-libraries-11-0=11.0.3-1 \
    libnpp-11-0=11.1.0.245-1 \
    cuda-nvtx-11-0=11.0.167-1 \
    libcublas-11-0=11.2.0.252-1 \
    libnccl2=$NCCL_VERSION-1+cuda11.0 \
    && apt-mark hold libnccl2


## devel ##
RUN apt-get update && apt-get install -y --no-install-recommends \
    cuda-nvml-dev-11-0=11.0.167-1 \
    cuda-command-line-tools-11-0=11.0.3-1 \
    cuda-nvprof-11-0=11.0.221-1 \
    libnpp-dev-11-0=11.1.0.245-1 \
    cuda-libraries-dev-11-0=11.0.3-1 \
    cuda-minimal-build-11-0=11.0.3-1 \
    libnccl-dev=2.7.8-1+cuda11.0 \
    libcublas-dev-11-0=11.2.0.252-1 \
    libcusparse-11-0=11.1.1.245-1 \
    libcusparse-dev-11-0=11.1.1.245-1 \
    && apt-mark hold libnccl-dev

LABEL com.nvidia.cudnn.version="${CUDNN_VERSION}"

## devel/cudnn8 ##
RUN apt-get update && apt-get install -y --no-install-recommends \
    libcudnn8=$CUDNN_VERSION-1+cuda11.0 \
    libcudnn8-dev=$CUDNN_VERSION-1+cuda11.0 \
    && apt-mark hold libcudnn8



# clean cache
RUN apt-get clean &&\
	apt-get autoremove && \	
    rm -rf /var/lib/apt/lists/