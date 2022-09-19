FROM sobits/ros_melodic_basic_ws:cpu
LABEL maintainer Valentin Keith

RUN echo "╔══╣ Install: ros_melodic_sobits_ws:cpu (STARTING) ╠══╗"


ENV WORKPATH /home/sobits

# Run as root user
USER root

# Install ROS SOBITS Common Packages
RUN gosu sobits bash $WORKPATH/sobits_manual_mini/install_sh/install_ros1_sobits.sh --melodic

# Clean cache
RUN apt-get clean &&\
    apt-get autoremove && \	
    rm -rf /var/lib/apt/lists/

RUN echo "╚══╣ Install: ros_melodic_sobits_ws:cpu (FINISHED) ╠══╝"