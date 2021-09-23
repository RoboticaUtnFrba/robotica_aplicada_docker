ARG UBUNTU
FROM robotica:ubuntu_${UBUNTU}

ARG ROS
ENV ROS_DISTRO=${ROS}

USER root

# Install ROS

# Setup keys for ROS
RUN curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg
RUN echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/ros2.list > /dev/null

# Install ROS packages
COPY dependencies.ros2 dependencies.ros2
RUN apt-get update && \
  xargs -a dependencies.ros2 apt-get install -y -qq

# Automatically source ROS workspace
RUN echo ". /opt/ros/${ROS_DISTRO}/setup.bash" >> /home/$USER/.bashrc
ENV COLCON_SETUP_BASH "/home/${USER}/colcon_ws/install/local_setup.bash"
RUN echo "[[ -f ${COLCON_SETUP_BASH} ]] && . ${COLCON_SETUP_BASH}" >> /home/$USER/.bashrc

# Initialize rosdep
RUN rosdep init
USER $USER
# HOME needs to be set explicitly. Without it, the HOME environment variable is set to "/"
RUN HOME=/home/$USER rosdep update

######################################################

# setup entrypoint
USER root
COPY ./ros2_entrypoint.sh /
RUN chmod +x /ros2_entrypoint.sh

ENTRYPOINT [ "/ros2_entrypoint.sh" ]
CMD [ "/bin/bash", "-c" ]
