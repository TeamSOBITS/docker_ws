FROM nvcr.io/nvidia/cuda:11.6.2-cudnn8-runtime-ubuntu20.04 as mid_layer

LABEL maintainer Valentin Keith

# Do NOT rewrite manually

# 参考① https://gitlab.com/nvidia/container-images/cuda/-/tree/master/dist
# 参考② https://catalog.ngc.nvidia.com/orgs/nvidia/containers/cuda/tags

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
ENV WORKPATH /home/sobits
WORKDIR $WORKPATH
RUN . $WORKPATH/.bashrc


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

# install pip
RUN python3 -m pip install -U \
        pip \
        wheel

# run as root user
USER root


##################################
# Clone sobits_manual repository #
##################################
RUN cd $WORKPATH && \
    git clone https://oauth2:CVbC1YVoCUN6x-uAQK61@gitlab.com/TeamSOBITS/sobits_manual.git && \
    cd sobits_manual && \
    git fetch origin feature/ubuntu20.04 && \
    git checkout feature/ubuntu20.04 && \
    git pull && \
    cd install_sh

###############################
# Install OpenCV 4.5.5 (CPU) #
###############################
# RUN apt-get update && \
#     gosu sobits bash $WORKPATH/sobits_manual/install_sh/install_opencv.sh --4.5.5 --CPU


##################################
# Install ros & create catkin_ws #
##################################
RUN apt-get update &&\
    gosu sobits bash $WORKPATH/sobits_manual/install_sh/install_ros1.sh --noetic && \
    gosu sobits bash $WORKPATH/sobits_manual/install_sh/install_ros1_catkin_ws.sh --noetic && \
	gosu sobits bash $WORKPATH/sobits_manual/install_sh/setup_ros1.sh --${WORKPATH}


#################
# Alias setting #
#################
RUN chmod 755 $WORKPATH/sobits_manual/install_sh/chmod_all.py
RUN gosu sobits bash $WORKPATH/sobits_manual/install_sh/setup_alias.sh

RUN . $WORKPATH/.bashrc


###########################
# Install useful programs #
###########################
# # install google_chrome
# RUN gosu sobits bash $WORKPATH/sobits_manual/install_sh/install_google_chrome.sh && \
#     sed -i "1s/^/# /g" /etc/apt/sources.list.d/google.list


# マルチステージビルド(image layer の内容を隠す処理)
FROM ubuntu:20.04
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
    rm -rf /var/lib/apt/lists/ && \
    rm /etc/apt/apt.conf.d/docker-clean

# set user
ENV USER sobits
# set initial position
WORKDIR /home/sobits/