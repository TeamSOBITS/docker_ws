FROM sobits/ros_noetic_basic_ws:gpu_cuda11.8.0_cudnn8.7
LABEL maintainer Valentin Keith

RUN echo "╔══╣ Install: ros_noetic_sobits_ws:gpu_cuda11.8.0_cudnn8.7 (STARTING) ╠══╗"


ENV WORKPATH /home/sobits

# Run as root user
USER root

# Update sobit_manual
RUN cd $WORKPATH/sobits_manual_mini && \
    git config --global --add safe.directory /home/sobits/sobits_manual_mini && \
    git pull origin main

# Install ROS SOBITS Common Packages
RUN gosu sobits bash $WORKPATH/sobits_manual_mini/install_sh/install_ros1_sobits.sh --noetic

# Install Pytorch 1.13.1
RUN gosu sobits bash $WORKPATH/sobits_manual_mini/install_sh/install_pytorch.sh --1.13.1

# Clean cache
RUN apt-get clean &&\
    apt-get autoremove && \	
    rm -rf /var/lib/apt/lists/


RUN echo "╚══╣ Install: ros_noetic_sobits_ws:gpu_cuda11.8.0_cudnn8.7 (FINISHED) ╠══╝"