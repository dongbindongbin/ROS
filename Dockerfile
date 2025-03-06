# ROS Melodic 기반의 공식 Docker 이미지를 사용
# Ubuntu 18.04(Bionic) 기반
FROM ros:melodic

# 필수 패키지 설치
RUN apt-get update && apt-get install -y \
    curl \
    gnupg2 \
    lsb-release \
    build-essential \
    python-rosdep \
    python-rosinstall \
    python-rosinstall-generator \
    python-wstool \
    git \
    net-tools \
    ros-melodic-rosbridge-server \
    ros-melodic-velodyne \
    terminator \
    libvulkan1 \
    python3 \
    python3-pip \
    python3.8 \
    python3.8-distutils \
    libproj-dev

# ROS 패키지 저장소를 추가하고, ROS Melodic Desktop Full 패키지 설치
RUN sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list' \
    && curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | apt-key add -

# ROS 패키지 설치
RUN apt-get update && apt-get install -y ros-melodic-desktop-full

# rosdep 초기화 및 업데이트
RUN if [ -f /etc/ros/rosdep/sources.list.d/20-default.list ]; then \
        rm /etc/ros/rosdep/sources.list.d/20-default.list; \
    fi && \
    rosdep init && \
    rosdep update

# Catkin workspace 설정 및 MORAI 메시지 패키지 클론 및 빌드
RUN /bin/bash -c "source /opt/ros/melodic/setup.bash && \
    mkdir -p /root/catkin_ws/src && \
    cd /root/catkin_ws/src && \
    catkin_create_pkg ssafy_ad rospy std_msgs && \
    git clone https://github.com/MORAI-Autonomous/MORAI-ROS_morai_msgs && \
    cd /root/catkin_ws && \
    catkin_make"

# pip 업그레이드 및 추가 Python 패키지 설치
RUN pip3 install --upgrade pip && \
    pip3 install pyproj scikit-learn

# 컨테이너 시작 시 ROS 환경 설정을 자동으로 적용
RUN echo "source /opt/ros/melodic/setup.bash" >> /root/.bashrc

# 기본 작업 디렉토리
WORKDIR /root/catkin_ws

# 기본으로 bash 셸을 실행
# 커스텀으로 roslaunch등을 추가해도 됨.
CMD ["bash"]
