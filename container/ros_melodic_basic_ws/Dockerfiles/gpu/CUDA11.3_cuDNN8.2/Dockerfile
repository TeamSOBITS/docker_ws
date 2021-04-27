FROM sobits/ros_melodic_basic_ws:latest

LABEL maintainer Murakami Daiki

# Do NOT rewrite manually

# refference https://gitlab.com/nvidia/container-images/cuda/-/tree/master/dist/11.2.0/ubuntu18.04-x86_64

###################################
# Environment_variable_preference #
###################################
ENV CUDA_VERSION 11.3.0
ENV NCCL_VERSION 2.9.6
ENV CUDNN_VERSION 8.2.0.53
ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES compute,utility,graphics
ENV NVIDIA_REQUIRE_CUDA "cuda>=11.3 brand=tesla,driver>=418,driver<419 brand=tesla,driver>=440,driver<441 driver>=450"
ENV PATH /usr/local/nvidia/bin:/usr/local/cuda/bin:${PATH}
ENV LD_LIBRARY_PATH /usr/local/nvidia/lib:/usr/local/nvidia/lib64
ENV LIBRARY_PATH /usr/local/cuda/lib64/stubs


###################
# Graphic setting #
###################
RUN apt-get update && \
    apt-get install -y \
        pkg-config \
        libxau-dev \
        libxdmcp-dev \
        libxcb1-dev \
        libxext-dev \
        freeglut3-dev \
        libglew-dev \
        mesa-utils \
        x11-apps \
        libx11-dev && \
    rm -rf /var/lib/apt/lists/*

COPY --from=nvidia/opengl:1.0-glvnd-runtime-ubuntu16.04 \
  /usr/local/lib/x86_64-linux-gnu \
  /usr/local/lib/x86_64-linux-gnu

COPY --from=nvidia/opengl:1.0-glvnd-runtime-ubuntu16.04 \
  /usr/local/share/glvnd/egl_vendor.d/10_nvidia.json \
  /usr/local/share/glvnd/egl_vendor.d/10_nvidia.json

RUN echo '/usr/local/lib/x86_64-linux-gnu' >> /etc/ld.so.conf.d/glvnd.conf && \
    ldconfig && \
    echo '/usr/local/$LIB/libGL.so.1' >> /etc/ld.so.preload && \
    echo '/usr/local/$LIB/libEGL.so.1' >> /etc/ld.so.preload


#########################
# nvidia driver setting #
#########################
## base ##
RUN apt-get update && apt-get install -y --no-install-recommends \
    gnupg2 curl ca-certificates && \
    curl -fsSL https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/7fa2af80.pub | apt-key add - && \
    echo "deb https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64 /" > /etc/apt/sources.list.d/cuda.list && \
    echo "deb https://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1804/x86_64 /" > /etc/apt/sources.list.d/nvidia-ml.list && \
    apt-get purge --autoremove -y curl \
    && rm -rf /var/lib/apt/lists/*

# For libraries in the cuda-compat-* package: https://docs.nvidia.com/cuda/eula/index.html#attachment-a
RUN apt-get update && apt-get install -y --no-install-recommends \
    cuda-cudart-11-3=11.3.58-1 \
    cuda-compat-11-3 \
    && ln -s cuda-11.3 /usr/local/cuda && \
    rm -rf /var/lib/apt/lists/*

# Required for nvidia-docker v1
RUN echo "/usr/local/nvidia/lib" >> /etc/ld.so.conf.d/nvidia.conf \
    && echo "/usr/local/nvidia/lib64" >> /etc/ld.so.conf.d/nvidia.conf

## runtime ##
RUN apt-get update && apt-get install -y --no-install-recommends \
    cuda-libraries-11-3=11.3.0-1 \
    libnpp-11-3=11.3.3.44-1 \
    cuda-nvtx-11-3=11.3.58-1 \
    libcublas-11-3=11.4.2.10064-1 \
    libcusparse-11-3=11.5.0.58-1 \
    libnccl2=$NCCL_VERSION-1+cuda11.3 \
    && rm -rf /var/lib/apt/lists/*

# apt from auto upgrading the cublas package. See https://gitlab.com/nvidia/container-images/cuda/-/issues/88
RUN apt-mark hold libcublas-11-3 libnccl2


## devel ##
RUN apt-get update && apt-get install -y --no-install-recommends \
    cuda-cudart-dev-11-3=11.3.58-1 \
    cuda-command-line-tools-11-3=11.3.0-1 \
    cuda-minimal-build-11-3=11.3.0-1 \
    cuda-libraries-dev-11-3=11.3.0-1 \
    cuda-nvml-dev-11-3=11.3.58-1 \
    libnpp-dev-11-3=11.3.3.44-1 \
    libnccl-dev=2.9.6-1+cuda11.3 \
    libcublas-dev-11-3=11.4.2.10064-1 \
    libcusparse-dev-11-3=11.5.0.58-1 \
    && rm -rf /var/lib/apt/lists/*

# apt from auto upgrading the cublas package. See https://gitlab.com/nvidia/container-images/cuda/-/issues/88
RUN apt-mark hold libcublas-dev-11-3 libnccl-dev

## devel/cudnn8 ##
LABEL com.nvidia.cudnn.version="${CUDNN_VERSION}"

RUN apt-get update && apt-get install -y --no-install-recommends \
    libcudnn8=$CUDNN_VERSION-1+cuda11.3 \
    libcudnn8-dev=$CUDNN_VERSION-1+cuda11.3 \
    && apt-mark hold libcudnn8 && \
    rm -rf /var/lib/apt/lists/*

# clean cache
RUN apt-get clean &&\
	apt-get autoremove && \	
    rm -rf /var/lib/apt/lists/