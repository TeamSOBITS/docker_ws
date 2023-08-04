FROM ubuntu:18.04
LABEL maintainer Valentin Keith


RUN echo "╔══╣ Install: base_ws:cpu_ubuntu1804 (STARTING) ╠══╗"


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


###############
# Install pip #
###############
# Run as root user
USER root

RUN apt-get update -q && \
    apt-get install -yq \
        python \
        python-dev \
        python-pip

RUN apt-get update -q && \
    apt-get install -yq \
        python3 \
        python3-dev \
        python3-pip

# Run as user sobits
USER sobits

# install pip
RUN python -m pip install -U \
        pip \
        wheel

RUN python3 -m pip install -U \
        pip \
        wheel


##############################
# Install OpenCV 4.6.0 (CPU) #
##############################
# Run as sobits user
USER sobits

# Clone only installation_sh from SOBITS Manual
RUN cd $HOMEPATH && \
    curl https://${GIT_PSW}@raw.githubusercontent.com/TeamSOBITS/sobits_manual/main/install_sh/install_opencv.sh -o install_opencv.sh

RUN bash $HOMEPATH/install_opencv.sh --4.6.0 --CPU

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


RUN echo "╚══╣ Install: base_ws:gpu_CUDA12.1.1_cuDNN8.9 (FINISHED) ╠══╝"

RUN echo "╚══╣ Install: base_ws:cpu_ubuntu1804 (FINISHED) ╠══╝"