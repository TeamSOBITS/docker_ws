FROM sobits/ros_noetic_basic_ws_gpu_cuda11.3_cudnn8.2:latest
LABEL maintainer Valentin Keith


ENV WORKPATH /home/sobits

# Run as root user
USER root

# Install ROS SOBITS Common Packages
RUN gosu sobits bash $WORKPATH/sobits_manual/install_sh/install_ros1_sobits.sh --noetic

# Install Pytorch 1.11.0
RUN gosu sobits bash $WORKPATH/sobits_manual/install_sh/install_pytorch.sh --1.11.0

# clean cache
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/

RUN echo "Install Finished"