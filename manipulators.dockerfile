FROM robotica:webots_ros1_melodic

USER root

# APT Dependencies
COPY dependencies.manipulators dependencies.manipulators
RUN apt-get update && \
    xargs -a dependencies.manipulators apt-get install -y -qq

RUN pip install numpy

# Install moveit_tutorials
# https://ros-planning.github.io/moveit_tutorials/doc/getting_started/getting_started.html

# Install ROS packages from source
ENV MANIPULATORS_WS=/manipulators_ws
RUN mkdir -p ${MANIPULATORS_WS}/src
WORKDIR ${MANIPULATORS_WS}/src
COPY manipulators.repos ${MANIPULATORS_WS}/src/manipulators.repos
RUN vcs import . < manipulators.repos --recursive
WORKDIR $MANIPULATORS_WS
RUN apt-get update
USER $USER
RUN rosdep install --from-paths src --rosdistro=$ROS_DISTRO -yi -r
USER root
RUN /bin/bash -c ". /opt/ros/${ROS_DISTRO}/setup.bash; \
    catkin_make -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/opt/ros/${ROS_DISTRO}; \
    cd build; make install"
RUN rm -r ${MANIPULATORS_WS}

USER $USER
RUN echo ". /opt/ros/$ROS_DISTRO/setup.bash" >> /home/${USER}/.bashrc
RUN echo "[[ -f /home/${USER}/catkin_ws/devel/setup.bash ]] && . /home/${USER}/catkin_ws/devel/setup.bash" >> /home/${USER}/.bashrc

######################################################

# setup entrypoint
USER root
COPY ros1_entrypoint.sh ros1_entrypoint.sh
RUN chmod +x ros1_entrypoint.sh

ENTRYPOINT ["/bin/bash", "/ros1_entrypoint.sh"]
CMD [ "/bin/bash" ]
