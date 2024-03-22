FROM ros:humble-perception

ARG DEBIAN_FRONTEND=noninteractive

SHELL ["/bin/bash", "-c"]
 
# apt packages

RUN apt-get update \
 && apt-get install -y v4l-utils \
 && rm -rf /var/lib/apt/lists/*

# pip packages

RUN apt-get update \
 && apt-get install -y python-pip \
 && rm -rf /var/lib/apt/lists/*

RUN pip install opencv-python scikit-spatial

# Code repository

RUN mkdir -p /ros2_ws/src/

RUN git clone --recurse-submodules \
      https://https://github.com/RobotResearchRepos/RIVeR-Lab_mobile_mocap \
      /ros2_ws/src/mobile_mocap

RUN . /opt/ros/$ROS_DISTRO/setup.bash \
 && apt-get update \
 && rosdep install -r -y \
     --from-paths /ros2_ws/src \
     --ignore-src \
 && rm -rf /var/lib/apt/lists/*

RUN . /opt/ros/$ROS_DISTRO/setup.bash \
 && cd /ros2_ws \
 && colcon build
 
