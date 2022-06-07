FROM ubuntu:20.04 as mid_layer
LABEL maintainer Valentin Keith


# 参考① https://gitlab.com/nvidia/container-images/cuda/-/tree/master/dist
# 参考② https://catalog.ngc.nvidia.com/orgs/nvidia/containers/cuda/tags

###################################
# Environment_variable_preference #
###################################
ENV USER_ID=${LOCAL_UID:-1000}
ENV GROUP_ID=${LOCAL_GID:-1000}
ENV DEBCONF_NOWARNINGS yes
ENV DEBIAN_FRONTEND=noninteractive


######################
# Install basic apps #
######################
# avoid time-zone setting
RUN apt-get update -q && \
    apt-get install -yq \
        tzdata

RUN apt-get update -q && \
    apt-get install -yq \
        wget \
        curl \
        git-all \
        build-essential \
        vim \
        nano \
        gedit \
        sudo \
        lsb-release \
        locales \
        bash-completion \
        gosu \
        net-tools \
        usbutils \
        iputils-ping \
        alsa-utils \
        fonts-takao-* \
        libcanberra-gtk-module \
        libcanberra-gtk3-module \
        software-properties-common


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


###################################
# Install CUDA-11.6.2 & CUDNN-8.4 #
###################################
# Run as root user
USER root

# 参考① https://gitlab.com/nvidia/container-images/cuda/-/blob/master/dist/11.6.2/ubuntu2004/base/Dockerfile
ENV NVARCH x86_64

ENV NVIDIA_REQUIRE_CUDA "cuda>=11.6 brand=tesla,driver>=418,driver<419 brand=tesla,driver>=450,driver<451 brand=tesla,driver>=470,driver<471 brand=unknown,driver>=470,driver<471 brand=nvidia,driver>=470,driver<471 brand=nvidiartx,driver>=470,driver<471 brand=quadrortx,driver>=470,driver<471"
ENV NV_CUDA_CUDART_VERSION 11.6.55-1
ENV NV_CUDA_COMPAT_PACKAGE cuda-compat-11-6

