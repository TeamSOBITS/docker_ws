#!/bin/bash
set -e

# setup ros2 environment
find $HOMEPATH/colcon_ws/src \( -name "*.py" -o -name "*.sh" \) -exec chmod 755 {} +
source "/opt/ros/${ROS_DISTRO}/setup.bash"
exec "$@"