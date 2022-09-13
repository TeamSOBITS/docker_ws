FROM nvcr.io/nvidia/l4t-pytorch:r32.7.1-pth1.10-py3 as mid_layer
LABEL maintainer Valentin Keith and Okuma Yuki


RUN echo "╔══╣ Install: base_ws:gpu_cuda10.2_cudnn8.2.1_ubuntu1804_l4t (STARTING) ╠══╗"


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
        software-properties-common \
        file \
        dpkg-dev \
        qemu \
        binfmt-support \
        qemu-user-static \
        pkg-config \
        ninja-build \
        doxygen \
        clang \
        python3 \
        gcc \
        g++ \
        git \
        git-lfs \
        nasm \
        cmake \
        libgl1-mesa-dev:arm64 \
        libsoundio-dev:arm64 \
        libjpeg-dev:arm64 \
        libvulkan-dev:arm64 \
        libx11-dev:arm64 \
        libxcursor-dev:arm64 \
        libxinerama-dev:arm64 \
        libxrandr-dev:arm64 \
        libusb-1.0-0-dev:arm64 \
        libssl-dev:arm64 \
        libudev-dev:arm64 \
        mesa-common-dev:arm64 \
        uuid-dev:arm64   


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
    curl https://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@raw.githubusercontent.com/TeamSOBITS/sobits_manual/main/install_sh/install_opencv.sh -o install_opencv.sh


###############################
# Install OpenCV 4.6.0 (CPU) #
###############################
# Run as root user
USER root

RUN gosu sobits bash $HOMEPATH/install_opencv.sh --4.6.0 --GPU

RUN rm $HOMEPATH/install_opencv.sh


# マルチステージビルド(image layer の内容を隠す処理)
FROM nvcr.io/nvidia/l4t-pytorch:r32.7.1-pth1.10-py3
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


RUN echo "╚══╣ Install: base_ws:gpu_cuda10.2_cudnn8.2.1_ubuntu1804_l4t  (FINISHED) ╠══╝"