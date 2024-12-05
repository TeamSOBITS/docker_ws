FROM sobits/base_ws:cpu_ubuntu2204
LABEL maintainer="Valentin Keith"


RUN echo "╔══╣ Install: ros2_humble_basic_ws:cpu (STARTING) ╠══╗"


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


####################################################
# Clone sobits_manual repository (only install_sh) #
####################################################
# Reference: https://stackoverflow.com/questions/600079/how-do-i-clone-a-subdirectory-only-of-a-git-repository

# Run as user sobits
USER ${USER_NAME}

# Clone only installation_sh from SOBITS Manual
RUN cd ${HOMEPATH} && \
    mkdir sobits_manual_mini && \
    cd sobits_manual_mini && \
    git init && \
    git remote add -f origin https://${GIT_PSW}@github.com/TeamSOBITS/sobits_manual && \
    git config core.sparseCheckout true && \
    echo "install_sh" >> .git/info/sparse-checkout && \
    git pull origin main && \
    cd install_sh


###################################
# Install ROS2 & create catkin_ws #
###################################
# Run as sobits user
USER ${USER_NAME}

RUN bash ${HOMEPATH}/sobits_manual_mini/install_sh/install_ros2.sh --humble && \
    bash ${HOMEPATH}/sobits_manual_mini/install_sh/install_ros2_colcon_ws.sh --humble && \
	bash ${HOMEPATH}/sobits_manual_mini/install_sh/setup_ros2.sh --humble && \
    bash ${HOMEPATH}/sobits_manual_mini/install_sh/setup_alias.sh --ros2


#################
# chmod Setting #
#################
# Run as root user
USER root

RUN chmod 755 ${HOMEPATH}/sobits_manual_mini/install_sh/chmod_all.py


###########################
# Install useful programs #
###########################
# Run as sobits user
USER ${USER_NAME}

# install google_chrome
RUN bash ${HOMEPATH}/sobits_manual_mini/install_sh/install_google_chrome.sh


##################
# Other settings #
##################
# Run as root user
USER root

# Clean cache
RUN apt-get clean &&\
	apt-get autoremove && \	
    rm -rf /var/lib/apt/lists/

# Set user
ENV USER=${USER_NAME}
USER ${USER_NAME}

# Set HOME position
WORKDIR ${HOMEPATH}


RUN echo "╚══╣ Install: ros2_humble_basic_ws:cpu (FINISHED) ╠══╝"