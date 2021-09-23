FROM robotica:ros2

USER root

# APT Dependencies
COPY dependencies.amr dependencies.amr
RUN apt-get update && \
    xargs -a dependencies.amr apt-get install -y -qq

ENV TURTLEBOT3_MODEL=burger
ENV GAZEBO_MODEL_PATH=$GAZEBO_MODEL_PATH:/opt/ros/foxy/share/turtlebot3_gazebo/models

CMD [ "/bin/bash", "-c" ]