RUN apt-get update && apt-get install -y --no-install-recommends \
    gnupg2 curl ca-certificates && \
    curl -fsSL https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/${NVARCH}/3bf863cc.pub | apt-key add - && \
    echo "deb https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/${NVARCH} /" > /etc/apt/sources.list.d/cuda.list && \
    apt-get purge --autoremove -y curl \
    && rm -rf /var/lib/apt/lists/*

ENV CUDA_VERSION 11.6.2

# For libraries in the cuda-compat-* package: https://docs.nvidia.com/cuda/eula/index.html#attachment-a
RUN apt-get update && apt-get install -y --no-install-recommends \
    cuda-cudart-11-6=${NV_CUDA_CUDART_VERSION} \
    ${NV_CUDA_COMPAT_PACKAGE} \
    && ln -s cuda-11.6 /usr/local/cuda && \
    rm -rf /var/lib/apt/lists/*

# Required for nvidia-docker v1
RUN echo "/usr/local/nvidia/lib" >> /etc/ld.so.conf.d/nvidia.conf \
    && echo "/usr/local/nvidia/lib64" >> /etc/ld.so.conf.d/nvidia.conf

ENV PATH /usr/local/nvidia/bin:/usr/local/cuda/bin:${PATH}
ENV LD_LIBRARY_PATH /usr/local/nvidia/lib:/usr/local/nvidia/lib64

# nvidia-container-runtime
ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES compute,utility


# 参考②：https://gitlab.com/nvidia/container-images/cuda/-/blob/master/dist/11.6.2/ubuntu2004/devel/Dockerfile
ENV NV_CUDA_LIB_VERSION "11.6.2-1"
ENV NV_NVTX_VERSION 11.6.124-1
ENV NV_LIBNPP_VERSION 11.6.3.124-1
ENV NV_LIBNPP_PACKAGE libnpp-11-6=${NV_LIBNPP_VERSION}
ENV NV_LIBCUSPARSE_VERSION 11.7.2.124-1

ENV NV_LIBCUBLAS_PACKAGE_NAME libcublas-11-6
ENV NV_LIBCUBLAS_VERSION 11.9.2.110-1
ENV NV_LIBCUBLAS_PACKAGE ${NV_LIBCUBLAS_PACKAGE_NAME}=${NV_LIBCUBLAS_VERSION}

ENV NV_LIBNCCL_PACKAGE_NAME libnccl2
ENV NV_LIBNCCL_PACKAGE_VERSION 2.12.10-1
ENV NCCL_VERSION 2.12.10-1
ENV NV_LIBNCCL_PACKAGE ${NV_LIBNCCL_PACKAGE_NAME}=${NV_LIBNCCL_PACKAGE_VERSION}+cuda11.6


RUN apt-get update && apt-get install -y --no-install-recommends \
    cuda-libraries-11-6=${NV_CUDA_LIB_VERSION} \
    ${NV_LIBNPP_PACKAGE} \
    cuda-nvtx-11-6=${NV_NVTX_VERSION} \
    libcusparse-11-6=${NV_LIBCUSPARSE_VERSION} \
    ${NV_LIBCUBLAS_PACKAGE} \
    ${NV_LIBNCCL_PACKAGE} \
    && rm -rf /var/lib/apt/lists/*


# 参考③：https://gitlab.com/nvidia/container-images/cuda/-/blob/master/dist/11.6.2/ubuntu2004/devel/Dockerfile
ENV NV_CUDA_LIB_VERSION "11.6.2-1"

ENV NV_CUDA_CUDART_DEV_VERSION 11.6.55-1
ENV NV_NVML_DEV_VERSION 11.6.55-1
ENV NV_LIBCUSPARSE_DEV_VERSION 11.7.2.124-1
ENV NV_LIBNPP_DEV_VERSION 11.6.3.124-1
ENV NV_LIBNPP_DEV_PACKAGE libnpp-dev-11-6=${NV_LIBNPP_DEV_VERSION}

ENV NV_LIBCUBLAS_DEV_VERSION 11.9.2.110-1
ENV NV_LIBCUBLAS_DEV_PACKAGE_NAME libcublas-dev-11-6
ENV NV_LIBCUBLAS_DEV_PACKAGE ${NV_LIBCUBLAS_DEV_PACKAGE_NAME}=${NV_LIBCUBLAS_DEV_VERSION}

ENV NV_NVPROF_VERSION 11.6.124-1
ENV NV_NVPROF_DEV_PACKAGE cuda-nvprof-11-6=${NV_NVPROF_VERSION}

ENV NV_LIBNCCL_DEV_PACKAGE_NAME libnccl-dev
ENV NV_LIBNCCL_DEV_PACKAGE_VERSION 2.12.10-1
ENV NCCL_VERSION 2.12.10-1
ENV NV_LIBNCCL_DEV_PACKAGE ${NV_LIBNCCL_DEV_PACKAGE_NAME}=${NV_LIBNCCL_DEV_PACKAGE_VERSION}+cuda11.6


RUN apt-get update && apt-get install -y --no-install-recommends \
    libtinfo5 libncursesw5 \
    cuda-cudart-dev-11-6=${NV_CUDA_CUDART_DEV_VERSION} \
    cuda-command-line-tools-11-6=${NV_CUDA_LIB_VERSION} \
    cuda-minimal-build-11-6=${NV_CUDA_LIB_VERSION} \
    cuda-libraries-dev-11-6=${NV_CUDA_LIB_VERSION} \
    cuda-nvml-dev-11-6=${NV_NVML_DEV_VERSION} \
    ${NV_NVPROF_DEV_PACKAGE} \
    ${NV_LIBNPP_DEV_PACKAGE} \
    libcusparse-dev-11-6=${NV_LIBCUSPARSE_DEV_VERSION} \
    ${NV_LIBCUBLAS_DEV_PACKAGE} \
    ${NV_LIBNCCL_DEV_PACKAGE} \
    && rm -rf /var/lib/apt/lists/*

# Keep apt from auto upgrading the cublas and nccl packages. See https://gitlab.com/nvidia/container-images/cuda/-/issues/88
RUN apt-mark hold ${NV_LIBCUBLAS_DEV_PACKAGE_NAME} ${NV_LIBNCCL_DEV_PACKAGE_NAME}

ENV LIBRARY_PATH /usr/local/cuda/lib64/stubs


# 参考④：https://gitlab.com/nvidia/container-images/cuda/-/blob/master/dist/11.6.2/ubuntu2004/devel/cudnn8/Dockerfile
ENV NV_CUDNN_VERSION 8.4.0.27

ENV NV_CUDNN_PACKAGE "libcudnn8=$NV_CUDNN_VERSION-1+cuda11.6"
ENV NV_CUDNN_PACKAGE_DEV "libcudnn8-dev=$NV_CUDNN_VERSION-1+cuda11.6"
ENV NV_CUDNN_PACKAGE_NAME "libcudnn8"



RUN apt-get update && apt-get install -y --no-install-recommends \
    ${NV_CUDNN_PACKAGE} \
    ${NV_CUDNN_PACKAGE_DEV} \
    && apt-mark hold ${NV_CUDNN_PACKAGE_NAME} && \
    rm -rf /var/lib/apt/lists/*


###############
# Install pip #
###############
# Run as root user
USER root

RUN apt-get update -q && \
    apt-get install -yq \
        python3 \
        python3-pip \
        python3-dev


# Run as user sobits
USER sobits

# install pip
RUN python3 -m pip install -U \
        pip \
        wheel


####################################################
# Clone sobits_manual repository (only install_sh) #
####################################################
# 参考：https://stackoverflow.com/questions/600079/how-do-i-clone-a-subdirectory-only-of-a-git-repository

# Run as user sobits
USER sobits

# Clone only installation_sh from SOBITS Manual
RUN cd $HOMEPATH && \
    mkdir sobits_manual_mini && \
    cd sobits_manual_mini && \
    git init && \
    git remote add -f origin https://oauth2:CVbC1YVoCUN6x-uAQK61@gitlab.com/TeamSOBITS/sobits_manual.git && \
    git sparse-checkout init && \
    git sparse-checkout set "install_sh" && \
    cd install_sh


###############################
# Install OpenCV 4.6.0 (GPU) #
###############################
# Run as root user
USER root

RUN gosu sobits bash $HOMEPATH/sobits_manual_mini/install_sh/install_opencv.sh --4.6.0 --GPU


###################################
# Install ROS1 & create catkin_ws #
###################################
# Run as root user
USER root

RUN gosu sobits bash $HOMEPATH/sobits_manual_mini/install_sh/install_ros1.sh --noetic && \
    gosu sobits bash $HOMEPATH/sobits_manual_mini/install_sh/install_ros1_catkin_ws.sh --noetic && \
	gosu sobits bash $HOMEPATH/sobits_manual_mini/install_sh/setup_ros1.sh


#################
# Alias Setting #
#################
# Run as root user
USER root

RUN chmod 755 $HOMEPATH/sobits_manual_mini/install_sh/chmod_all.py


# Run as user sobits
USER root

RUN gosu sobits bash $HOMEPATH/sobits_manual_mini/install_sh/setup_alias.sh

RUN . $HOMEPATH/.bashrc


###########################
# Install useful programs #
###########################
# Run as root user
USER root

# install google_chrome
RUN gosu sobits bash $HOMEPATH/sobits_manual_mini/install_sh/install_google_chrome.sh



# マルチステージビルド(image layer の内容を隠す処理)
FROM ubuntu:20.04
COPY --from=mid_layer / /


##################
# Other settings #
##################
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