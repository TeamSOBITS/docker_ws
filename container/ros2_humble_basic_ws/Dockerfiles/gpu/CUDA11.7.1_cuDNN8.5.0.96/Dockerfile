FROM sobits/base_ws:gpu_cuda11.7.1_cudnn8.5.0.96_ubuntu2204
LABEL maintainer Valentin Keith


RUN echo "╔══╣ Install: ros2_humble_basic_ws:gpu_cuda11.7.1_cudnn8.5.0.96 (STARTING) ╠══╗"


########################
# Environment variable #
########################
ARG GIT_PSW
ENV HOMEPATH /home/sobits


####################################################
# Clone sobits_manual repository (only install_sh) #
####################################################
# Reference: https://stackoverflow.com/questions/600079/how-do-i-clone-a-subdirectory-only-of-a-git-repository

# Run as user sobits
USER sobits

# Clone only installation_sh from SOBITS Manual
RUN cd $HOMEPATH && \
    mkdir sobits_manual_mini && \
    cd sobits_manual_mini && \
    git init && \
    git remote add -f origin https://${GIT_PSW}@github.com/TeamSOBITS/sobits_manual && \
    git config core.sparseCheckout true && \
    echo "install_sh" >> .git/info/sparse-checkout && \
    git pull origin main && \
    cd install_sh


###################################
# Install ROS2 & create catkin_ws #
###################################
# Run as sobits user
USER sobits

RUN bash $HOMEPATH/sobits_manual_mini/install_sh/install_ros2.sh --humble && \
    bash $HOMEPATH/sobits_manual_mini/install_sh/install_ros2_colcon_ws.sh --humble && \
	bash $HOMEPATH/sobits_manual_mini/install_sh/setup_ros2.sh --humble


#################
# chmod Setting #
#################
# Run as root user
USER root

RUN chmod 755 $HOMEPATH/sobits_manual_mini/install_sh/chmod_all.py


#################
# Alias Setting #
#################
# Run as sobits user
USER sobits

RUN bash $HOMEPATH/sobits_manual_mini/install_sh/setup_alias.sh

RUN . $HOMEPATH/.bashrc


###########################
# Install useful programs #
###########################
# Run as sobits user
USER sobits

# install google_chrome
RUN bash $HOMEPATH/sobits_manual_mini/install_sh/install_google_chrome.sh


##################
# Other settings #
##################
# Run as root user
USER root

# Set time zone (Tokyo)
ENV TZ Asia/Tokyo

# Set Language
RUN locale-gen ja_JP.UTF-8
ENV LANG ja_JP.UTF-8
ENV LANGUAGE ja_JP:ja
ENV LC_ALL ja_JP.UTF-8

# Clean cache
RUN apt-get clean &&\
	apt-get autoremove && \	
    rm -rf /var/lib/apt/lists/

# Set user
ENV USER sobits

# Set HOME position
WORKDIR $HOMEPATH


RUN echo "╚══╣ Install: ros2_humble_basic_ws:gpu_cuda11.7.1_cudnn8.5.0.96 (FINISHED) ╠══╝"