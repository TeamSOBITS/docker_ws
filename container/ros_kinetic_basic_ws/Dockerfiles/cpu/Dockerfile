FROM sobits/ros_kinetic_basic_ws 

# set terminal style
ARG IMAGE_NAME
ENV IMAGE_NAME ${IMAGE_NAME:-production}
RUN echo "export PS1='\[\e[1;33;40m\]${IMAGE_NAME}\[\e[0m\] ${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '" >> /home/sobits/.bashrc

# clean cache
RUN apt-get clean &&\
	apt-get autoremove && \	
    	rm -rf /var/lib/apt/lists/

