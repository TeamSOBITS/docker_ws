FROM ubuntu:16.04 as intermediate

LABEL maintainer Kouta Ohishi

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
	tzdata \
	iputils-ping && \
	rm -rf /var/lib/apt/lists/*


###############
# Install pip #
###############
RUN curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py &&\
	python2 get-pip.py &&\
	rm get-pip.py &&\
	gosu sobits pip install -U pip
	
##############
# Add a user #
##############
# add sudo user
ENV USER_ID=${LOCAL_UID:-1000}
ENV GROUP_ID=${LOCAL_GID:-1000}
RUN apt-get update && \
	apt-get install -y sudo && \
	useradd --create-home --home-dir /home/sobits --shell /bin/bash --user-group --groups adm,sudo -u ${USER_ID} sobits && \
	groupmod -g ${GROUP_ID} -o sobits && \
    	echo sobits:robotgroup | chpasswd && \
   	echo "Defaults visiblepw" >> /etc/sudoers && \
    	echo "sobits ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers


#################################
# Clone sobits-setup repository #
#################################
ARG OAUTH
RUN cd /home/sobits/ && \
	git clone https://oauth2:CVbC1YVoCUN6x-uAQK61@gitlab.com/TeamSOBITS/sobits-setup.git

##################################
# Install ros & create catkin_ws #
##################################
RUN apt-get update &&\
	gosu sobits bash /home/sobits/sobits-setup/install_sh/install_ros_kinetic.sh &&\
	gosu sobits bash /home/sobits/sobits-setup/install_sh/install_catkin_ws.sh &&\
	echo "source ~/catkin_ws/devel/setup.bash" >> /home/sobits/.bashrc &&\
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



#########################
# Install Google Chrome #
#########################
RUN gosu sobits bash /home/sobits/sobits-setup/install_sh/install_google_chrome.sh && \
	sed -i "1s/^/# /g" /etc/apt/sources.list.d/google.list


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


#####################
# Multi stage build #
#####################
FROM ubuntu:16.04
COPY --from=intermediate / /


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

# User setting:
ENV USER sobits
WORKDIR /home/sobits/ 

# Terminal setting
ENV CONTAINER_NAME=${CNAME:-container}
RUN echo "export PS1='\[\e[1;33;40m\]\$CONTAINER_NAME\[\e[0m\] ${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '">> /home/sobits/.bashrc

# clean cache
RUN apt-get clean &&\
	apt-get autoremove && \	
    rm -rf /var/lib/apt/lists/


