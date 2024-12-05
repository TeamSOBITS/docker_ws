FROM ubuntu:22.04
LABEL maintainer="Valentin Keith"


RUN echo "╔══╣ Install: base_ws:gpu_cuda12.5.1_cudnn9.2_ubuntu2204 (STARTING) ╠══╗"


###################################
# Environment variable preference #
###################################
ARG GIT_PSW
ARG LOCAL_UID
ARG LOCAL_GID

ENV USER_NAME=sobits
ENV USER_ID=${LOCAL_UID:-1000}
ENV GROUP_ID=${LOCAL_GID:-1000}

ENV HOMEPATH=/home/sobits

ENV DEBCONF_NOWARNINGS=yes
ENV DEBIAN_FRONTEND=noninteractive


######################
# Install basic apps #
######################
# Time-zone setting
RUN apt-get update && \
    apt-get install -yq \
        tzdata

ENV TZ="Asia/Tokyo"

# Set Language
RUN apt-get update && \
    apt-get install -yq \
        locales \
        locales-all && \
    sed -i '/ja_JP.UTF-8/s/^# //g' /etc/locale.gen
    
RUN locale-gen ja_JP.UTF-8

ENV LANG=ja_JP.UTF-8
ENV LANGUAGE=ja_JP:ja
ENV LC_ALL=ja_JP.UTF-8

# Install basic apps
RUN apt-get update && \
    apt-get install -yq \
        language-pack-ja \
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
        pipewire-audio-client-libraries \
        libspa-0.2-bluetooth \
        libspa-0.2-jack \
        alsa-utils \
        apulse \
        uuid-dev \
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
# Add sudo user
RUN useradd --create-home --home-dir ${HOMEPATH} --shell /bin/bash --user-group --groups adm,sudo,audio,video -u ${USER_ID} ${USER_NAME} && \
    groupmod -g ${GROUP_ID} -o ${USER_NAME} && \
    echo ${USER_NAME}:robotgroup | chpasswd && \
    echo "${USER_NAME} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Set user
ENV USER=${USER_NAME}

# Set HOME position
WORKDIR $HOMEPATH
RUN . $HOMEPATH/.bashrc


###############################
# Install CUDA12.5.1_cuDNN9.2 #
###############################
# Run as root user
USER root

# Reference 1: https://gitlab.com/nvidia/container-images/cuda/-/blob/master/dist/12.5.1/ubuntu2204/base/Dockerfile
ENV NVARCH x86_64

ENV NVIDIA_REQUIRE_CUDA "cuda>=12.5 brand=unknown,driver>=470,driver<471 brand=grid,driver>=470,driver<471 brand=tesla,driver>=470,driver<471 brand=nvidia,driver>=470,driver<471 brand=quadro,driver>=470,driver<471 brand=quadrortx,driver>=470,driver<471 brand=nvidiartx,driver>=470,driver<471 brand=vapps,driver>=470,driver<471 brand=vpc,driver>=470,driver<471 brand=vcs,driver>=470,driver<471 brand=vws,driver>=470,driver<471 brand=cloudgaming,driver>=470,driver<471 brand=unknown,driver>=535,driver<536 brand=grid,driver>=535,driver<536 brand=tesla,driver>=535,driver<536 brand=nvidia,driver>=535,driver<536 brand=quadro,driver>=535,driver<536 brand=quadrortx,driver>=535,driver<536 brand=nvidiartx,driver>=535,driver<536 brand=vapps,driver>=535,driver<536 brand=vpc,driver>=535,driver<536 brand=vcs,driver>=535,driver<536 brand=vws,driver>=535,driver<536 brand=cloudgaming,driver>=535,driver<536 brand=unknown,driver>=550,driver<551 brand=grid,driver>=550,driver<551 brand=tesla,driver>=550,driver<551 brand=nvidia,driver>=550,driver<551 brand=quadro,driver>=550,driver<551 brand=quadrortx,driver>=550,driver<551 brand=nvidiartx,driver>=550,driver<551 brand=vapps,driver>=550,driver<551 brand=vpc,driver>=550,driver<551 brand=vcs,driver>=550,driver<551 brand=vws,driver>=550,driver<551 brand=cloudgaming,driver>=550,driver<551"
ENV NV_CUDA_CUDART_VERSION 12.5.82-1

