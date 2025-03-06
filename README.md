1. 도커 이미지 빌드
docker build -t <이미지 이름> .  
.는 현재 작업경로를 의미

2. 이미지 확인
이미지가 잘 빌드되었는지 확인  
docker images

3. 컨테이너 실행  
- 기본
    docker run -d -it --name <컨테이너 이름> <이미지 이름>  
    docker start ROS
    
- 포트 (-p 옵션)
    docker run -it --name <컨테이너 이름> -p 9090:9090 <이미지 이름>  
    -> 로스 브릿지는 9090을 이용

4. 컨테이너 접속  
docker exec -it ROS /bin/bash  
--> 기본적으로 bash를 실행한다.

5. catkin 환경 변수 선언  
source ~/catkin_ws/devel/setup.bash
