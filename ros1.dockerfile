FROM robotica:base

# Install ROS Melodic
# Setup sources.list for ROS
RUN echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list
# Setup keys for ROS
RUN curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | apt-key add -
# Install ROS packages
COPY dependencies.ros1 dependencies.ros1
RUN apt-get update && \
  xargs -a dependencies.ros1 apt-get install -y -qq

ENV ROS_DISTRO=noetic

# Automatically source ROS workspace
RUN echo ". /opt/ros/${ROS_DISTRO}/setup.bash" >> /home/${USER}/.bashrc
ENV CATKIN_SETUP_BASH "/home/${USER}/catkin_ws/devel/setup.bash"
RUN echo "[[ -f ${CATKIN_SETUP_BASH} ]] && . ${CATKIN_SETUP_BASH}" >> /home/${USER}/.bashrc

# Initialize rosdep
RUN rosdep init
USER $USER
# HOME needs to be set explicitly. Without it, the HOME environment variable is set to "/"
RUN HOME=/home/$USER rosdep update
