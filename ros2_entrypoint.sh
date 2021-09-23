#!/bin/bash
set -e

source "/opt/ros/foxy/setup.bash"
[ -f $HOME/colcon_ws/install/local_setup.bash ] && source "$HOME/colcon_ws/install/local_setup.bash"
sudo chown -R $USER $HOME/colcon_ws
exec "$@"
