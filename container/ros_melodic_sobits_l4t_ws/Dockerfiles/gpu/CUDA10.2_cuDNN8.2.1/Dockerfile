FROM sobits/ros_melodic_basic_ws:gpu_cuda10.2_cudnn8.2.1_l4t
LABEL maintainer Valentin Keith

RUN echo "╔══╣ Install:ros_melodic_basic_ws:gpu_cuda10.2_cudnn8.2.1_l4t (STARTING) ╠══╗"


ENV WORKPATH /home/sobits

# Run as root user
USER root

# Install ROS SOBITS Common Packages
RUN gosu sobits bash $WORKPATH/sobits_manual_mini/install_sh/install_ros1_sobits.sh --melodic

# Install Pytorch 1.11.0
# RUN gosu sobits bash $WORKPATH/sobits_manual_mini/install_sh/install_pytorch.sh --1.12.0

# Clean cache
RUN apt-get clean &&\
    apt-get autoremove && \	
    rm -rf /var/lib/apt/lists/


RUN echo "╚══╣ Install: ros_melodic_basic_ws:gpu_cuda10.2_cudnn8.2.1_l4t (FINISHED) ╠══╝"