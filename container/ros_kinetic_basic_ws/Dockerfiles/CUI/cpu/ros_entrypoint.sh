#!/bin/bash
set -e

# setup ros environment
source /opt/ros/$ROS_DISTRO/setup.bash
source /home/sobits/catkin_ws/devel/setup.bash

# load bashrc
source /home/sobits/.bashrc

#exec "$@"
/bin/bash