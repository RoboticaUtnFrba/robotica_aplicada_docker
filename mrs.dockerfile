FROM robotica:drones

USER root

# Python dependencies
RUN apt-get update && \
    apt-get install -y -qq python3-pip
RUN wget -q \
    https://raw.githubusercontent.com/OPT4SMART/ChoiRbot/master/requirements_disropt.txt \
    https://raw.githubusercontent.com/OPT4SMART/ChoiRbot/master/requirements.txt
RUN pip3 install -r requirements.txt && \
    pip3 install -r requirements_disropt.txt && \
    pip3 install --no-deps disropt

# Multirobots dependencies
COPY dependencies.mrs dependencies.mrs
RUN apt-get update && \
    xargs -a dependencies.mrs apt-get install -y -qq

# Install husky from source
ENV DEPS_WS=/deps_ws
RUN mkdir -p ${DEPS_WS}/src
WORKDIR ${DEPS_WS}/src
RUN apt-get install -y python3-catkin-tools python3-vcstool
COPY mrs.repos ${DEPS_WS}/src/mrs.repos
RUN vcs import . < mrs.repos
WORKDIR ${DEPS_WS}
RUN apt-get update
USER ${USER}
RUN rosdep install --from-paths src --rosdistro=noetic -yi -r
USER root
RUN /bin/bash -c ". /opt/ros/noetic/setup.bash; \
    catkin_make -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/opt/ros/noetic; \
    cd build; make install"
RUN rm -r ${DEPS_WS}

CMD [ "/bin/bash", "-c" ]
