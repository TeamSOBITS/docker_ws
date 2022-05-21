FROM sobits/ros_noetic_basic_ws:latest

LABEL maintainer Valentin Keith

ENV WORKPATH /home/sobits


# Install ROS SOBITS Common Packages
RUN gosu sobits bash $WORKPATH/sobits_manual/install_sh/install_ros1.sh

# Run as root user
USER root

# clean cache
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/

RUN echo "Install Finished"