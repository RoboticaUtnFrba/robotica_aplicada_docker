FROM robotica:ros2

# Install Webots
WORKDIR /home/${USER}
COPY dependencies.webots dependencies.webots
RUN wget -qO- https://cyberbotics.com/Cyberbotics.asc | apt-key add -
RUN apt-add-repository 'deb https://cyberbotics.com/debian/ binary-amd64/'
RUN apt-get update && \
  xargs -a dependencies.webots apt-get install -y -qq

ENV WEBOTS_HOME=/usr/local/webots
# https://cyberbotics.com/doc/guide/running-extern-robot-controllers#running-extern-robot-controllers
ENV PYTHONPATH=${PYTHONPATH}:${WEBOTS_HOME}/lib/controller/python27
ENV LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:${WEBOTS_HOME}/lib/controller
RUN usermod -aG audio ${USER}

# Webots config
RUN mkdir -p /home/${USER}/.config/Cyberbotics
COPY --chown=${USER}:${USER} Webots-R2021a.conf /home/${USER}/.config/Cyberbotics/Webots-R2021a.conf
RUN chown -R ${USER}:${USER} /home/${USER}/.config/Cyberbotics
