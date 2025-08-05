ARG UBUNTU_VERSION
ARG CUDA_VERSION

FROM nvidia/cuda:${CUDA_VERSION}-cudnn-devel-ubuntu${UBUNTU_VERSION}

###################################
# Environment_variable_preference #
###################################
ARG LOCAL_UID
ARG LOCAL_GID
ARG USER_NAME
ARG INSTALL_ROS
ARG ROS_DISTRO

ENV USER_NAME=${USER_NAME}
ENV USER_ID=${LOCAL_UID:-1000}
ENV GROUP_ID=${LOCAL_GID:-1000}

ENV HOMEPATH=/home/${USER_NAME}

# Set ROS_DISTRO environment variable only if ROS will be installed
RUN if [ "$INSTALL_ROS" = "true" ]; then \
        echo "export ROS_DISTRO=${ROS_DISTRO}" >> /etc/environment; \
    fi

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
RUN apt-get update -q && \
    apt-get install -yq \
        locales \
        locales-all && \
    sed -i '/ja_JP.UTF-8/s/^# //g' /etc/locale.gen
    
RUN locale-gen ja_JP.UTF-8

ENV LANG=ja_JP.UTF-8
ENV LANGUAGE=ja_JP:ja
ENV LC_ALL=ja_JP.UTF-8

# Install basic apps
RUN apt-get update -q && \
    apt-get install -yq \
        language-pack-ja \
        software-properties-common \
        bash-completion \
        lsb-release \
        dpkg-dev \
        alsa-base \
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

#######################
# Add $USER_NAME user #
#######################
# Add sudo user
# Remove existing user with the same UID if it exists
RUN if id -u ${USER_ID} >/dev/null 2>&1; then \
        EXISTING_USER=$(id -nu ${USER_ID}); \
        userdel -r $EXISTING_USER 2>/dev/null || true; \
    fi && \
    useradd --create-home --home-dir ${HOMEPATH} --shell /bin/bash --user-group --groups adm,sudo,audio,video -u ${USER_ID} ${USER_NAME} && \
    groupmod -g ${GROUP_ID} -o ${USER_NAME} && \
    echo ${USER_NAME}:robotgroup | chpasswd && \
    echo "${USER_NAME} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Set user
ENV USER=${USER_NAME}

# Set HOME position
WORKDIR ${HOMEPATH}
RUN /bin/bash -c ". ${HOMEPATH}/.bashrc"

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

# Run as user
USER ${USER_NAME}

# Install pip packages (compatible with both Ubuntu 22.04 and 24.04+)
RUN set -e; \
    # Check Ubuntu version to determine pip installation method
    UBUNTU_VERSION=$(lsb_release -rs); \
    UBUNTU_MAJOR=$(echo $UBUNTU_VERSION | cut -d. -f1); \
    UBUNTU_MINOR=$(echo $UBUNTU_VERSION | cut -d. -f2); \
    \
    if [ "$UBUNTU_MAJOR" -gt 22 ] || ([ "$UBUNTU_MAJOR" -eq 24 ] && [ "$UBUNTU_MINOR" -ge 4 ]); then \
        echo "Ubuntu $UBUNTU_VERSION detected - using --break-system-packages"; \
        # For Ubuntu 24.04+, remove EXTERNALLY-MANAGED file and use --break-system-packages
        sudo rm -f /usr/lib/python3*/EXTERNALLY-MANAGED 2>/dev/null || true; \
        python3 -m pip install -U --break-system-packages pip wheel numpy; \
    else \
        echo "Ubuntu $UBUNTU_VERSION detected - using standard pip installation"; \
        python3 -m pip install -U pip wheel numpy; \
    fi


###################################
# Install ROS & create colcon_ws #
###################################
# Run as root for ROS installation
USER root

