FROM tiryoh/ros-desktop-vnc:kinetic

MAINTAINER Kouta Ohishi

RUN apt-get update && \
    apt-get install -y \
    yum \
    iputils-ping

# add user
RUN useradd -m sobits && \
    gpasswd -a sobits sudo && \
    echo sobits:robotgroup | chpasswd && \
    echo "sobits ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers &&\
    touch /home/sobits/.sudo_as_admin_successful
ENV USER sobits

# set initial position
WORKDIR /home/sobits/

# copy bashrc file from user:ubuntu
RUN cp /home/ubuntu/.bashrc /home/sobits/

#install pip
RUN curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py &&\
python2 get-pip.py &&\
rm get-pip.py &&\
pip install -U pip

#create catkin_ws
RUN echo "### create catkin_ws ###"
RUN mkdir -p /home/sobits/catkin_ws/src
RUN cd /home/sobits/catkin_ws/src && \
	/bin/bash -c /bin/bash -c "source /opt/ros/kinetic/setup.bash; catkin_init_workspace"
RUN cd /home/sobits/catkin_ws/ && /bin/bash -c "source /opt/ros/kinetic/setup.bash; catkin_make"

RUN echo "source /opt/ros/kinetic/setup.bash" >> /home/sobits/.bashrc &&\
	echo "source /home/sobits/catkin_ws/devel/setup.bash" >> /home/sobits/.bashrc &&\
	echo "export ROS_PACKAGE_PATH=\${ROS_PACKAGE_PATH}:/home/sobits/catkin_ws" >> /home/sobits/.bashrc &&\
	echo "export ROS_WORKSPACE=/home/sobits/catkin_ws" >> /home/sobits/.bashrc

# alias setting
RUN cd /home/sobits/ && \
    git clone https://oauth2:CVbC1YVoCUN6x-uAQK61@gitlab.com/TeamSOBITS/sobits-setup.git &&\
    chmod 755 /home/sobits/sobits-setup/chmod_all.py && \
    echo "alias cmd='python /home/sobits/sobits-setup/chmod_all.py'" >> /home/sobits/.bashrc &&\
    echo "alias cmk='CULLENT_DIR=`pwd` && cd /home/sobits/catkin_ws/ && catkin_make && cd $CULLENT_DIR'" >> /home/sobits/.bashrc &&\
    echo "alias cm='cmk && cmd'" >> /home/sobits/.bashrc &&\
    echo "export PYTHONDONTWRITEBYTECODE=1" >> /home/sobits/.bashrc &&\
    echo "sudo chmod 777 /dev/video0" >> /home/sobits/.bashrc

RUN cd /home/sobits/ &&\
    git clone https://oauth2:CVbC1YVoCUN6x-uAQK61@gitlab.com/TeamSOBITS/git_pull_all.git &&\
    chmod 755 /home/sobits/git_pull_all/git_pull_all.py &&\
    echo "alias gpa='python /home/sobits/git_pull_all/git_pull_all.py'" >> /home/sobits/.bashrc


# Install & build OpenCV
ARG OPENCV_VERSION="3.4.2"

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

# clone & build
RUN cd /home/sobits/ &&\
    git clone https://github.com/opencv/opencv.git &&\
    cd opencv &&\
    git checkout ${OPENCV_VERSION} &&\
    cd /home/sobits/ &&\
    git clone https://github.com/opencv/opencv_contrib.git &&\
    cd opencv_contrib &&\
    git checkout ${OPENCV_VERSION} &&\
    cd /home/sobits/opencv &&\
    mkdir build &&\
    cd build &&\
    cmake \
    -D CMAKE_BUILD_TYPE=RELEASE \
    -D CMAKE_INSTALL_PREFIX=/usr/local \
    -D OPENCV_EXTRA_MODULES_PATH=/home/sobits/opencv_contrib/modules \
    .. &&\
    make && make install
RUN rm -rf /home/sobits/opencv && rm -rf /home/sobits/opencv_contrib

# finish install & build opencv #

# set time zone
ENV TZ Asia/Tokyo

# set Language
RUN locale-gen ja_JP.UTF-8
ENV LANG ja_JP.UTF-8
ENV LANGUAGE ja_JP:ja
ENV LC_ALL ja_JP.UTF-8

# clean cache
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/
