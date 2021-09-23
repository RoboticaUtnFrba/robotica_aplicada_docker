#!/bin/bash
set -e

source "/opt/ros/$ROS_DISTRO/setup.bash"
[ -f $HOME/catkin_ws/devel/setup.bash ] && source "$HOME/catkin_ws/devel/setup.bash"
sudo chown -R $USER $HOME/catkin_ws
exec "$@"
