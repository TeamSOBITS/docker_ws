FROM ubuntu:22.04
LABEL maintainer="Valentin Keith"


RUN echo "╔══╣ Install: base_ws:cpu_ubuntu2204 (STARTING) ╠══╗"


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
# Install OpenCV 4.10.0 (CPU) #
###############################
# Run as sobits user
USER ${USER_NAME}

# Clone only installation_sh from SOBITS Manual
RUN cd $HOMEPATH && \
    curl https://${GIT_PSW}@raw.githubusercontent.com/TeamSOBITS/sobits_manual/main/install_sh/install_opencv.sh -o install_opencv.sh

RUN bash $HOMEPATH/install_opencv.sh --4.10.0 --CPU

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


RUN echo "╚══╣ Install: base_ws:cpu_ubuntu2204 (FINISHED) ╠══╝"
