FROM ubuntu:18.04 as mid_layer
LABEL maintainer Valentin Keith


RUN echo "╔══╣ Install: base1804_ws:cpu (STARTING) ╠══╗"


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
        software-properties-common

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
        gcc-7 gcc-8 gcc-9 \
        g++-7 g++-8 g++-9 \
        git \
        git-lfs \
        nasm \
        cmake \
        libgl1-mesa-dev:amd64 \
        libsoundio-dev:amd64 \
        libjpeg-dev:amd64 \
        libvulkan-dev:amd64 \
        libx11-dev:amd64 \
        libxcursor-dev:amd64 \
        libxinerama-dev:amd64 \
        libxrandr-dev:amd64 \
        libusb-1.0-0-dev:amd64 \
        libssl-dev:amd64 \
        libudev-dev:amd64 \
        mesa-common-dev:amd64 \
        uuid-dev:amd64   


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
        python \
        python-pip \
        python-dev

RUN apt-get update -q && \
    apt-get install -yq \
        python3 \
        python3-pip \
        python3-dev

# Run as user sobits
USER sobits

# install pip
RUN python -m pip install -U \
        pip \
        wheel

RUN python3 -m pip install -U \
        pip \
        wheel


####################################################
# Clone sobits_manual repository (only install_sh) #
####################################################

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

RUN gosu sobits bash $HOMEPATH/install_opencv.sh --4.6.0 --CPU

RUN rm $HOMEPATH/install_opencv.sh


# マルチステージビルド(image layer の内容を隠す処理)
FROM ubuntu:18.04
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


RUN echo "╚══╣ Install: base1804_ws:cpu (FINISHED) ╠══╝"