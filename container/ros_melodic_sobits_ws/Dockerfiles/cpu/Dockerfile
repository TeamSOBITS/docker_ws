FROM sobits/ros_noetic_basic_ws:cpu
LABEL maintainer Valentin Keith

RUN echo "╔══╣ Install: ros_noetic_sobits_ws CPU (STARTING) ╠══╗"


ENV WORKPATH /home/sobits

# Run as root user
USER root

# Install ROS SOBITS Common Packages
RUN gosu sobits bash $WORKPATH/sobits_manual_mini/install_sh/install_ros1_sobits.sh --noetic

# Clean cache
RUN apt-get clean &&\
    apt-get autoremove && \	
    rm -rf /var/lib/apt/lists/

RUN echo "╚══╣ Install: ros_noetic_sobits_ws CPU (FINISHED) ╠══╝"