FROM nvidia/opengl:1.1-glvnd-devel-ubuntu16.04
#https://hub.docker.com/r/nvidia/opengl
#FROM ubuntu:16.04

LABEL maintainer Kouta Ohishi

ENV USER_ID=${LOCAL_UID:-1000}
ENV GROUP_ID=${LOCAL_GID:-1000}

######################
# Install basic apps #
######################
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y \
    wget \
    curl \
    git \
    build-essential \
    vim \
    sudo \
    lsb-release \
    locales \
    bash-completion \
    tzdata \
    gosu \
    yum \
    dirmngr \
    gnupg2 \
    lsb-release \
    gedit \
    iputils-ping && \
    rm -rf /var/lib/apt/lists/*


###############
# Install pip #
###############
RUN curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py &&\
	python2 get-pip.py &&\
	rm get-pip.py &&\
	pip install -U pip
	
##############
# Add a user #
##############
# add sudo user
RUN apt-get update && \
	apt-get install -y sudo && \
	useradd --create-home --home-dir /home/sobits --shell /bin/bash --user-group --groups adm,sudo -u ${USER_ID} sobits && \
	groupmod -g ${GROUP_ID} -o sobits && \
    	echo sobits:robotgroup | chpasswd && \
   	echo "Defaults visiblepw" >> /etc/sudoers && \
    	echo "sobits ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

ENV USER sobits
WORKDIR /home/sobits/ 

#################################
# Clone sobits-setup repository #
#################################
RUN cd /home/sobits/ && \
    git clone https://oauth2:CVbC1YVoCUN6x-uAQK61@gitlab.com/TeamSOBITS/sobits-setup.git

##################################
# Install ros & create catkin_ws #
##################################
RUN apt-get update &&\
	gosu sobits bash /home/sobits/sobits-setup/install_sh/install_ros_kinetic.sh &&\
	gosu sobits bash /home/sobits/sobits-setup/install_sh/install_catkin_ws.sh &&\
	rm -rf /var/lib/apt/lists/*


#################
# Alias setting #
#################
RUN chmod 755 /home/sobits/sobits-setup/chmod_all.py && \
    echo "alias cmd='python /home/sobits/sobits-setup/chmod_all.py'" >> /home/sobits/.bashrc &&\
    echo "alias cmk='CULLENT_DIR=`pwd` && cd /home/sobits/catkin_ws/ && catkin_make && cd $CULLENT_DIR'" >> /home/sobits/.bashrc &&\
    echo "alias cm='cmk && cmd'" >> /home/sobits/.bashrc &&\
    echo "export PYTHONDONTWRITEBYTECODE=1" >> /home/sobits/.bashrc &&\
    echo "sudo chmod 777 /dev/video0" >> /home/sobits/.bashrc

RUN cd /home/sobits/ &&\
    git clone https://oauth2:CVbC1YVoCUN6x-uAQK61@gitlab.com/TeamSOBITS/git_pull_all.git &&\
    chmod 755 /home/sobits/git_pull_all/git_pull_all.py &&\
    echo "alias gpa='python /home/sobits/git_pull_all/git_pull_all.py'" >> /home/sobits/.bashrc


###################
# Graphic setting #
###################
RUN apt-get update &&\
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

# nvidia-container-runtime
ENV NVIDIA_VISIBLE_DEVICES ${NVIDIA_VISIBLE_DEVICES:-all}
ENV NVIDIA_DRIVER_CAPABILITIES ${NVIDIA_DRIVER_CAPABILITIES:+$NVIDIA_DRIVER_CAPABILITIES,}graphics

########################
# Install OpenCV 3.4.2 #
########################
# Build tools:
RUN apt-get update && \
    apt-get install -y \
    sudo \
    tzdata \
    git \
    cmake \
    wget \
    unzip \
    build-essential

# Media I/O:
RUN apt-get install -y \
    zlib1g-dev \
    libjpeg-dev \
    libwebp-dev \
    libpng-dev \
    libtiff5-dev \
    libopenexr-dev \
    libgdal-dev \
    libgtk2.0-dev

# Video I/O:
RUN apt-get install -y \
    libdc1394-22-dev \
    libavcodec-dev \
    libavformat-dev \
    libswscale-dev \
    libtheora-dev \
    libvorbis-dev \
    libxvidcore-dev \
    libx264-dev \
    yasm \
    libopencore-amrnb-dev \
    libopencore-amrwb-dev \
    libv4l-dev \
    libxine2-dev \
    libgstreamer1.0-dev \
    libgstreamer-plugins-base1.0-dev \
    ffmpeg

# Parallelism and linear algebra libraries:
RUN apt-get install -y \
    libtbb-dev \
    libeigen3-dev

RUN apt-get update &&\
	gosu sobits /home/sobits/sobits-setup/install_sh/install_opencv_3_4_2.sh &&\
	rm -rf /home/sobits/opencv && \
	rm -rf /home/sobits/opencv_contrib &&\
	rm -rf /var/lib/apt/lists/*

##################
# Other settings #
##################
# set time zone
ENV TZ Asia/Tokyo

# set Language
RUN locale-gen ja_JP.UTF-8
ENV LANG ja_JP.UTF-8
ENV LANGUAGE ja_JP:ja
ENV LC_ALL ja_JP.UTF-8

# clean cache
RUN apt-get clean &&\
	apt-get autoremove && \	
    	rm -rf /var/lib/apt/lists/

