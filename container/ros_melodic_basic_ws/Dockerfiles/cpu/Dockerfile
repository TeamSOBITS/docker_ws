FROM ubuntu:18.04

LABEL maintainer Tsurue Takumi

# Do NOT rewrite manually

###################################
# Environment_variable_preference #
###################################
ENV USER_ID=${LOCAL_UID:-1000}
ENV GROUP_ID=${LOCAL_GID:-1000}
ENV CONTAINER_NAME=${CNAME:-container}


######################
# Install basic apps #
######################
# avoid time-zone setting
RUN apt-get update -q && \
    apt-get upgrade -yq && \
    apt-get install -yq tzdata

RUN apt-get update -q && \
    apt-get install -yq \
        wget \
        curl \
        git \
        build-essential \
        vim \
        sudo \
        lsb-release \
        locales \
        bash-completion \
        gosu \
        net-tools \
        gedit \
        usbutils \
        yum \
        iputils-ping \
        alsa-utils \
        fonts-takao-* \
        libcanberra-gtk-module \
        libcanberra-gtk3-module


###############
# Install pip #
###############
RUN curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py && \
    python2 get-pip.py && \
    rm get-pip.py && \
    pip install -U pip

RUN apt-get update -q && \
    apt-get upgrade -yq && \
    apt-get install -y \
        python3 \
        python3-pip && \
    pip3 install -U pip

# install numpy
RUN pip3 install numpy


##############
# Add a user #
##############
# add sudo user
RUN useradd --create-home --home-dir /home/sobits --shell /bin/bash --user-group --groups adm,sudo -u ${USER_ID} sobits && \
    groupmod -g ${GROUP_ID} -o sobits && \
    echo sobits:robotgroup | chpasswd && \
    echo "sobits ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# set user
ENV USER sobits
# set initial position
WORKDIR /home/sobits/


#################################
# Clone sobits-setup repository #
#################################
RUN cd /home/sobits/ && \
    git clone https://oauth2:CVbC1YVoCUN6x-uAQK61@gitlab.com/TeamSOBITS/sobits-setup.git && \
    cd sobits-setup && \
    git checkout ubuntu18.04


##################################
# Install ros & create catkin_ws #
##################################
RUN apt-get update &&\
    gosu sobits bash /home/sobits/sobits-setup/install_sh/ubuntu18.04/install_ros_melodic.sh && \
    gosu sobits bash /home/sobits/sobits-setup/install_sh/ubuntu18.04/install_catkin_ws_melodic.sh && \
	echo "export ROS_PACKAGE_PATH=\${ROS_PACKAGE_PATH}:/home/sobits/catkin_ws" >> /home/sobits/.bashrc && \
	echo "export ROS_WORKSPACE=/home/sobits/catkin_ws" >> /home/sobits/.bashrc && \
    echo "export ROS_IP=\`ifconfig eth0 | grep inet | cut -d: -f2 | awk '{ print \$2}'\`" >> /home/sobits/.bashrc && \
    echo "export ROS_MASTER_URI=http://\$ROS_IP:11311" >> /home/sobits/.bashrc && \
    echo "export export NO_AT_BRIDGE=1" >> /home/sobits/.bashrc

#################
# Alias setting #
#################
RUN chmod 755 /home/sobits/sobits-setup/chmod_all.py && \
    echo "alias cmd='python /home/sobits/sobits-setup/chmod_all.py'" >> /home/sobits/.bashrc &&\
    echo "alias cmk='CULLENT_DIR=`pwd` && cd /home/sobits/catkin_ws/ && catkin_make && cd $CULLENT_DIR'" >> /home/sobits/.bashrc &&\
    echo "alias cm='cmk && cmd'" >> /home/sobits/.bashrc &&\
    echo "export PYTHONDONTWRITEBYTECODE=1" >> /home/sobits/.bashrc &&\
    echo "sudo chmod 777 /dev/video0" >> /home/sobits/.bashrc && \
    echo "export PS1='\[\e[1;33;40m\]\$CONTAINER_NAME\[\e[0m\] ${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '">> /home/sobits/.bashrc

RUN cd /home/sobits/ &&\
    git clone https://oauth2:CVbC1YVoCUN6x-uAQK61@gitlab.com/TeamSOBITS/git_pull_all.git &&\
    chmod 755 /home/sobits/git_pull_all/git_pull_all.py &&\
    echo "alias gpa='python /home/sobits/git_pull_all/git_pull_all.py'" >> /home/sobits/.bashrc


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

# nvidia-container-runtime
ENV NVIDIA_VISIBLE_DEVICES \
    ${NVIDIA_VISIBLE_DEVICES:-all}
ENV NVIDIA_DRIVER_CAPABILITIES \
    ${NVIDIA_DRIVER_CAPABILITIES:+$NVIDIA_DRIVER_CAPABILITIES,}graphics


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

RUN apt-get update && \
    gosu sobits bash /home/sobits/sobits-setup/install_sh/ubuntu18.04/install_opencv_3.4.2.sh

# install google_chrome
RUN gosu sobits bash /home/sobits/sobits-setup/install_sh/install_google_chrome.sh && \
    sed -i "1s/^/# /g" /etc/apt/sources.list.d/google.list


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