FROM sobits/ros_noetic_basic_ws:gpu_cuda12.5.1_cudnn9.2
LABEL maintainer="Valentin Keith"

RUN echo "╔══╣ Install: ros_noetic_sobits_ws:gpu_cuda12.5.1_cudnn9.2 (STARTING) ╠══╗"


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


###########################
# Install SOBITS programs #
###########################
# Run as sobits user
USER ${USER_NAME}

# Update sobit_manual
RUN cd ${HOMEPATH}/sobits_manual_mini && \
    git remote set-url origin https://${GIT_PSW}@github.com/TeamSOBITS/sobits_manual && \
    git pull origin main

# Install Pytorch 2.5.1
RUN bash ${HOMEPATH}/sobits_manual_mini/install_sh/install_pytorch.sh --2.4.1


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


RUN echo "╚══╣ Install: ros_noetic_sobits_ws:gpu_cuda12.5.1_cudnn9.2 (FINISHED) ╠══╝"
