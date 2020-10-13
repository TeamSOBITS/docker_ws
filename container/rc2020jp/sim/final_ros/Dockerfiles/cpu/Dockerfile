FROM sobits/ros_kinetic_basic_ws

MAINTAINER Kouta Ohishi

#install tensorflow==1.5.0
RUN apt-get update && \
    apt-get remove -y python-enum34 &&\
    pip install \
    tensorflow==1.5.0 \
    keras==2.2.0


# set Language
RUN locale-gen ja_JP.UTF-8
ENV LANG ja_JP.UTF-8
ENV LANGUAGE ja_JP:ja
ENV LC_ALL ja_JP.UTF-8

# clean cache
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/
