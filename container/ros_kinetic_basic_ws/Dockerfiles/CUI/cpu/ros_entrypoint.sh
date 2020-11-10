#!/bin/bash
set -e

# setup ros environment
source "/opt/ros/$ROS_DISTRO/setup.bash"

# load bashrc
source "/home/sobits/.bashrc"
exec "$@"
