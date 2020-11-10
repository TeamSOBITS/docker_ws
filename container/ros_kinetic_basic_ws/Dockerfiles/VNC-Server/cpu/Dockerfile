FROM dorowu/ubuntu-desktop-lxde-vnc:xenial

MAINTAINER Kouta Ohishi

ENV USER_ID=${LOCAL_UID:-1000}
ENV GROUP_ID=${LOCAL_GID:-1000}

# Do NOT rewrite manually
RUN apt-get update -q && \
    apt-get upgrade -yq && \
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
    tzdata \
    gosu \
    yum \
    iputils-ping && \
    rm -rf /var/lib/apt/lists/*

############
# add user #
############
RUN useradd --create-home --home-dir /home/sobits --shell /bin/bash --user-group --groups adm,sudo -u ${USER_ID} sobits && \
    groupmod -g ${GROUP_ID} -o sobits && \
    echo sobits:robotgroup | chpasswd && \
    echo "sobits ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
ENV USER sobits

# set initial position
WORKDIR /home/sobits/ 

###############
# install pip #
###############
RUN curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py &&\
	python2 get-pip.py &&\
	rm get-pip.py &&\
	pip install -U pip

###############
# install ros #
###############
ENV ROS_DISTRO kinetic

RUN apt-get update && \
	apt-get install -y \
    	dirmngr \
    	gnupg2 && \
    	rm -rf /var/lib/apt/lists/*

RUN apt-key adv --keyserver hkp://ha.pool.sks-keyservers.net:80 --recv-keys C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654 &&\
	echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list

# install bootstrap tools
RUN apt-get update &&\
	apt-get install --no-install-recommends -y \
    	python-rosdep \
    	python-rosinstall \
    	python-vcstools \
    	&& rm -rf /var/lib/apt/lists/*

RUN rosdep init && rosdep update

RUN apt-get update && \
	apt-get install -y \
    	ros-${ROS_DISTRO}-desktop-full \
    	ros-${ROS_DISTRO}-rosbash \
    	python-catkin-tools \
    	&& rm -rf /var/lib/apt/lists/*

#create catkin_ws
RUN mkdir -p /home/sobits/catkin_ws/src &&\
	cd /home/sobits/catkin_ws/src &&\
	/bin/bash -c "source /opt/ros/${ROS_DISTRO}/setup.bash; catkin_init_workspace" &&\
	cd /home/sobits/catkin_ws &&\
	/bin/bash -c "source /opt/ros/${ROS_DISTRO}/setup.bash; catkin_make" &&\
	echo "source /opt/ros/${ROS_DISTRO}/setup.bash" >> /home/sobits/.bashrc &&\
	echo "source /home/sobits/catkin_ws/devel/setup.bash" >> /home/sobits/.bashrc &&\
	echo "export ROS_PACKAGE_PATH=\${ROS_PACKAGE_PATH}:/home/sobits/catkin_ws" >> /home/sobits/.bashrc &&\
	echo "export ROS_WORKSPACE=/home/sobits/catkin_ws" >> /home/sobits/.bashrc

#################
# Alias setting #
#################
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

##################
# Install OpenCV #
##################
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
	make && make install &&\
	rm -rf /home/sobits/opencv &&\
	rm -rf /home/sobits/opencv_contrib


###################
# Graphic setting #
###################
RUN apt-get update && apt-get install -y --no-install-recommends \
        pkg-config \
        libxau-dev \
        libxdmcp-dev \
        libxcb1-dev \
        libxext-dev \
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

##################
# other settings #
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
    rm -rf /var/lib/apt/lists/
