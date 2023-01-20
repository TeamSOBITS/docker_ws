# 参考① https://gitlab.com/nvidia/container-images/cuda/-/tree/master/dist
# 参考② https://catalog.ngc.nvidia.com/orgs/nvidia/containers/cuda/tags


FROM sobits/base_ws:gpu_cuda11.6.2_cudnn8.4_ubuntu2004 as mid_layer
LABEL maintainer Valentin Keith


RUN echo "╔══╣ Install: ros_noetic_basic_ws:gpu_cuda11.6.2_cudnn8.4 (STARTING) ╠══╗"


ENV HOMEPATH /home/sobits

####################################################
# Clone sobits_manual repository (only install_sh) #
####################################################
# 参考：https://stackoverflow.com/questions/600079/how-do-i-clone-a-subdirectory-only-of-a-git-repository

# Run as user sobits
USER sobits

# Clone only installation_sh from SOBITS Manual
RUN cd $HOMEPATH && \
    mkdir sobits_manual_mini && \
    cd sobits_manual_mini && \
    git init && \
    git remote add -f origin https://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@github.com/TeamSOBITS/sobits_manual && \
    git config core.sparseCheckout true && \
    echo "install_sh" >> .git/info/sparse-checkout && \
    git pull origin main && \
    cd install_sh



###################################
# Install ROS1 & create catkin_ws #
###################################
# Run as root user
USER root

RUN gosu sobits bash $HOMEPATH/sobits_manual_mini/install_sh/install_ros1.sh --noetic && \
    gosu sobits bash $HOMEPATH/sobits_manual_mini/install_sh/install_ros1_catkin_ws.sh --noetic && \
	gosu sobits bash $HOMEPATH/sobits_manual_mini/install_sh/setup_ros1.sh


#################
# chmod Setting #
#################
# Run as root user
USER root

RUN chmod 755 $HOMEPATH/sobits_manual_mini/install_sh/chmod_all.py


#################
# Alias Setting #
#################
# Run as user sobits
USER root

RUN gosu sobits bash $HOMEPATH/sobits_manual_mini/install_sh/setup_alias.sh

RUN . $HOMEPATH/.bashrc


###########################
# Install useful programs #
###########################
# Run as root user
USER root

# install google_chrome
RUN gosu sobits bash $HOMEPATH/sobits_manual_mini/install_sh/install_google_chrome.sh



# マルチステージビルド(image layer の内容を隠す処理)
FROM sobits/base_ws:gpu_cuda11.6.2_cudnn8.4_ubuntu2004
COPY --from=mid_layer / /


##################
# Other settings #
##################
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
WORKDIR /home/sobits/


RUN echo "╚══╣ Install: ros_noetic_basic_ws:gpu_cuda11.6.2_cudnn8.4 (FINISHED) ╠══╝"