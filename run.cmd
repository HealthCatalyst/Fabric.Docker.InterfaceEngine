docker stop fabric.docker.interfaceengine
docker rm fabric.docker.interfaceengine
docker build -t healthcatalyst/fabric.docker.interfaceengine . 
docker run -P --rm --name fabric.docker.interfaceengine -t healthcatalyst/fabric.docker.interfaceengine