RUN apt-get update && apt-get install -y --no-install-recommends \
    gnupg2 curl ca-certificates && \
    curl -fsSLO https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/${NVARCH}/cuda-keyring_1.1-1_all.deb && \
    dpkg -i cuda-keyring_1.1-1_all.deb && \
    rm -rf /var/lib/apt/lists/*

ENV CUDA_VERSION 12.5.1

# For libraries in the cuda-compat-* package: https://docs.nvidia.com/cuda/eula/index.html#attachment-a
RUN apt-get update && apt-get install -y --no-install-recommends \
    cuda-cudart-12-5=${NV_CUDA_CUDART_VERSION} \
    cuda-compat-12-5 \
    && rm -rf /var/lib/apt/lists/*

# Required for nvidia-docker v1
RUN echo "/usr/local/nvidia/lib" >> /etc/ld.so.conf.d/nvidia.conf \
    && echo "/usr/local/nvidia/lib64" >> /etc/ld.so.conf.d/nvidia.conf

ENV PATH /usr/local/nvidia/bin:/usr/local/cuda/bin:${PATH}
ENV LD_LIBRARY_PATH /usr/local/nvidia/lib:/usr/local/nvidia/lib64

# nvidia-container-runtime
ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES compute,utility


# Reference 2: https://gitlab.com/nvidia/container-images/cuda/-/blob/master/dist/12.5.1/ubuntu2204/runtime/Dockerfile
ENV NV_CUDA_LIB_VERSION 12.5.1-1

ENV NV_NVTX_VERSION 12.5.82-1
ENV NV_LIBNPP_VERSION 12.3.0.159-1
ENV NV_LIBNPP_PACKAGE libnpp-12-5=${NV_LIBNPP_VERSION}
ENV NV_LIBCUSPARSE_VERSION 12.5.1.3-1

ENV NV_LIBCUBLAS_PACKAGE_NAME libcublas-12-5
ENV NV_LIBCUBLAS_VERSION 12.5.3.2-1
ENV NV_LIBCUBLAS_PACKAGE ${NV_LIBCUBLAS_PACKAGE_NAME}=${NV_LIBCUBLAS_VERSION}

ENV NV_LIBNCCL_PACKAGE_NAME libnccl2
ENV NV_LIBNCCL_PACKAGE_VERSION 2.22.3-1
ENV NCCL_VERSION 2.22.3-1
ENV NV_LIBNCCL_PACKAGE ${NV_LIBNCCL_PACKAGE_NAME}=${NV_LIBNCCL_PACKAGE_VERSION}+cuda12.5

RUN apt-get update && apt-get install -y --no-install-recommends \
    cuda-libraries-12-5=${NV_CUDA_LIB_VERSION} \
    ${NV_LIBNPP_PACKAGE} \
    cuda-nvtx-12-5=${NV_NVTX_VERSION} \
    libcusparse-12-5=${NV_LIBCUSPARSE_VERSION} \
    ${NV_LIBCUBLAS_PACKAGE} \
    ${NV_LIBNCCL_PACKAGE} \
    && rm -rf /var/lib/apt/lists/*

# Keep apt from auto upgrading the cublas and nccl packages. See https://gitlab.com/nvidia/container-images/cuda/-/issues/88
RUN apt-mark hold ${NV_LIBCUBLAS_PACKAGE_NAME} ${NV_LIBNCCL_PACKAGE_NAME}

# Add entrypoint items
ENV NVIDIA_PRODUCT_NAME="CUDA"


# Reference 3: https://gitlab.com/nvidia/container-images/cuda/-/blob/master/dist/12.5.1/ubuntu2204/devel/Dockerfile
ENV NV_CUDA_LIB_VERSION "12.5.1-1"

ENV NV_CUDA_CUDART_DEV_VERSION 12.5.82-1
ENV NV_NVML_DEV_VERSION 12.5.82-1
ENV NV_LIBCUSPARSE_DEV_VERSION 12.5.1.3-1
ENV NV_LIBNPP_DEV_VERSION 12.3.0.159-1
ENV NV_LIBNPP_DEV_PACKAGE libnpp-dev-12-5=${NV_LIBNPP_DEV_VERSION}

ENV NV_LIBCUBLAS_DEV_VERSION 12.5.3.2-1
ENV NV_LIBCUBLAS_DEV_PACKAGE_NAME libcublas-dev-12-5
ENV NV_LIBCUBLAS_DEV_PACKAGE ${NV_LIBCUBLAS_DEV_PACKAGE_NAME}=${NV_LIBCUBLAS_DEV_VERSION}

ENV NV_CUDA_NSIGHT_COMPUTE_VERSION 12.5.1-1
ENV NV_CUDA_NSIGHT_COMPUTE_DEV_PACKAGE cuda-nsight-compute-12-5=${NV_CUDA_NSIGHT_COMPUTE_VERSION}

ENV NV_NVPROF_VERSION 12.5.82-1
ENV NV_NVPROF_DEV_PACKAGE cuda-nvprof-12-5=${NV_NVPROF_VERSION}

ENV NV_LIBNCCL_DEV_PACKAGE_NAME libnccl-dev
ENV NV_LIBNCCL_DEV_PACKAGE_VERSION 2.22.3-1
ENV NCCL_VERSION 2.22.3-1
ENV NV_LIBNCCL_DEV_PACKAGE ${NV_LIBNCCL_DEV_PACKAGE_NAME}=${NV_LIBNCCL_DEV_PACKAGE_VERSION}+cuda12.5

RUN apt-get update && apt-get install -y --no-install-recommends \
    cuda-cudart-dev-12-5=${NV_CUDA_CUDART_DEV_VERSION} \
    cuda-command-line-tools-12-5=${NV_CUDA_LIB_VERSION} \
    cuda-minimal-build-12-5=${NV_CUDA_LIB_VERSION} \
    cuda-libraries-dev-12-5=${NV_CUDA_LIB_VERSION} \
    cuda-nvml-dev-12-5=${NV_NVML_DEV_VERSION} \
    ${NV_NVPROF_DEV_PACKAGE} \
    ${NV_LIBNPP_DEV_PACKAGE} \
    libcusparse-dev-12-5=${NV_LIBCUSPARSE_DEV_VERSION} \
    ${NV_LIBCUBLAS_DEV_PACKAGE} \
    ${NV_LIBNCCL_DEV_PACKAGE} \
    ${NV_CUDA_NSIGHT_COMPUTE_DEV_PACKAGE} \
    && rm -rf /var/lib/apt/lists/*

# Keep apt from auto upgrading the cublas and nccl packages. See https://gitlab.com/nvidia/container-images/cuda/-/issues/88
RUN apt-mark hold ${NV_LIBCUBLAS_DEV_PACKAGE_NAME} ${NV_LIBNCCL_DEV_PACKAGE_NAME}
ENV LIBRARY_PATH /usr/local/cuda/lib64/stubs


# Reference 4: https://gitlab.com/nvidia/container-images/cuda/-/blob/master/dist/12.5.1/ubuntu2204/devel/cudnn/Dockerfile
ENV NV_CUDNN_VERSION 9.2.1.18-1
ENV NV_CUDNN_PACKAGE_NAME libcudnn9-cuda-12
ENV NV_CUDNN_PACKAGE libcudnn9-cuda-12=${NV_CUDNN_VERSION}
ENV NV_CUDNN_PACKAGE_DEV libcudnn9-dev-cuda-12=${NV_CUDNN_VERSION}

RUN apt-get update && apt-get install -y --no-install-recommends \
    ${NV_CUDNN_PACKAGE} \
    ${NV_CUDNN_PACKAGE_DEV} \
    && apt-mark hold ${NV_CUDNN_PACKAGE_NAME} \
    && rm -rf /var/lib/apt/lists/*

RUN echo '' >> $HOMEPATH/.bashrc && \
    echo 'export PATH=${PATH}:/usr/local/cuda-12.5/bin' >> $HOMEPATH/.bashrc && \
    echo 'export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:/usr/local/cuda-12.5/lib64' >> $HOMEPATH/.bashrc && \
    echo '' >> $HOMEPATH/.bashrc


###############
# Install pip #
###############
# Run as root user
USER root

RUN apt-get update -q && \
    apt-get install -yq \
        python3 \
        python3-dev \
        python3-pip

# Run as user sobits
USER ${USER_NAME}

# install pip
RUN python3 -m pip install -U \
        pip \
        wheel \
        numpy


###############################
# Install OpenCV 4.10.0 (GPU) #
###############################
# Run as sobits user
USER ${USER_NAME}

# Clone only installation_sh from SOBITS Manual
RUN cd $HOMEPATH && \
    curl https://${GIT_PSW}@raw.githubusercontent.com/TeamSOBITS/sobits_manual/main/install_sh/install_opencv.sh -o install_opencv.sh

RUN bash $HOMEPATH/install_opencv.sh --4.10.0 --GPU

RUN rm $HOMEPATH/install_opencv.sh


##################
# Other settings #
##################
# Run as root user
USER root

# Clean cache
RUN apt-get clean &&\
	apt-get autoremove && \	
    rm -rf /var/lib/apt/lists/ && \
    rm /etc/apt/apt.conf.d/docker-clean

# Set user
ENV USER=${USER_NAME}
USER ${USER_NAME}

# Set HOME position
WORKDIR ${HOMEPATH}


RUN echo "╚══╣ Install: base_ws:gpu_cuda12.5.1_cudnn9.2_ubuntu2204 (FINISHED) ╠══╝"
