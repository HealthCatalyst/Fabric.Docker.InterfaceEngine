docker stop fabric.docker.interfaceengine
docker rm fabric.docker.interfaceengine
docker build -t healthcatalyst/fabric.docker.interfaceengine . 
docker run -p 8080:8080 -p 8443:8443 -p 6661:6661 --rm --name fabric.docker.interfaceengine -t healthcatalyst/fabric.docker.interfaceengine