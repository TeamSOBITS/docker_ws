FROM ubuntu:20.04
LABEL maintainer Valentin Keith


RUN echo "╔══╣ Install: base_ws:gpu_cuda12.2.2_cudnn8.9_ubuntu2004 (STARTING) ╠══╗"


###################################
# Environment_variable_preference #
###################################
ENV USER_ID=${LOCAL_UID:-1000}
ENV GROUP_ID=${LOCAL_GID:-1000}
ENV DEBCONF_NOWARNINGS yes
ENV DEBIAN_FRONTEND=noninteractive
ARG GIT_PSW


######################
# Install basic apps #
######################
# avoid time-zone setting
RUN echo 'Asia/Tokyo' > /etc/timezone && \
    ln -s /usr/share/zoneinfo/Asia/Tokyo /etc/localtime && \
    apt-get update && \
    apt-get install -yq --no-install-recommends tzdata && \
    rm -rf /var/lib/apt/lists/*

RUN apt-get update && \
    apt-get install -yq \
        software-properties-common \
        bash-completion \
        lsb-release \
        dpkg-dev \
        pkg-config \
        net-tools \
        usbutils \
        libusb-1.0-0-dev \
        libudev-dev \
        iputils-ping \
        # alsa-utils \
        uuid-dev \
        locales \
        fonts-takao-* \
        sudo \
        git-all \
        wget \
        curl \
        nano \
        gedit


###################
# Add SOBITS user #
###################
# add sudo user
RUN useradd --create-home --home-dir /home/sobits --shell /bin/bash --user-group --groups adm,sudo -u ${USER_ID} sobits && \
    groupmod -g ${GROUP_ID} -o sobits && \
    echo sobits:robotgroup | chpasswd && \
    echo "sobits ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Set user
ENV USER sobits

# Set HOME position
ENV HOMEPATH /home/sobits
WORKDIR $HOMEPATH
RUN . $HOMEPATH/.bashrc


###############################
# Install CUDA12.2.2_cuDNN8.9 #
###############################
# Run as root user
USER root

# Reference 1: https://gitlab.com/nvidia/container-images/cuda/-/blob/master/dist/12.2.2/ubuntu2004/base/Dockerfile
ENV NVARCH x86_64

ENV NVIDIA_REQUIRE_CUDA "cuda>=12.2 brand=tesla,driver>=470,driver<471 brand=unknown,driver>=470,driver<471 brand=nvidia,driver>=470,driver<471 brand=nvidiartx,driver>=470,driver<471 brand=geforce,driver>=470,driver<471 brand=geforcertx,driver>=470,driver<471 brand=quadro,driver>=470,driver<471 brand=quadrortx,driver>=470,driver<471 brand=titan,driver>=470,driver<471 brand=titanrtx,driver>=470,driver<471 brand=tesla,driver>=525,driver<526 brand=unknown,driver>=525,driver<526 brand=nvidia,driver>=525,driver<526 brand=nvidiartx,driver>=525,driver<526 brand=geforce,driver>=525,driver<526 brand=geforcertx,driver>=525,driver<526 brand=quadro,driver>=525,driver<526 brand=quadrortx,driver>=525,driver<526 brand=titan,driver>=525,driver<526 brand=titanrtx,driver>=525,driver<526"
ENV NV_CUDA_CUDART_VERSION 12.2.140-1
ENV NV_CUDA_COMPAT_PACKAGE cuda-compat-12-2

RUN apt-get update && apt-get install -y --no-install-recommends \
    gnupg2 curl ca-certificates && \
    curl -fsSL https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/${NVARCH}/3bf863cc.pub | apt-key add - && \
    echo "deb https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/${NVARCH} /" > /etc/apt/sources.list.d/cuda.list && \
    rm -rf /var/lib/apt/lists/*

ENV CUDA_VERSION 12.2.2

# For libraries in the cuda-compat-* package: https://docs.nvidia.com/cuda/eula/index.html#attachment-a
RUN apt-get update && apt-get install -y --no-install-recommends \
    cuda-cudart-12-2=${NV_CUDA_CUDART_VERSION} \
    ${NV_CUDA_COMPAT_PACKAGE} \
    && rm -rf /var/lib/apt/lists/*

# Required for nvidia-docker v1
RUN echo "/usr/local/nvidia/lib" >> /etc/ld.so.conf.d/nvidia.conf \
    && echo "/usr/local/nvidia/lib64" >> /etc/ld.so.conf.d/nvidia.conf

ENV PATH /usr/local/nvidia/bin:/usr/local/cuda/bin:${PATH}
ENV LD_LIBRARY_PATH /usr/local/nvidia/lib:/usr/local/nvidia/lib64

# nvidia-container-runtime
ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES compute,utility


# Reference 2: https://gitlab.com/nvidia/container-images/cuda/-/tree/master/dist/12.2.2/ubuntu2004/runtime/Dockerfile
ENV NV_CUDA_LIB_VERSION 12.2.2-1

ENV NV_NVTX_VERSION 12.2.140-1
ENV NV_LIBNPP_VERSION 12.2.1.4-1
ENV NV_LIBNPP_PACKAGE libnpp-12-2=${NV_LIBNPP_VERSION}
ENV NV_LIBCUSPARSE_VERSION 12.1.2.141-1

ENV NV_LIBCUBLAS_PACKAGE_NAME libcublas-12-2
ENV NV_LIBCUBLAS_VERSION 12.2.5.6-1
ENV NV_LIBCUBLAS_PACKAGE ${NV_LIBCUBLAS_PACKAGE_NAME}=${NV_LIBCUBLAS_VERSION}

ENV NV_LIBNCCL_PACKAGE_NAME libnccl2
ENV NV_LIBNCCL_PACKAGE_VERSION 2.19.3-1
ENV NCCL_VERSION 2.19.3-1
ENV NV_LIBNCCL_PACKAGE ${NV_LIBNCCL_PACKAGE_NAME}=${NV_LIBNCCL_PACKAGE_VERSION}+cuda12.2

RUN apt-get update && apt-get install -y --no-install-recommends \
    cuda-libraries-12-2=${NV_CUDA_LIB_VERSION} \
    ${NV_LIBNPP_PACKAGE} \
    cuda-nvtx-12-2=${NV_NVTX_VERSION} \
    libcusparse-12-2=${NV_LIBCUSPARSE_VERSION} \
    ${NV_LIBCUBLAS_PACKAGE} \
    ${NV_LIBNCCL_PACKAGE} \
    && rm -rf /var/lib/apt/lists/*

# Keep apt from auto upgrading the cublas and nccl packages. See https://gitlab.com/nvidia/container-images/cuda/-/issues/88
RUN apt-mark hold ${NV_LIBCUBLAS_PACKAGE_NAME} ${NV_LIBNCCL_PACKAGE_NAME}


# Reference 3: https://gitlab.com/nvidia/container-images/cuda/-/blob/master/dist/12.2.2/ubuntu2004/devel/Dockerfile
ENV NV_CUDA_LIB_VERSION "12.2.2-1"

ENV NV_CUDA_CUDART_DEV_VERSION 12.2.140-1
ENV NV_NVML_DEV_VERSION 12.2.140-1
ENV NV_LIBCUSPARSE_DEV_VERSION 12.1.2.141-1
ENV NV_LIBNPP_DEV_VERSION 12.2.1.4-1
ENV NV_LIBNPP_DEV_PACKAGE libnpp-dev-12-2=${NV_LIBNPP_DEV_VERSION}

ENV NV_LIBCUBLAS_DEV_VERSION 12.2.5.6-1
ENV NV_LIBCUBLAS_DEV_PACKAGE_NAME libcublas-dev-12-2
ENV NV_LIBCUBLAS_DEV_PACKAGE ${NV_LIBCUBLAS_DEV_PACKAGE_NAME}=${NV_LIBCUBLAS_DEV_VERSION}

ENV NV_CUDA_NSIGHT_COMPUTE_VERSION 12.2.2-1
ENV NV_CUDA_NSIGHT_COMPUTE_DEV_PACKAGE cuda-nsight-compute-12-2=${NV_CUDA_NSIGHT_COMPUTE_VERSION}

ENV NV_NVPROF_VERSION 12.2.142-1
ENV NV_NVPROF_DEV_PACKAGE cuda-nvprof-12-2=${NV_NVPROF_VERSION}

ENV NV_LIBNCCL_DEV_PACKAGE_NAME libnccl-dev
ENV NV_LIBNCCL_DEV_PACKAGE_VERSION 2.19.3-1
ENV NCCL_VERSION 2.19.3-1
ENV NV_LIBNCCL_DEV_PACKAGE ${NV_LIBNCCL_DEV_PACKAGE_NAME}=${NV_LIBNCCL_DEV_PACKAGE_VERSION}+cuda12.2

RUN apt-get update && apt-get install -y --no-install-recommends \
    libtinfo5 libncursesw5 \
    cuda-cudart-dev-12-2=${NV_CUDA_CUDART_DEV_VERSION} \
    cuda-command-line-tools-12-2=${NV_CUDA_LIB_VERSION} \
    cuda-minimal-build-12-2=${NV_CUDA_LIB_VERSION} \
    cuda-libraries-dev-12-2=${NV_CUDA_LIB_VERSION} \
    cuda-nvml-dev-12-2=${NV_NVML_DEV_VERSION} \
    ${NV_NVPROF_DEV_PACKAGE} \
    ${NV_LIBNPP_DEV_PACKAGE} \
    libcusparse-dev-12-2=${NV_LIBCUSPARSE_DEV_VERSION} \
    ${NV_LIBCUBLAS_DEV_PACKAGE} \
    ${NV_LIBNCCL_DEV_PACKAGE} \
    ${NV_CUDA_NSIGHT_COMPUTE_DEV_PACKAGE} \
    && rm -rf /var/lib/apt/lists/*

# Keep apt from auto upgrading the cublas and nccl packages. See https://gitlab.com/nvidia/container-images/cuda/-/issues/88
RUN apt-mark hold ${NV_LIBCUBLAS_DEV_PACKAGE_NAME} ${NV_LIBNCCL_DEV_PACKAGE_NAME}
ENV LIBRARY_PATH /usr/local/cuda/lib64/stubs


# Reference 4: https://gitlab.com/nvidia/container-images/cuda/-/blob/master/dist/12.2.2/ubuntu2004/devel/cudnn8/Dockerfile
ENV NV_CUDNN_VERSION 8.9.6.50
ENV NV_CUDNN_PACKAGE_NAME "libcudnn8"

ENV NV_CUDNN_PACKAGE "libcudnn8=$NV_CUDNN_VERSION-1+cuda12.2"
ENV NV_CUDNN_PACKAGE_DEV "libcudnn8-dev=$NV_CUDNN_VERSION-1+cuda12.2"

RUN apt-get update && apt-get install -y --no-install-recommends \
    ${NV_CUDNN_PACKAGE} \
    ${NV_CUDNN_PACKAGE_DEV} \
    && apt-mark hold ${NV_CUDNN_PACKAGE_NAME} \
    && rm -rf /var/lib/apt/lists/*


RUN echo 'export PATH=/usr/local/cuda-12.2/bin${PATH:+:${PATH}}' >> $HOMEPATH/.bashrc && \
    echo 'export LD_LIBRARY_PATH=/usr/local/cuda-12.2/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}' >> $HOMEPATH/.bashrc


###############
# Install pip #
###############
# Run as root user
USER root

RUN apt-get update && \
    apt-get install -yq \
        python3 \
        python3-dev \
        python3-pip

# Run as user sobits
USER sobits

# install pip
RUN python3 -m pip install -U \
        pip \
        wheel


##############################
# Install OpenCV 4.9.0 (GPU) #
##############################
# Run as sobits user
USER sobits

# Clone only installation_sh from SOBITS Manual
RUN cd $HOMEPATH && \
    curl https://${GIT_PSW}@raw.githubusercontent.com/TeamSOBITS/sobits_manual/main/install_sh/install_opencv.sh -o install_opencv.sh

RUN bash $HOMEPATH/install_opencv.sh --4.9.0 --GPU

RUN rm $HOMEPATH/install_opencv.sh


##################
# Other settings #
##################
# Run as root user
USER root

# Set time zone (Tokyo)
ENV TZ Asia/Tokyo

# Set Language
RUN locale-gen ja_JP.UTF-8
ENV LANG ja_JP.UTF-8
ENV LANGUAGE ja_JP:ja
ENV LC_ALL ja_JP.UTF-8

# Clean cache
RUN apt-get clean &&\
	apt-get autoremove && \	
    rm -rf /var/lib/apt/lists/ && \
    rm /etc/apt/apt.conf.d/docker-clean

# Set user
ENV USER sobits

# Set HOME position
WORKDIR /home/sobits/


RUN echo "╚══╣ Install: base_ws:gpu_cuda12.2.2_cudnn8.9_ubuntu2004 (FINISHED) ╠══╝"