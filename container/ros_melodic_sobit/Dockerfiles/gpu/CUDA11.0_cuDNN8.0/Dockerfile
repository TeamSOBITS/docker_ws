FROM sobits/ros_melodic_basic_ws_gpu_cuda11.0_cudnn8.0:latest

LABEL maintainer Yuki Ikeda

# Install Numpy
RUN gosu sobits pip3 install numpy

# Install Pytorch
RUN gosu sobits pip3 install torch torchvision && \
    gosu sobits pip3 install tqdm

# Install matplotlib
RUN gosu sobits pip3 install matplotlib && \
    apt-get update && \
    apt-get install python3-tk

# Install ROS Packages
RUN apt update -y && \
    apt install ros-melodic-rosbridge-* -y && \
    apt install ros-melodic-ecl-* -y && \
    apt install ros-melodic-joy -y && \
    apt install ros-melodic-roswww -y && \
    apt install ros-melodic-kobuki-* -y && \
    apt install ros-melodic-joint-state-publisher* -y &&\
    apt install ros-melodic-uvc-camera -y && \
    apt install ros-melodic-image-view -y && \
    apt install libsensors4-dev -y

# Install PCL
RUN apt update &&\
    apt install ros-melodic-pcl-* -y && \
    apt install ros-melodic-openni2-* -y

# Install joint
RUN apt update &&\
    apt install ros-melodic-joint* -y

# Install ps4 controller
RUN apt-get install ros-melodic-joy

# Install Pybind
RUN apt update &&\
    apt install ros-melodic-pybind11-catkin -y

# Install URG
RUN apt update &&\
    apt install ros-melodic-urg-node -y

# Install SLAM 
RUN apt update &&\
    apt install ros-melodic-map-server -y &&\
    apt install ros-melodic-move-base-* -y &&\
    apt-get install ros-melodic-dwa-local-planner -y

# Install text to speech library
RUN apt update && \
    apt install -y \
    mpg321 \
    open-jtalk \
    open-jtalk-mecab-naist-jdic \
    hts-voice-nitech-jp-atr503-m001 \
    libttspico-utils \
    alsa \
    alsa-utils \
    python-soundfile \
    pulseaudio

# Install sound library
RUN gosu sobits pip3 install \
    gTTS==2.0.1 \
    wave \
    mutagen \
    soundfile && \
    gosu sobits pip3 install gTTS-token --upgrade

# clean cache
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/

RUN echo "Install Finished"