FROM sobits/ros_noetic_basic_ws_gpu_cuda11.3_cudnn8.2:latest

LABEL maintainer Yuki Ikeda

ENV WORKPATH /home/sobits


# Install ROS SOBITS Common Packages
RUN gosu sobits bash $WORKPATH/sobits_manual/install_sh/install_ros1.sh

# Install ROS SOBITS Common Packages
RUN gosu sobits bash $WORKPATH/sobits_manual/install_sh/install_pytorch.sh --1.11.0


# Run as root user
USER root

# clean cache
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/

RUN echo "Install Finished"