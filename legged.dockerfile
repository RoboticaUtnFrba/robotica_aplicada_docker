FROM robotica:webots_ros1_noetic

USER root

# APT Dependencies
COPY dependencies.legged dependencies.legged
RUN apt-get update && \
    xargs -a dependencies.legged apt-get install -y -qq

# Install with CMake
## DogBot API
RUN git clone https://github.com/eborghi10/DogBotSoftware.git -b api-ubuntu-focal \
    && mkdir DogBotSoftware/API/build && cd DogBotSoftware/API/build \
	&& cmake ../src && make -j$(nproc) \
	&& sudo make install \
    && sudo ldconfig
## ifopt
RUN git clone https://github.com/ethz-adrl/ifopt.git -b master \
    && mkdir ifopt/build && cd ifopt/build \
	&& cmake .. && make -j$(nproc) \
	&& sudo make install \
    && sudo ldconfig
## Towr
RUN git clone https://github.com/eborghi10/towr.git -b ${ROS_DISTRO}-devel \
    && mkdir towr/towr/build && cd towr/towr/build \
	&& cmake .. -DCMAKE_BUILD_TYPE=Release && make -j$(nproc) \
	&& sudo make install \
    && sudo ldconfig

# Install ROS packages from source
ENV LEGGED_WS=/legged_ws
RUN mkdir -p ${LEGGED_WS}/src
WORKDIR ${LEGGED_WS}/src
RUN apt-get install -yqq python3-catkin-tools python3-vcstool
COPY legged.repos ${LEGGED_WS}/src/legged.repos
RUN vcs import . < legged.repos --recursive
WORKDIR $LEGGED_WS
# Remove CMake package
RUN rm -rf ${LEGGED_WS}/src/towr/towr
RUN apt-get update
USER $USER
RUN rosdep install --from-paths src --rosdistro=${ROS_DISTRO} -yi -r
USER root
RUN /bin/bash -c ". /opt/ros/${ROS_DISTRO}/setup.bash; \
    catkin_make -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/opt/ros/${ROS_DISTRO}; \
    cd build; make install"
RUN rm -r ${LEGGED_WS}

COPY requirements.legged.txt requirements.legged.txt
RUN cat requirements.legged.txt | xargs pip3 install

CMD [ "/bin/bash", "-c" ]