# Install ROS only if INSTALL_ROS=true
RUN if [ "$INSTALL_ROS" = "true" ]; then \
        echo "Installing ROS ${ROS_DISTRO}..."; \
        apt update -q && \
        apt install -yq \
            gnupg && \
        curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg && \
        . /etc/os-release && \
        echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $UBUNTU_CODENAME main" | tee /etc/apt/sources.list.d/ros2.list > /dev/null && \
        apt update -q && \
        apt install -yq \
            ros-${ROS_DISTRO}-desktop \
            python3-colcon-common-extensions \
            python3-rosdep && \
        rosdep init; \
    else \
        echo "Skipping ROS installation..."; \
    fi

# Switch back to user for workspace setup
USER ${USER_NAME}

# Configure ROS environment only if ROS is installed
RUN if [ "$INSTALL_ROS" = "true" ]; then \
        /bin/bash -c "source /opt/ros/${ROS_DISTRO}/setup.bash && source ~/.bashrc" && \
        rosdep update && \
        mkdir -p ~/colcon_ws/src && \
        echo "source /opt/ros/${ROS_DISTRO}/setup.bash" >> ~/.bashrc && \
        echo "export ROS_DOMAIN_ID=1" >> ~/.bashrc && \
        echo "source /usr/share/colcon_cd/function/colcon_cd.sh" >> ~/.bashrc && \
        echo "export _colcon_cd_root=/opt/ros/${ROS_DISTRO}/" >> ~/.bashrc && \
        echo "source /usr/share/colcon_argcomplete/hook/colcon-argcomplete.bash" >> ~/.bashrc && \
        echo "source ~/colcon_ws/install/setup.bash" >> ~/.bashrc; \
    else \
        echo "ROS not installed, skipping ROS configuration..."; \
    fi

# Create bash aliases (only for ROS builds)
RUN if [ "$INSTALL_ROS" = "true" ] || [ "$INSTALL_ROS" = "True" ] || [ "$INSTALL_ROS" = "TRUE" ]; then \
        echo "alias cb='CURRENT_DIR=\`pwd\` && cd /home/\${USER}/colcon_ws/ && colcon build --symlink-install && source ~/.bashrc && cd \${CURRENT_DIR}'" >> /home/${USER}/.bash_aliases && \
        echo "" >> /home/${USER}/.bash_aliases; \
    fi

# User specific environment variables
RUN echo "export PYTHONDONTWRITEBYTECODE=1" >> /home/${USER}/.bash_aliases && \
    echo "export PS1='\[\e[1;33;40m\]\$CONTAINER_NAME\[\e[0m\] \${debian_chroot:+(\$debian_chroot)}\[\033[01;32m\]\u@\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '" >> /home/${USER}/.bash_aliases && \
    echo "export EDITOR='nano'" >> /home/${USER}/.bash_aliases

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
USER ${USER_NAME}

# Set HOME position
WORKDIR ${HOMEPATH}

# Create entrypoint script
RUN echo '#!/bin/bash' > ${HOMEPATH}/entrypoint.sh && \
    echo 'set -e' >> ${HOMEPATH}/entrypoint.sh && \
    if [ "$INSTALL_ROS" = "true" ] || [ "$INSTALL_ROS" = "True" ] || [ "$INSTALL_ROS" = "TRUE" ]; then \
        echo 'if [ -d "${HOMEPATH}/colcon_ws/src" ]; then' >> ${HOMEPATH}/entrypoint.sh; \
        echo '    find ${HOMEPATH}/colcon_ws/src \( -name "*.py" -o -name "*.sh" \) -exec chmod 755 {} +' >> ${HOMEPATH}/entrypoint.sh; \
        echo 'fi' >> ${HOMEPATH}/entrypoint.sh; \
        echo 'source /opt/ros/${ROS_DISTRO}/setup.bash 2>/dev/null || true' >> ${HOMEPATH}/entrypoint.sh; \
    fi && \
    echo 'exec "$@"' >> ${HOMEPATH}/entrypoint.sh && \
    chmod +x ${HOMEPATH}/entrypoint.sh

ENTRYPOINT ["bash", "-c", "${HOMEPATH}/entrypoint.sh bash"]