ARG UBUNTU_VERSION
ARG CUDA_VERSION
ARG COMPUTE_TYPE

# Multi-stage build approach to select base image based on COMPUTE_TYPE
FROM ubuntu:${UBUNTU_VERSION} AS base-cpu
FROM nvidia/cuda:${CUDA_VERSION}-cudnn-devel-ubuntu${UBUNTU_VERSION} AS base-gpu

# Select the appropriate base image
FROM base-${COMPUTE_TYPE} AS base

###################################
# Environment_variable_preference #
###################################
ARG USER_ID=${LOCAL_UID:-1000}
ARG GROUP_ID=${LOCAL_GID:-1000}
ARG USERNAME
ARG INSTALL_ROS
ARG INSTALL_GAZEBO
ARG ROS_DISTRO
ARG HOME=/home/${USERNAME}

ENV DEBCONF_NOWARNINGS=yes
ENV DEBIAN_FRONTEND=noninteractive

######################
# Install basic apps #
######################
# Time-zone setting
RUN apt-get update -q && \
    apt-get install -yq \
        tzdata

ENV TZ="Asia/Tokyo"

# Set Language
RUN apt-get install -yq \
        locales && \
    sed -i '/ja_JP.UTF-8/s/^# //g' /etc/locale.gen && \
    locale-gen ja_JP.UTF-8

ENV LANG=ja_JP.UTF-8
ENV LANGUAGE=ja_JP:ja

# Install basic apps
RUN apt-get install -yq \
        language-pack-ja \
        software-properties-common \
        bash-completion \
        lsb-release \
        dpkg-dev \
        alsa-base \
        pulseaudio \
        pulseaudio-utils \
        portaudio19-dev \
        pkg-config \
        net-tools \
        usbutils \
        libusb-1.0-0-dev \
        libudev-dev \
        iputils-ping \
        uuid-dev \
        sudo \
        git-all \
        wget \
        curl \
        nano \
        gedit

###############
# Install pip #
###############
# Run as root user
RUN apt-get install -yq \
        python3 \
        python3-dev \
        python3-pip

#######################
# Add ${USERNAME} user #
#######################
# Add sudo user
RUN if id -u ${USER_ID} >/dev/null 2>&1; then \
        EXISTING_USER=$(id -nu ${USER_ID}); \
        userdel -r ${EXISTING_USER} 2>/dev/null || true; \
    fi && \
    useradd --create-home --home-dir ${HOME} --shell /bin/bash --user-group --groups adm,sudo,audio,video -u ${USER_ID} ${USERNAME} && \
    groupmod -g ${GROUP_ID} -o ${USERNAME} && \
    echo "${USERNAME} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Set user
ENV USER=${USERNAME}

# Run as user
USER ${USERNAME}

# Install pip packages (compatible with both Ubuntu 22.04 and 24.04+)
ARG UBUNTU_VERSION
RUN set -e; \
    # Check Ubuntu version to determine pip installation method
    UBUNTU_MAJOR=$(echo ${UBUNTU_VERSION} | cut -d. -f1); \
    if [ ${UBUNTU_MAJOR} -ge 24 ]; then \
        echo "Ubuntu ${UBUNTU_VERSION} detected - using --break-system-packages"; \
        # For Ubuntu 24.04+, use --break-system-packages
        python3 -m pip install -U --break-system-packages pip wheel numpy; \
    else \
        echo "Ubuntu ${UBUNTU_VERSION} detected - using standard pip installation"; \
        python3 -m pip install -U pip wheel numpy; \
    fi


###################################
# Install ROS & create colcon_ws #
###################################
# Run as root for ROS installation
USER root

# Set ROS_DISTRO environment variable and install ROSonly if ROS will be installed
RUN if [ ${INSTALL_ROS} = "true" ]; then \
        echo "export ROS_DISTRO=${ROS_DISTRO}" >> /etc/environment; \
        echo "Installing ROS ${ROS_DISTRO}..."; \
        apt-get install -yq \
            gnupg && \
        curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg && \
        . /etc/os-release && \
        echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu ${UBUNTU_CODENAME} main" | tee /etc/apt/sources.list.d/ros2.list > /dev/null && \
        apt-get update -q && \
        apt-get install -yq \
            ros-${ROS_DISTRO}-desktop \
            python3-colcon-common-extensions \
            python3-rosdep && \
        rosdep init; \
    else \
        echo "Skipping ROS installation..."; \
    fi

# Install Gazebo only if specified
RUN if [ ${INSTALL_GAZEBO} = "true" ]; then \
        echo "Installing Gazebo..."; \
        curl https://packages.osrfoundation.org/gazebo.gpg --output /usr/share/keyrings/pkgs-osrf-archive-keyring.gpg && \
        echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/pkgs-osrf-archive-keyring.gpg] https://packages.osrfoundation.org/gazebo/ubuntu-stable $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/gazebo-stable.list > /dev/null && \
        apt-get update -q && \
        if [ ${ROS_DISTRO} = "humble" ]; then \
            apt-get install -yq ignition-fortress; \
        elif [ ${ROS_DISTRO} = "jazzy" ]; then \
            apt-get install -yq gz-harmonic; \
        else \
            echo "Unknown ROS_DISTRO for Gazebo: ${ROS_DISTRO}, skipping Gazebo install."; \
        fi \
    else \
        echo "Skipping Gazebo installation..."; \
    fi

# Switch back to user for workspace setup
USER ${USERNAME}

# Configure ROS environment only if ROS is installed
RUN if [ ${INSTALL_ROS} = "true" ]; then \
        rosdep update && \
        mkdir -p ~/colcon_ws/src && \
        echo "source /opt/ros/${ROS_DISTRO}/setup.bash" >> ~/.bashrc && \
        echo "source ~/colcon_ws/install/setup.bash" && \
        echo "export ROS_DOMAIN_ID=1" >> ~/.bashrc && \
        echo "source /usr/share/colcon_argcomplete/hook/colcon-argcomplete.bash" >> ~/.bashrc && \
        # Create bash aliases (only for ROS builds)
        echo "alias cb='CURRENT_DIR=\`pwd\` && cd ~/colcon_ws/ && colcon build --symlink-install && source ~/.bashrc && cd \${CURRENT_DIR}'" >> /home/${USER}/.bash_aliases && \
        echo "" >> /home/${USER}/.bash_aliases; \
    else \
        echo "ROS is not installed, skipping ROS configuration..."; \
    fi

# User specific environment variables
RUN echo "export PYTHONDONTWRITEBYTECODE=1" >> /home/${USER}/.bash_aliases && \
    echo "export PS1='\[\e[1;33;40m\]\${CONTAINER_NAME}\[\e[0m\] \${debian_chroot:+(\${debian_chroot})}\[\033[01;32m\]\u@\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '" >> /home/${USER}/.bash_aliases
    
##################
# Other settings #
##################
# Run as root user
USER root

# Clean cache
RUN apt-get clean &&\
	apt-get autoremove && \	
    rm -rf /var/lib/apt/lists/* && \
    rm /etc/apt/apt.conf.d/docker-clean

# Set user
USER ${USERNAME}

# Set HOME position
WORKDIR ${HOME}