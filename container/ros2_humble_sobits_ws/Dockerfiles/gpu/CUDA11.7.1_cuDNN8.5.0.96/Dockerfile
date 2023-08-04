FROM sobits/ros2_humble_basic_ws:gpu_cuda11.7.1_cudnn8.5.0.96
LABEL maintainer Valentin Keith

RUN echo "╔══╣ Install: ros2_humble_sobits_ws:gpu_cuda11.7.1_cudnn8.5.0.96 (STARTING) ╠══╗"


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
# RUN bash $WORKPATH/sobits_manual_mini/install_sh/install_ros2_sobits.sh --humble

# Install Pytorch 2.0.1
RUN bash $HOMEPATH/sobits_manual_mini/install_sh/install_pytorch.sh --2.0.1


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

# Clean cache
RUN apt-get clean &&\
    apt-get autoremove && \	
    rm -rf /var/lib/apt/lists/


RUN echo "╚══╣ Install: ros2_humble_sobits_ws:gpu_cuda11.7.1_cudnn8.5.0.96 (FINISHED) ╠══╝"