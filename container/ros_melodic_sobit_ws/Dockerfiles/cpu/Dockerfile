FROM sobits/ros_melodic_basic_ws:latest

LABEL maintainer Yuki Ikeda

# Install ROS Common Packages
RUN apt-get update -q && \
    apt-get install -yq \
        ros-melodic-rosbridge-* \
        ros-melodic-ecl-* \
        ros-melodic-joy \
        ros-melodic-roswww \
        ros-melodic-kobuki-* \
        ros-melodic-joint-state-publisher* \
        ros-melodic-uvc-camera \
        ros-melodic-image-view \
        libsensors4-dev 

# Install PCL
RUN apt-get update -q && \
    apt-get install -yq \
        ros-melodic-pcl-* \
        ros-melodic-openni2-*

# Install joint
RUN apt update -q && \
    apt install -yq ros-melodic-joint*

# Install ps4 controller
RUN apt-get install -yq ros-melodic-joy

# Install Pybind
RUN apt update -q && \
    apt install -yq ros-melodic-pybind11-catkin

# Install URG
RUN apt update -q && \
    apt install -yq ros-melodic-urg-node

# Install SLAM 
RUN apt update -q && \
    apt install -yq \
        ros-melodic-map-server \
        ros-melodic-move-base-* \
        ros-melodic-dwa-local-planner

# Install text to speech library
RUN apt update && \
    apt install -yq \
        mpg321 \
        open-jtalk \
        open-jtalk-mecab-naist-jdic \
        hts-voice-nitech-jp-atr503-m001 \
        libttspico-utils \
        alsa \
        alsa-utils \
        python-soundfile \
        pulseaudio

# Run as user sobits
USER sobits

# Install sound library
RUN python3 -m pip install \
    gTTS==2.0.1 \
    wave \
    mutagen \
    soundfile && \
    python3 -m pip install gTTS-token --upgrade

# Run as root user
USER root

# clean cache
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/

RUN echo "Install Finished"