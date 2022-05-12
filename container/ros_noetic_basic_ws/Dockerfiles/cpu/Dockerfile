FROM ubuntu:20.04 as mid_layer

LABEL maintainer Valentin Keith

# Do NOT rewrite manually

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
        libcanberra-gtk3-module


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
RUN . /home/sobits/.bashrc


###############
# Install pip #
###############
RUN apt-get update -q && \
    apt-get install -yq \
        python3 \
        python3-pip \
        python3-dev

# run as user sobits
USER sobits

# install numpy
RUN python3 -m pip install -U \
        pip

# run as root user
USER root


##################################
# Clone sobits_manual repository #
##################################
RUN cd /home/sobits/ && \
    git clone https://oauth2:CVbC1YVoCUN6x-uAQK61@gitlab.com/TeamSOBITS/sobits_manual.git && \
    cd install_sh


##################################
# Install ros & create catkin_ws #
##################################
RUN apt-get update &&\
    gosu sobits bash /home/sobits/sobits_manual/install_sh/install_ros_noetic.sh && \
    gosu sobits bash /home/sobits/sobits_manual/install_sh/install_catkin_ws_noetic.sh && \
	echo "export ROS_PACKAGE_PATH=\${ROS_PACKAGE_PATH}:/home/sobits/catkin_ws" >> /home/sobits/.bashrc && \
	echo "export ROS_WORKSPACE=/home/sobits/catkin_ws" >> /home/sobits/.bashrc && \
    echo "export IFACE=\`ifconfig | head -n 1 | awk '{ print \$1}' | rev | cut -b 2- | rev\`" >> /home/sobits/.bashrc && \
    echo "export ROS_IP=\`ifconfig \${IFACE} | grep inet | cut -d: -f2 | awk '{ print \$2}'\`" >> /home/sobits/.bashrc && \
    echo "export ROS_MASTER_URI=http://\$ROS_IP:11311" >> /home/sobits/.bashrc && \
    echo "export NO_AT_BRIDGE=1" >> /home/sobits/.bashrc


#################
# Alias setting #
#################
RUN chmod 755 /home/sobits/sobits_manual/chmod_all.py && \
    echo "alias cmd='python3 /home/sobits/sobits_manual/chmod_all.py'" >> /home/sobits/.bashrc &&\
    echo "alias cmk='CULLENT_DIR=`pwd` && cd /home/sobits/catkin_ws/ && catkin_make && cd $CULLENT_DIR'" >> /home/sobits/.bashrc &&\
    echo "alias cm='cmk && cmd'" >> /home/sobits/.bashrc &&\
    echo "export PYTHONDONTWRITEBYTECODE=1" >> /home/sobits/.bashrc &&\
    echo "sudo chmod 777 /dev/video0" >> /home/sobits/.bashrc && \
    echo "export PS1='\[\e[1;33;40m\]\$CONTAINER_NAME\[\e[0m\] ${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '">> /home/sobits/.bashrc

RUN . /home/sobits/.bashrc


###############################
# Install OpenCV 3.4.16 (CPU) #
###############################
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
    gosu sobits bash /home/sobits/sobits_manual/install_sh/ubuntu18.04/install_opencv_3.4.2.sh

# install google_chrome
RUN gosu sobits bash /home/sobits/sobits_manual/install_sh/install_google_chrome.sh && \
    sed -i "1s/^/# /g" /etc/apt/sources.list.d/google.list


# マルチステージビルド(image layer の内容を隠す処理)
FROM ubuntu:18.04
COPY --from=mid_layer / /


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

# set user
ENV USER sobits
# set initial position
WORKDIR /home/sobits/