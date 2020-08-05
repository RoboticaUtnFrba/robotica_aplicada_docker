FROM robotica:webots

USER root

# APT Dependencies
COPY dependencies.amr dependencies.amr
RUN apt-get update && \
    xargs -a dependencies.amr apt-get install -y -qq

# Install ROS packages from source
ENV AMR_WS=/autonomous_mobile_robots_ws
RUN mkdir -p ${AMR_WS}/src
WORKDIR ${AMR_WS}/src
RUN apt-get install -yqq python3-catkin-tools python3-vcstool
COPY amr.repos ${AMR_WS}/src/amr.repos
RUN vcs import . < amr.repos --recursive
WORKDIR $AMR_WS
RUN apt-get update
USER $USER
RUN rosdep install --from-paths src --rosdistro=foxy -yi -r
USER root
RUN /bin/bash -c ". /opt/ros/foxy/setup.bash; \
    colcon build --symlink-install --merge-install --install-base /opt/ros"
RUN rm -r ${AMR_WS}

CMD [ "/bin/bash", "-c" ]
