FROM sobits/ros_melodic_basic_ws:cpu
LABEL maintainer Valentin Keith

RUN echo "╔══╣ Install: ros_melodic_sobits_ws:cpu (STARTING) ╠══╗"


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
RUN bash $HOMEPATH/sobits_manual_mini/install_sh/install_ros1_sobits.sh --melodic

# Install Pytorch 2.0.1
# RUN bash $HOMEPATH/sobits_manual_mini/install_sh/install_pytorch.sh --2.0.1


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

RUN echo "╚══╣ Install: ros_melodic_sobits_ws:cpu (FINISHED) ╠══╝"