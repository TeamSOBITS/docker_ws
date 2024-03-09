FROM sobits/ros_noetic_basic_ws:gpu_cuda11.6.2_cudnn8.4
LABEL maintainer Valentin Keith

RUN echo "╔══╣ Install: ros_noetic_sobits_ws:gpu_cuda11.6.2_cudnn8.4 (STARTING) ╠══╗"


########################
# Environment variable #
########################
ARG GIT_PSW
ENV HOMEPATH /home/sobits


###########################
# Install SOBITS programs #
###########################
# Run as sobits user
USER sobits

# Update sobit_manual
RUN cd $HOMEPATH/sobits_manual_mini && \
    git remote set-url origin https://${GIT_PSW}@github.com/TeamSOBITS/sobits_manual && \
    git pull origin main

# Install ROS SOBITS Common Packages
RUN bash $HOMEPATH/sobits_manual_mini/install_sh/install_ros1_sobits.sh --noetic

# Install Pytorch 1.12.0
RUN bash $HOMEPATH/sobits_manual_mini/install_sh/install_pytorch.sh --1.12.0


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
ENV USER sobits

# Set HOME position
WORKDIR $HOMEPATH


RUN echo "╚══╣ Install: ros_noetic_sobits_ws:gpu_cuda11.6.2_cudnn8.4 (FINISHED) ╠══╝"